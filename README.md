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

## 🛠️ Tech Stack

### Frontend
- **Flutter**: 3.16+
- **Dart**: 3.2+
- **Riverpod**: State management with code generation
- **Dio**: HTTP client with interceptors
- **Go Router**: Declarative routing
- **Hive**: Local database
- **Firebase**: Analytics, Crashlytics, FCM
- **Flutter Gen**: Asset and color generation

### Backend
- **Node.js**: 18+ with TypeScript
- **Express.js**: Web framework
- **MongoDB**: NoSQL database
- **Mongoose**: Object modeling
- **JWT**: Authentication
- **Cloudinary**: Image/file storage
- **Winston**: Logging
- **Jest**: Testing framework
- **Swagger**: API documentation

### DevOps & Tools
- **Docker**: Containerization
- **GitHub Actions**: CI/CD
- **ESLint/Prettier**: Code formatting
- **Husky**: Git hooks
- **Conventional Commits**: Commit standards

## 🚀 Quick Start

### Prerequisites
- Flutter 3.16+ 
- Node.js 18+
- MongoDB 6.0+
- Docker (optional)

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/river.git
cd river
```

### 2. Backend Setup
```bash
cd backend
npm install
cp .env.example .env  # Configure your environment variables
npm run dev
```

### 3. Frontend Setup
```bash
cd mobile
flutter pub get
flutter pub run build_runner build
flutter run
```

### 4. Docker Setup (Alternative)
```bash
docker-compose up -d
```

## ⚙️ Configuration

### Environment Variables

#### Backend (.env)
```bash
# Database
MONGODB_URI=mongodb://localhost:27017/river
MONGODB_TEST_URI=mongodb://localhost:27017/river_test

# Authentication
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_SECRET=your-refresh-token-secret

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# File Upload
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret

# Server
PORT=3000
NODE_ENV=development
CLIENT_URL=http://localhost:3000
```

#### Frontend (lib/core/config/)
```dart
// config.dart
class AppConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  static const bool enableLogging = true;
  static const int timeoutSeconds = 30;
}
```

## 📱 Mobile Features

### Authentication Flow
- Login/Register with email validation
- JWT token management with auto-refresh
- Biometric authentication support
- Social login (Google, Apple)
- Password reset via email

### Core Features
- **Notes Management**: CRUD operations with offline sync
- **Profile Management**: User profile with image upload
- **Settings**: Theme, language, notifications
- **Search**: Real-time search with filters
- **Offline Support**: Works without internet connection

### State Management Architecture
```dart
// Example: Notes Feature with Riverpod

// 1. Repository Provider
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl(ref.watch(dioProvider));
});

// 2. State Notifier
class NotesNotifier extends StateNotifier<NotesState> {
  final NotesRepository _repository;
  
  NotesNotifier(this._repository) : super(const NotesState.loading());
  
  Future<void> loadNotes() async {
    // Implementation
  }
}

// 3. Provider
final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  return NotesNotifier(ref.watch(notesRepositoryProvider));
});

// 4. UI Usage
class NotesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    
    return notesState.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(error),
      data: (notes) => NotesListView(notes: notes),
    );
  }
}
```

## 🖥️ Backend Features

### API Architecture
- **RESTful API** design with consistent response format
- **Authentication middleware** with role-based access
- **Validation middleware** using Joi schemas
- **Error handling** with custom error classes
- **Rate limiting** to prevent abuse
- **API versioning** for backward compatibility

### Database Design
```typescript
// User Model
interface IUser {
  _id: ObjectId;
  email: string;
  password: string;
  name: string;
  avatar?: string;
  role: 'user' | 'admin';
  isEmailVerified: boolean;
  refreshTokens: string[];
  createdAt: Date;
  updatedAt: Date;
}

// Note Model
interface INote {
  _id: ObjectId;
  title: string;
  content: string;
  userId: ObjectId;
  tags: string[];
  isCompleted: boolean;
  createdAt: Date;
  updatedAt: Date;
}
```

### API Endpoints
```
POST   /api/auth/register       # User registration
POST   /api/auth/login          # User login
POST   /api/auth/refresh        # Refresh access token
POST   /api/auth/logout         # User logout
GET    /api/auth/me             # Get current user

GET    /api/notes               # Get user notes
POST   /api/notes               # Create note
PUT    /api/notes/:id           # Update note
DELETE /api/notes/:id           # Delete note

GET    /api/profile             # Get user profile
PUT    /api/profile             # Update profile
POST   /api/profile/avatar      # Upload avatar
```

## 🧪 Testing

### Frontend Testing
```bash
cd mobile
flutter test                    # Unit tests
flutter test integration_test/  # Integration tests
```

### Backend Testing
```bash
cd backend
npm test                        # All tests
npm run test:unit              # Unit tests
npm run test:integration       # Integration tests
npm run test:coverage          # Coverage report
```

## 🚀 Deployment

### Backend Deployment (Docker)
```bash
# Build production image
docker build -t river-backend .

# Run container
docker run -p 3000:3000 --env-file .env.production river-backend
```

### Frontend Deployment
```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ipa --release

# Web
flutter build web --release
```

### CI/CD Pipeline
The project includes GitHub Actions workflows for:
- **Automated testing** on pull requests
- **Code quality checks** (linting, formatting)
- **Security scanning**
- **Automated deployment** to staging/production
- **Release management** with semantic versioning

## 📊 Performance & Monitoring

### Frontend
- **Firebase Crashlytics**: Crash reporting
- **Firebase Analytics**: User behavior tracking
- **Performance monitoring** with custom metrics
- **Bundle size optimization**

### Backend
- **Health check endpoints**
- **Request/response logging**
- **Performance monitoring**
- **Database query optimization**
- **Memory usage tracking**

## 🤝 Contributing

We love contributions! Please read our [Contributing Guide](CONTRIBUTING.md) to get started.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure tests pass (`npm test` & `flutter test`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Express.js community
- All open source contributors

## 🆘 Support

- 📚 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/yourusername/river/issues)
- 💬 [Discussions](https://github.com/yourusername/river/discussions)
- 📧 Email: support@river-app.com

---

<div align="center">
  <p>Built with ❤️ by the River Team</p>
  <p>
    <a href="https://github.com/brogrammercode/River">⭐ Star us on GitHub</a> •
    <a href="https://twitter.com/river_app">🐦 Follow on Twitter</a> •
    <a href="https://river-production.up.railway.app/api/health">🌐 Visit Website</a>
  </p>
</div>