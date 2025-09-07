import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { initLogger } from "./utils/logger.js";
import routes from "./routes/index.js";
import { errorHandler } from "./middleware/error.middleware.js";
const app = express();
app.use(
  cors({
    origin: "https://river-production.up.railway.app",
    credentials: true,
    allowedHeaders: ["Content-Type", "Authorization"],
    exposedHeaders: ["Authorization"],
  })
);

app.use(express.json());
app.use(cookieParser());
app.use(initLogger);
app.get("/", (req, res) => res.send("Server is running!"));
app.use("/api", routes);
app.use(errorHandler);

export default app;
