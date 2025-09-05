import Item from "../models/Item.js";
import { CustomError } from "../utils/customError.js";

export class ItemService {
  static async getUserItems({ userID, options = {} }) {
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
        count: items.length,
        totalRecords: total,
      },
    };
  }

  static async createItem({ itemData, userID }) {
    const adminUsers = await User.find({
      _id: { $ne: userID },
      role: "admin",
    });

    if (adminUsers.length === 0) {
      throw new CustomError("No admin users available to assign this item");
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

    return await Item.findById(savedItem._id)
      .populate("uid", "name email role")
      .populate("currentlyAssignedTo", "name email role")
      .populate("totalAssignedPeoples.assignedTo", "name email role");
  }
}
