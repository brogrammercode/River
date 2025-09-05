import express from "express";
import {
  getMe,
  login,
  logout,
  register,
} from "../controllers/auth.controller.js";
import { authenticate } from "../middleware/auth.middleware.js";

const router = express.Router();
router.post("/register", register);
router.post("/login", login);

router.use(authenticate);

router.post("/logout", logout);
router.get("/me", getMe);

export default router;
