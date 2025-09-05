import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { initLogger } from "./utils/logger.js";
import routes from "./routes/index.js";
import { errorHandler } from "./middleware/error.middleware.js";
const app = express();
app.use(express.json());
app.use(cookieParser());
app.use(
  cors({
    origin: "https://river-ruddy.vercel.app",
    credentials: true,
  })
);
app.use(initLogger);
app.use(errorHandler);

app.use("/api", routes);

export default app;
