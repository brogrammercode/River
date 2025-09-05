import mongoose from "mongoose";
import logger from "../utils/logger.js";
import env from "./env.js";

const { MONGO_URI } = env;

let isConnected = null;

export const connectMongo = async () => {
  if (isConnected) {
    return;
  }

  try {
    const conn = await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    isConnected = conn.connections[0].readyState;
    logger.info(`MONGO_CONNECTED: ${conn.connection.host}`);
  } catch (error) {
    logger.error("ERROR_CONNECTING_MONGO", error);
    throw error;
  }
};
