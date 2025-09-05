import env from "../config/env.js";
import jwt from "jsonwebtoken";

const { JWT_SECRET } = env;

export class JwtUtils {
  static generateToken(payload) {
    return jwt.sign(payload, JWT_SECRET);
  }
  static verifyToken(token) {
    return jwt.verify(token, JWT_SECRET);
  }
}
