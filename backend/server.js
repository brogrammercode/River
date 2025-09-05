import app from "./app.js";
import connectMongo from "./config/mongo.js";
import logger from "./utils/logger.js";
import env from "./config/env.js";
import mongoose from "mongoose";

const { NODE_ENV, PORT } = env;

const startServer = async () => {
  try {
    logger.info("Starting server...");

    // Connect to MongoDB first
    await connectMongo();

    // Wait for connection to be ready
    await waitForMongoConnection();

    // Start the server only after MongoDB is connected
    app.listen(PORT, () => {
      logger.info(`✅ Server started successfully`);
      logger.info(`📍 PORT: ${PORT}`);
      logger.info(
        `🗄️ MongoDB: ${
          mongoose.connection.readyState === 1 ? "Connected" : "Not Connected"
        }`
      );
      logger.info(`🌍 Environment: ${NODE_ENV}`);
    });
  } catch (err) {
    logger.error("❌ Failed to start server:", err.message);
    process.exit(1);
  }
};

// Helper function to wait for MongoDB connection
const waitForMongoConnection = () => {
  return new Promise((resolve, reject) => {
    const timeout = setTimeout(() => {
      reject(new Error("MongoDB connection timeout"));
    }, 10000); // 10 second timeout

    const checkConnection = () => {
      if (mongoose.connection.readyState === 1) {
        clearTimeout(timeout);
        resolve();
      } else {
        setTimeout(checkConnection, 100); // Check every 100ms
      }
    };

    checkConnection();
  });
};

// Handle graceful shutdown
process.on("SIGINT", async () => {
  logger.info("🛑 Gracefully shutting down...");
  try {
    await mongoose.connection.close();
    logger.info("📴 MongoDB connection closed");
    process.exit(0);
  } catch (err) {
    logger.error("Error during shutdown:", err);
    process.exit(1);
  }
});

process.on("unhandledRejection", (reason, promise) => {
  logger.error("Unhandled Rejection at:", promise, "reason:", reason);
  process.exit(1);
});

startServer();

export default app;
