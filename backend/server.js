import app from "./src/app.js";
import { connectMongo } from "./src/config/mongo.js";

connectMongo();
export default app;
