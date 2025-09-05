import { AuthService } from "../services/auth.service.js";
import { CustomError } from "../utils/customError.js";
import { JwtUtils } from "../utils/jwt.js";

export const authenticate = async (req, res, next) => {
  try {
    const token = req.cookies.token;
    if (!token) {
      throw new CustomError("Access denied. No token provided.", 401);
    }

    const decodedData = JwtUtils.verifyToken(token);
    const user = await AuthService.getUserById(decodedData.userID);

    req.user = user;
    next();
  } catch (error) {
    if (error instanceof CustomError) {
      next(error);
    } else {
      next(new CustomError("Invalid or expired token.", 401));
    }
  }
};
