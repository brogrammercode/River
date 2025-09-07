import { createServer } from "http";
import app from "./src/app.js";
import env from "./src/config/env.js";
import { connectMongo } from "./src/config/mongo.js";
import logger from "./src/utils/logger.js";
import { Server } from "socket.io";

const { PORT } = env;

const server = createServer(app);

const io = new Server(server, {
  cors: {
    origin: "https://river-production.up.railway.app",
    credentials: true,
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
  },
});

io.on("connection", (socket) => {
  logger.info(`SOCKET_CONNECTED: ${socket.id}`);
  socket.on("disconnect", () => {
    logger.info(`SOCKET_DISCONNECTED: ${socket.id}`);
  });
});

app.set("io", io);

connectMongo().then(() => {
  server.listen(PORT, () => {
    logger.info(`APP_CONNECTED: ${PORT}`);
    logger.info(`SOCKE.IO_RUNNING_CONNECTED: ${PORT}`);
  });
});
