# 🌊 River - Production-Ready Flutter + Node.js Starter

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Riverpod](https://img.shields.io/badge/Riverpod-00D4AA?style=for-the-badge&logo=flutter&logoColor=white)](https://riverpod.dev/)

> A production-ready starter template for building scalable full-stack applications with Flutter + Node.js

## 🚀 Overview

**River** is a comprehensive starter template that combines modern Flutter development with a robust Node.js backend. Built with clean architecture principles and industry best practices, it provides everything you need to kickstart your next production application.

## ✨ Features

### 🎯 Frontend (Flutter)
- **🔧 State Management**: Riverpod 2.4+ with code generation
- **🌐 HTTP Client**: Dio with interceptors and error handling
- **🏗️ Architecture**: Clean Architecture (Domain, Data, Presentation)
- **🎨 UI/UX**: Material Design 3 with custom themes
- **🔐 Authentication**: JWT-based auth with automatic token refresh
- **📱 Responsive**: Adaptive UI for mobile, tablet, and desktop
- **🧪 Testing**: Unit, widget, and integration tests
- **🔄 Offline Support**: Local caching with Hive/SQLite
- **🌍 Internationalization**: Multi-language support
- **📊 Analytics**: Firebase Analytics integration
- **🔔 Push Notifications**: FCM implementation

### ⚡ Backend (Node.js)
- **🚀 Framework**: Express.js with TypeScript
- **🗄️ Database**: MongoDB with Mongoose ODM
- **🔒 Security**: JWT authentication, bcrypt, helmet, CORS
- **📝 Validation**: Joi/Yup schema validation
- **📧 Email**: Nodemailer with template support
- **☁️ Storage**: Cloudinary/AWS S3 integration
- **📊 Logging**: Winston with log rotation
- **🔍 Monitoring**: Health checks and performance metrics
- **📖 Documentation**: Swagger/OpenAPI 3.0
- **🧪 Testing**: Jest with comprehensive test coverage
- **🐳 Docker**: Production-ready containerization
- **🚀 Deployment**: CI/CD pipelines for various platforms

## 🏗️ Project Structure

```
river/
├── 📱 mobile/                  # Flutter application
│   ├── lib/
│   │   ├── core/              # Core utilities, constants
│   │   ├── features/          # Feature-based modules
│   │   │   ├── auth/
│   │   │   │   ├── data/      # Repository implementations
│   │   │   │   ├── domain/    # Entities, use cases
│   │   │   │   └── presentation/ # UI, state management
│   │   │   ├── notes/
│   │   │   └── profile/
│   │   ├── shared/           # Shared widgets, utilities
│   │   └── main.dart
│   ├── test/                 # Tests
│   ├── android/             # Android-specific files
│   ├── ios/                 # iOS-specific files
│   └── pubspec.yaml
├── 🖥️ backend/               # Node.js API server
│   ├── src/
│   │   ├── controllers/     # Route handlers
│   │   ├── models/          # Database models
│   │   ├── routes/          # API routes
│   │   ├── middleware/      # Custom middleware
│   │   ├── services/        # Business logic
│   │   ├── utils/           # Utilities
│   │   ├── config/          # Configuration
│   │   └── app.ts
│   ├── tests/               # API tests
│   ├── docs/                # API documentation
│   ├── Dockerfile
│   └── package.json
├── 🐳 docker/               # Docker configurations
├── 📚 docs/                 # Project documentation
└── README.md
```

## 🏗️ System Architecture

River follows a clean, scalable architecture pattern:

### Backend (Node.js/Express)
- **RESTful API** with Express.js framework
- **Real-time Communication** via Socket.IO for live updates
- **JWT Authentication** with secure cookie-based sessions
- **MongoDB** for data persistence with Mongoose ODM
- **Middleware Architecture** for authentication, error handling, and logging
- **CORS Configuration** for secure cross-origin requests

### Frontend (Flutter)
- **State Management** with Riverpod for reactive programming
- **HTTP Client** using Dio for API communication
- **Real-time Updates** via Socket.IO client integration
- **Responsive Design** for cross-platform compatibility

### Key Features
- User authentication and session management
- Item creation, assignment, and management
- Real-time notifications and updates
- Secure API endpoints with middleware protection
- Production-ready error handling and logging

## 🚀 Quick Start

### Prerequisites
- Node.js (v16 or higher)
- MongoDB (local or cloud instance)
- Flutter SDK (latest stable)
- Dart SDK

### Backend Setup - Already hosted (https://river-production.up.railway.app/api) (expire on 17 Sept, 2025)

1. **Clone and navigate to backend directory**
   ```bash
   git clone https://github.com/brogrammercode/River.git
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   Create a `.env` file in the backend root:
   ```env
   PORT=5000
   MONGODB_URI= <confidential>
   JWT_SECRET=your-super-secret-jwt-key
   NODE_ENV=development
   ```

4. **Start the development server**
   ```bash
   # Development mode with auto-reload
   npm run dev
   
   # Production mode
   npm start
   ```

   Server will be running on `http://localhost:5000`

### Frontend Setup - Again no need just install APK

1. **Navigate to Flutter app directory**
   ```bash
   cd frontend  # or your Flutter app directory name
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   ```dart
   // lib/core/config/api_config.dart
   class ApiConfig {
     static const String baseUrl = 'http://localhost:5000/api';
     static const String socketUrl = 'http://localhost:5000';
   }
   ```

4. **Run the Flutter application**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

## 📡 API Documentation

### Base URL
```
https://river-production.up.railway.app
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}
```

#### Get Current User (Protected)
```http
GET /api/auth/me
Authorization: Bearer <jwt_token>
```

#### Logout (Protected)
```http
POST /api/auth/logout
Authorization: Bearer <jwt_token>
```

### Item Management Endpoints

#### Get User Items (Protected)
```http
GET /api/item/
Authorization: Bearer <jwt_token>
```

#### Get Assigned Items (Protected)
```http
GET /api/item/assigned
Authorization: Bearer <jwt_token>
```

#### Create New Item (Protected)
```http
POST /api/item/
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "title": "string",
  "description": "string",
}
```

#### Update Item (Protected)
```http
PUT /api/item/:itemID
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "title": "string",
  "description": "string",
  "status": "string"
}
```

#### Reassign Item (Protected)
```http
PATCH /api/item/:itemID/reassign
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "newReceiverId": "user_id"
}
```

### Health Check
```http
GET /api/health
```

Response:
```json
{
  "status": "OK",
  "timestamp": "2025-01-XX:XX:XX.XXXZ"
}
```

## 🔌 Real-time Features (Socket.IO)

The application supports real-time updates for:

- **Item Assignments** - Instant notifications when items are assigned
- **Status Updates** - Live updates when item statuses change
- **User Presence** - Online/offline status tracking
- **Reassignments** - Real-time notifications for item reassignments

### Socket Events
```javascript
// Client-side events
socket.emit('join_room', userId);
socket.emit('item_updated', itemData);

// Server-side events
socket.on('item_assigned', (data) => {
  // Handle new assignment
});
socket.on('item_status_changed', (data) => {
  // Handle status update
});
```

## 🏗️ System Design Approach

### Backend Architecture Principles

1. **Modular Structure**: Routes, controllers, middleware, and utilities are separated into distinct modules
2. **Authentication Middleware**: JWT-based authentication with cookie support for secure session management
3. **Error Handling**: Centralized error handling middleware for consistent API responses
4. **Logging**: Winston-based logging system for production monitoring
5. **CORS Security**: Configured for specific frontend origins with credential support

### Frontend Architecture (Flutter + Riverpod)

1. **State Management**: Riverpod providers for reactive state management
2. **HTTP Client**: Dio interceptors for request/response handling and authentication
3. **Real-time Integration**: Socket.IO client for live updates
4. **Repository Pattern**: Clean separation between data layer and business logic

### Database Design
- **Users Collection**: Authentication and profile information
- **Items Collection**: Item data with references to users
- **Indexes**: Optimized queries for user-specific and assignment-based lookups

## 🚀 Production Deployment

### Backend Deployment

1. **Environment Variables**
   ```env
   NODE_ENV=production
   PORT=5000
   MONGODB_URI=mongodb+srv://your-cluster
   JWT_SECRET=your-production-secret
   FRONTEND_URL=https://your-frontend-domain.com
   ```

2. **Build and Deploy**
   ```bash
   npm install --production
   npm start
   ```

### Frontend Deployment

1. **Build for Production**
   ```bash
   flutter build web
   # or
   flutter build apk --release
   flutter build ios --release
   ```

2. **Update API Configuration**
   ```dart
   class ApiConfig {
     static const String baseUrl = 'https://river-production.up.railway.app/api';
     static const String socketUrl = 'https://river-production.up.railway.app';
   }
   ```

## 🔧 Development Tools

### Backend Dependencies
- **express**: Web framework
- **mongoose**: MongoDB ODM
- **socket.io**: Real-time communication
- **jsonwebtoken**: JWT authentication
- **bcryptjs**: Password hashing
- **cors**: Cross-origin resource sharing
- **winston**: Logging framework

### Flutter Dependencies
- **riverpod**: State management
- **dio**: HTTP client
- **socket_io_client**: Real-time communication
- **shared_preferences**: Local storage
- **flutter_secure_storage**: Secure token storage

## 🔍 Testing

### Backend Testing
```bash
# Run tests (when implemented)
npm test

# Run with coverage
npm run test:coverage
```

### Flutter Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Check the API documentation above
- Review the system architecture section

---

**River** - Streamlining item management with real-time collaboration 🌊