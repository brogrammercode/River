import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { initLogger } from "./utils/logger.js";
import routes from "./routes/index.js";
import { errorHandler } from "./middleware/error.middleware.js";
const app = express();
app.use(
  cors({
    origin: "https://river-ruddy.vercel.app",
    credentials: true,
  })
);
app.use(express.json());
app.use(cookieParser());
app.get("/", (req, res) => res.send("Server is running!"));
app.use("/api", routes);
app.use(initLogger);
app.use(errorHandler);

export default app;
