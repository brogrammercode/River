import { ItemService } from "../services/item.service.js";
import { ApiResponse } from "../utils/apiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export const getUserItems = asyncHandler(async (req, res) => {
  const { page, limit, status } = req.query;
  const currentUser = req.user;

  const result = await ItemService.getUserItems(currentUser._id, {
    page,
    limit,
    status,
  });

  res
    .status(200)
    .json(new ApiResponse(true, "Items retrieved successfully", result));
});

export const createItem = asyncHandler(async (req, res) => {
  const { content, status } = req.body;
  const currentUser = req.user;

  const item = await ItemService.createItem(
    { content, status },
    currentUser._id
  );

  res
    .status(201)
    .json(new ApiResponse(true, "Item created successfully", item));
});
