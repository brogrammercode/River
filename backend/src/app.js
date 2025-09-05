import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import { initLogger } from "./utils/logger.js";
import routes from "./routes/index.js";
import { errorHandler } from "./middleware/error.middleware.js";
import mongoose from "mongoose";

const app = express();

app.use(
  cors({
    origin: "https://river-ruddy.vercel.app",
    credentials: true,
  })
);
app.use(express.json());
app.use(cookieParser());
app.use(initLogger);
app.use(errorHandler);

app.get("/", (req, res) => res.send("Server is running!"));

app.get("/db-test", async (req, res) => {
  if (!mongoose.connection.db) {
    return res.status(500).send("MongoDB is not connected yet");
  }
  try {
    const collections = await mongoose.connection.db
      .listCollections()
      .toArray();
    res.send(
      "MongoDB is connected! Collections: " +
        collections.map((c) => c.name).join(", ")
    );
  } catch (err) {
    res.status(500).send("MongoDB connection failed: " + err.message);
  }
});

app.use("/api", routes);

export default app;
