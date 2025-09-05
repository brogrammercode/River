import mongoose from "mongoose";
import logger from "../utils/logger.js";
import env from "./env.js";

const { MONGO_URI } = env;

const connectMongo = async () => {
  try {
    // Check if already connected
    if (mongoose.connection.readyState === 1) {
      logger.info("🔗 MongoDB already connected");
      return mongoose.connection;
    }

    // Check if currently connecting
    if (mongoose.connection.readyState === 2) {
      logger.info("⏳ MongoDB connection in progress...");
      // Wait for the existing connection attempt
      return new Promise((resolve, reject) => {
        mongoose.connection.once("connected", resolve);
        mongoose.connection.once("error", reject);
      });
    }

    logger.info("🔌 Connecting to MongoDB...");

    // MongoDB connection options
    const options = {
      maxPoolSize: 10, // Maintain up to 10 socket connections
      serverSelectionTimeoutMS: 5000, // Keep trying to send operations for 5 seconds
      socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
      bufferCommands: false, // Disable mongoose buffering
      bufferMaxEntries: 0, // Disable mongoose buffering
    };

    await mongoose.connect(MONGO_URI, options);

    logger.info(`✅ MongoDB Connected: ${mongoose.connection.host}`);
    logger.info(`📊 Database: ${mongoose.connection.name}`);

    return mongoose.connection;
  } catch (err) {
    logger.error("❌ MongoDB Connection Error:", err.message);
    throw err;
  }
};

// Connection event listeners
mongoose.connection.on("connected", () => {
  logger.info("🟢 Mongoose connected to MongoDB");
});

mongoose.connection.on("error", (err) => {
  logger.error("🔴 Mongoose connection error:", err);
});

mongoose.connection.on("disconnected", () => {
  logger.warn("🟡 Mongoose disconnected from MongoDB");
});

// Handle application termination
process.on("SIGINT", async () => {
  try {
    await mongoose.connection.close();
    logger.info("📴 MongoDB connection closed through app termination");
    process.exit(0);
  } catch (err) {
    logger.error("Error closing MongoDB connection:", err);
    process.exit(1);
  }
});

export default connectMongo;
