import mongoose from "mongoose";

import app from "./src/app.js";
import env from "./src/config/env.js";
import connectMongo from "./src/config/mongo.js";
import logger from "./src/utils/logger.js";
const { NODE_ENV, PORT } = env;

// await connectMongo();
mongoose
  .connect(
    "mongodb+srv://harshsharma55115:n70eWb1EImf7EsOT@tuto-1.gqteplu.mongodb.net/river_db?retryWrites=true&w=majority&appName=tuto-1"
  )
  .then(() => console.log("MONGO_CONNECTED"))
  .catch((err) => console.error("MONGO_CONNECTION_ERROR", err));

if (NODE_ENV === "development") {
  app.listen(PORT, () => {
    logger.info(`PORT_CONNECTED: ${PORT}`);
  });
}
export default app;
