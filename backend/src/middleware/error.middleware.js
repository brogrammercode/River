import env from "../config/env.js";
import logger from "../utils/logger.js";
import { ApiResponse } from "../utils/apiResponse.js";
import { CustomError } from "../utils/customError.js";

const { NODE_ENV } = env;

export const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  logger.error(`ERROR: ${err.message}`);
  logger.error(err.stack);

  if (err.name === "CastError") {
    const message = "Resource not found";
    error = new CustomError(message, 400);
  }

  if (err.code === 11000) {
    const message = "Duplicate field value entered";
    error = new CustomError(message, 400);
  }

  if (err.name === "ValidationError") {
    const errors = Object.values(err.errors).map((val) => ({
      field: val.path,
      message: val.message,
    }));
    error = new CustomError("Validation Error", 400);
  }

  res.status(error.statusCode || 500).json(
    new ApiResponse(false, error.message || "Server Error", null, {
      ...(error.errors && { errors: error.errors }),
      ...(NODE_ENV === development && { stack: err.stack }),
    })
  );
};
