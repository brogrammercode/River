import app from "./src/app.js";
import env from "./src/config/env.js";
import { connectMongo } from "./src/config/mongo.js";
import logger from "./src/utils/logger.js";

const { PORT } = env;

connectMongo().then(() => {});
export default app;