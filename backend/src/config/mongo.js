import mongoose from "mongoose";
import env from "./env.js";

const { MONGO_URI } = env;

const connectMongo = async () => {
  try {
    if (mongoose.connection.readyState === 1) {
      console.log("MONGO_ALREADY_CONNECTED");
      return;
    }

    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 10000,
    });

    console.log("MONGO_CONNECTED:", mongoose.connection.host);
  } catch (err) {
    console.error("MONGO_ERROR:", err.message);
    throw err;
  }
};

export default connectMongo;
