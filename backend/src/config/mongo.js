import mongoose from "mongoose";
import logger from "../utils/logger.js";
import env from "./env.js";

const { MONGO_URI } = env;

export const connectMongo = async () => {
  try {
    const conn = await mongoose.connect(MONGO_URI);
    logger.info(`CONGO_MONGO: ${conn.connection.host}`);
  } catch (error) {
    logger.error("ERROR_CONNECTING_CONGO", error);
    process.exit(1);
  }
};
