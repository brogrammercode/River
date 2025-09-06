import express from "express";
import {
  createItem,
  getUserItems,
  getAssignedItems,
  changeAssignmentToOtherReceiver,
} from "../controllers/item.controller.js";
import { authenticate } from "../middleware/auth.middleware.js";

const router = express.Router();
router.use(authenticate);

router.get("/", getUserItems);
router.get("/assigned", getAssignedItems);
router.post("/", createItem);
router.patch("/:itemID/reassign", changeAssignmentToOtherReceiver);
router.put("/:itemID", updateItem); // PUT /api/items/:itemID

export default router;
