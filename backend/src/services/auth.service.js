import bcrypt from "bcryptjs";
import User from "../models/User.js";
import { CustomError } from "../utils/customError.js";
import { JwtUtils } from "../utils/jwt.js";

export class AuthService {
  static async registerUser(userData) {
    const { email, password, name, role } = userData;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      throw new CustomError("User already exists", 400);
    }

    const salt = await bcrypt.genSalt(10);
    const hashpassword = await bcrypt.hash(password, salt);

    const user = new User({
      email: email,
      password: hashpassword,
      name: name,
      role: role || "Consumer",
    });
    await user.save();

    const token = JwtUtils.generateToken({
      userID: user._id,
      email: user.email,
      name: user.name,
      role: user.role,
    });

    return {
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
      token: token,
    };
  }

  static async loginUser(credentials) {
    const { email, password } = credentials;
    const user = await User.findOne({ email: email });
    if (!user) {
      throw new CustomError("Invalid Credentials", 401);
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw new CustomError("Invalid Credentials", 401);
    }

    const token = JwtUtils.generateToken({
      userID: user._id,
      email: user.email,
      name: user.name,
      role: user.role,
    });

    return {
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
      token: token,
    };
  }

  static async getUserById(userID) {
    const user = await User.findById(userID).select("-password");
    if (!user) {
      throw new CustomError("User not found", 404);
    }

    return user;
  }

  static async updateUser(userID, updatedData) {
    const user = await User.findByIdAndUpdate(userID, updatedData, {
      new: true,
      select: "-password",
    });

    if (!user) {
      throw new CustomError("User not found", 404);
    }

    return user;
  }

  static async changePassword(userID, oldPassword, newPassword) {
    const user = await User.findById(userID);
    if (!user) {
      throw new CustomError("User not found", 404);
    }

    const isOldPasswordValid = await bcrypt.compare(oldPassword, user.password);
    if (!isOldPasswordValid) {
      throw new CustomError("Current password is incorrect", 400);
    }

    const salt = await bcrypt.genSalt(10);
    const hashedNewPassword = await bcrypt.hash(newPassword, salt);

    user.password = hashedNewPassword;
    await user.save();

    return {
      message: "Password changed successfully",
      user: user,
    };
  }
}
