export class ApiResponse {
  constructor(success, message, data = null, meta = {}) {
    this.success = success;
    this.message = message;
    if (data !== null) this.data = data;
    if (Object.keys(meta).length > 0) this.meta = meta;
    this.timestamp = new Date().toISOString();
  }
}
