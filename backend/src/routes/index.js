import express from "express";
import itemRoutes from "./item.routes.js";
import authRoutes from "./auth.routes.js";

const router = express.Router();

router.get("/", (req, res) => {
  res.json({
    "Welcome to River"
  })
})

router.get("/health", (req, res) => {
  res.json({
    status: "OK",
    timestamp: new Date().toISOString(),
  });
});

router.use("/item", itemRoutes);
router.use("/auth", authRoutes);

export default router;
