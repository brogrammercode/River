import app from "./src/app.js";
import connectMongo from "./src/config/mongo.js";

await connectMongo();
export default app;
