import mongoose from "mongoose";

const totalAssignedPeoplesSchema = new mongoose.Schema(
  {
    assignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  },
  {
    timestamps: true,
  }
);

const itemSchema = new mongoose.Schema(
  {
    content: String,
    uid: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    status: String,
    currentlyAssignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    totalAssignedPeoples: [totalAssignedPeoplesSchema],
  },
  {
    timestamps: true,
  }
);

const Item = mongoose.model("Item", itemSchema);

export default Item;
