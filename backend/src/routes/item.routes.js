import express from "express";
import { createItem, getUserItems } from "../controllers/item.controller.js";

const router = express.Router();
router.get("/", getUserItems); // GET /api/items?userId=xxx&status=pending&page=1&limit=10
router.post("/", createItem); // POST /api/items

export default router;
