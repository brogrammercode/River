import mongoose from "mongoose";
import logger from "../utils/logger.js";
import env from "./env.js";

const { MONGO_URI } = env;

const connectMongo = async () => {
  try {
    if (mongoose.connection.readyState === 1) {
      logger.info("MONGO_ALREADY_CONNECTED");
      return;
    }

    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 10000,
    });

    logger.info(`MONGO_CONNECTED: ${mongoose.connection.host}`);
  } catch (err) {
    logger.error("MONGO_ERROR:", err.message);
    throw err;
  }
};

export default connectMongo;
