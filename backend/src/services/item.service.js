import Item from "../models/Item.js";
import User from "../models/User.js";
import { CustomError } from "../utils/customError.js";

export class ItemService {
  static async getUserItems({ userID, options = {} }) {
    try {
      const { page = 1, limit = 10, status } = options;
      const skip = (page - 1) * limit;

      const filters = { uid: userID };
      if (status) filters.status = status;

      const items = await Item.find(filters)
        .populate("uid", "name email role")
        .populate("currentlyAssignedTo", "name email role")
        .populate("totalAssignedPeoples.assignedTo", "name email role")
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(parseInt(limit));

      const total = await Item.countDocuments(filters);

      return {
        items,
        pagination: {
          current: parseInt(page),
          total: Math.ceil(total / limit),
          pageCount: items.length,
          totalRecords: total,
        },
      };
    } catch (err) {
      throw new CustomError(err.message || "Failed to fetch user items");
    }
  }

  static async getAssignedItems({ userID, options = {} }) {
    try {
      const { page = 1, limit = 10, status } = options;
      const skip = (page - 1) * limit;

      const filters = { currentlyAssignedTo: userID };
      if (status) filters.status = status;

      const items = await Item.find(filters)
        .populate("uid", "name email role")
        .populate("currentlyAssignedTo", "name email role")
        .populate("totalAssignedPeoples.assignedTo", "name email role")
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(parseInt(limit));

      const total = await Item.countDocuments(filters);

      return {
        items,
        pagination: {
          current: parseInt(page),
          total: Math.ceil(total / limit),
          pageCount: items.length,
          totalRecords: total,
        },
      };
    } catch (err) {
      throw new CustomError(err.message || "Failed to fetch assigned items");
    }
  }

  static async createItem({ itemData, userID, io }) {
    try {
      const adminUsers = await User.find({
        _id: { $ne: userID },
        role: "Receiver",
      });

      if (adminUsers.length === 0) {
        throw new CustomError(
          "No receiver users available to assign this item"
        );
      }

      const randomAdmin =
        adminUsers[Math.floor(Math.random() * adminUsers.length)];

      const newItemData = {
        ...itemData,
        uid: userID,
        currentlyAssignedTo: randomAdmin._id,
        totalAssignedPeoples: [
          {
            assignedTo: randomAdmin._id,
          },
        ],
      };

      const item = new Item(newItemData);
      const savedItem = await item.save();

      const populatedItem = await Item.findById(savedItem._id)
        .populate("uid", "name email role")
        .populate("currentlyAssignedTo", "name email role")
        .populate("totalAssignedPeoples.assignedTo", "name email role");

      if (io) {
        io.emit("data_update", {
          type: "ITEM_CREATED",
          data: populatedItem,
        });
      }

      return populatedItem;
    } catch (err) {
      throw new CustomError(err.message || "Failed to create item");
    }
  }

  static async changeAssignmentToOtherReceiver({ itemID, userID, io }) {
    try {
      const item = await Item.findById(itemID);
      if (!item) throw new CustomError("Item not found");

      if (String(item.currentlyAssignedTo) !== String(userID)) {
        throw new CustomError("You are not the current assignee of this item");
      }

      const otherReceivers = await User.find({
        _id: { $nin: [userID] },
        role: "Receiver",
      });

      if (otherReceivers.length === 0) {
        throw new CustomError("No other receiver available for reassignment");
      }

      const newReceiver =
        otherReceivers[Math.floor(Math.random() * otherReceivers.length)];

      item.currentlyAssignedTo = newReceiver._id;
      item.totalAssignedPeoples.push({
        assignedTo: newReceiver._id,
      });

      await item.save();

      const populatedItem = await Item.findById(item._id)
        .populate("uid", "name email role")
        .populate("currentlyAssignedTo", "name email role")
        .populate("totalAssignedPeoples.assignedTo", "name email role");

      // Emit data update to all clients
      if (io) {
        io.emit("data_update", {
          type: "ITEM_REASSIGNED",
          data: populatedItem,
        });
      }

      return populatedItem;
    } catch (err) {
      throw new CustomError(err.message || "Failed to change assignment");
    }
  }

  static async updateItem({ itemID, userID, updateData, io }) {
    try {
      const item = await Item.findById(itemID);
      if (!item) throw new CustomError("Item not found");

      // if (String(item.uid) !== String(userID)) {
      //   throw new CustomError("You are not authorized to update this item");
      // }

      const allowedFields = ["content", "status"];
      allowedFields.forEach((field) => {
        if (updateData[field] !== undefined) {
          item[field] = updateData[field];
        }
      });

      await item.save();

      const populatedItem = await Item.findById(item._id)
        .populate("uid", "name email role")
        .populate("currentlyAssignedTo", "name email role")
        .populate("totalAssignedPeoples.assignedTo", "name email role");

      // Emit data update to all clients
      if (io) {
        io.emit("data_update", {
          type: "ITEM_UPDATED",
          data: populatedItem,
        });
      }

      return populatedItem;
    } catch (err) {
      throw new CustomError(err.message || "Failed to update item");
    }
  }
}
