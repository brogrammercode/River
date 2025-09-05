import app from "./app.js";
import connectMongo from "./config/mongo.js";
import logger from "./utils/logger.js";
import env from "./config/env.js";

const { NODE_ENV, PORT } = env;

const startServer = async () => {
  try {
    await connectMongo();
    if (NODE_ENV === "development") {
      app.listen(PORT, () => {
        logger.info(`PORT_CONNECTED: ${PORT}`);
      });
    }
  } catch (err) {
    logger.error("Failed to start server:", err);
    process.exit(1);
  }
};

startServer();

export default app;
