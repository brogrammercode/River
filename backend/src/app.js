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

app.get("/", (req, res) => res.send("Server is running!"));

app.get("/db-test", async (req, res) => {
  try {
    // Check multiple connection states
    const connectionState = mongoose.connection.readyState;
    const stateMap = {
      0: "disconnected",
      1: "connected",
      2: "connecting",
      3: "disconnecting",
    };

    if (connectionState !== 1) {
      return res.status(500).json({
        error: "MongoDB is not connected yet",
        connectionState: stateMap[connectionState],
        readyState: connectionState,
      });
    }

    // Additional check for database availability
    if (!mongoose.connection.db) {
      return res.status(500).json({
        error: "MongoDB database instance not available",
      });
    }

    const collections = await mongoose.connection.db
      .listCollections()
      .toArray();

    res.json({
      message: "MongoDB is connected!",
      connectionState: stateMap[connectionState],
      host: mongoose.connection.host,
      dbName: mongoose.connection.name,
      collections: collections.map((c) => c.name),
    });
  } catch (err) {
    res.status(500).json({
      error: "MongoDB connection test failed",
      message: err.message,
    });
  }
});

app.use("/api", routes);

// ✅ Error handler should be LAST
app.use(errorHandler);

export default app;
