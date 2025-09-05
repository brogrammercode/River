import { AuthService } from "../services/auth.service.js";
import { ApiResponse } from "../utils/apiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { CustomError } from "../utils/customError.js";

export const register = asyncHandler(async (req, res) => {
  const { email, password, name, role } = req.body;

  if (!email || !password || !name) {
    throw new CustomError("Please provide email, password, and name", 400);
  }

  const result = await AuthService.registerUser({
    email,
    password,
    name,
    role,
  });

  res.cookie("token", result.token, {
    httpOnly: true,
    secure: true,
    sameSite: "strict",
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });

  res.status(201).json(
    new ApiResponse(true, "Registration successful", {
      user: result.user,
      token: result.token,
    })
  );
});

export const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    throw new CustomError("Please provide email and password", 400);
  }

  const result = await AuthService.loginUser({
    email,
    password,
  });

  res.cookie("token", result.token, {
    httpOnly: true,
    secure: true,
    sameSite: "strict",
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });

  res.status(200).json(
    new ApiResponse(true, "Login successful", {
      user: result.user,
      token: result.token,
    })
  );
});

export const logout = asyncHandler(async (req, res) => {
  res.clearCookie("token");
  res.status(200).json(new ApiResponse(true, "Logout successfull"));
});

export const getMe = asyncHandler(async (req, res) => {
  const currentUser = req.user;
  res
    .status(200)
    .json(new ApiResponse(true, "User retrieved successfully", currentUser));
});

export const updateProfile = asyncHandler(async (req, res) => {
  const { name, role } = req.body;
  const currentUser = req.user;

  const updatedUser = await AuthService.updateUser(currentUser._id, {
    name,
    role,
  });

  res
    .status(200)
    .json(new ApiResponse(true, "Profile Update successfull", updatedUser));
});

export const changePassword = asyncHandler(async (req, res) => {
  const { currentPassword, newPassword } = req.body;
  const currentUser = req.user;

  if (!currentPassword || !newPassword) {
    throw new CustomError(
      "Please provide current password and new password",
      400
    );
  }

  const result = await AuthService.changePassword(
    currentUser._id,
    currentPassword,
    newPassword
  );

  res
    .status(200)
    .json(new ApiResponse(true, "Password changed successfully", result));
});
