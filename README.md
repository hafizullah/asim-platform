# Asim - Cross-Platform eSIM Application

A modern Flutter application for purchasing and managing eSIM plans globally, with support for multiple languages (English, Pashto, Dari) and integrated Firebase backend.

## 🌟 Features

### Phase 1 - Foundation ✅
- ✅ Cross-platform Flutter app (iOS, Android, Web)
- ✅ Firebase integration (Auth, Firestore, Functions)
- ✅ Multilingual support (English, Pashto, Dari)
- ✅ Modern Material 3 design
- ✅ Authentication system (email/password)
- ✅ Clean architecture with providers

### Phase 2 - eSIM Integration (In Progress)
- 🔄 eSIM API integration via Firebase Functions
- 🔄 Browse data plans by country
- 🔄 Secure payment processing
- 🔄 eSIM activation and QR code generation
- 🔄 Email/WhatsApp delivery system

### Phase 3 - User Experience (Planned)
- 📋 Simplified 3-step workflow
- 📋 Offline-first design
- 📋 Cross-border purchasing for family/friends
- 📋 Tourism-friendly features

### Phase 4 - AI/Agent Automation (Planned)
- 🤖 Auto-generated components
- 🤖 Automated testing
- 🤖 Dynamic content generation

## 🏗️ Architecture

```
lib/
├── core/
│   ├── localization/     # Multi-language support
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── router/          # Navigation
│   └── theme/           # UI theming
├── features/
│   ├── auth/            # Authentication
│   ├── home/            # Dashboard
│   ├── plans/           # eSIM plans
│   ├── checkout/        # Payment flow
│   ├── orders/          # Order management
│   └── profile/         # User profile
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase CLI
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd asim-platform
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase project
   firebase init
   ```

4. **Configure Firebase**
   - Update `lib/firebase_options.dart` with your Firebase configuration
   - Enable Authentication, Firestore, and Functions in Firebase Console
   - Set up authentication providers (Email/Password)

5. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For web
   flutter run -d web
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

## 🌍 Supported Languages

- **English** (en) - Default
- **Pashto** (ps) - پښتو
- **Dari** (fa) - دری

## 📱 Platforms

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Progressive Web App)
- 🔄 **macOS** (Coming soon)
- 🔄 **Windows** (Coming soon)

## 🔧 Development

### Project Structure
```
asim-platform/
├── android/             # Android-specific code
├── ios/                 # iOS-specific code
├── lib/                 # Flutter/Dart code
├── functions/           # Firebase Cloud Functions
├── firestore.rules      # Firestore security rules
├── pubspec.yaml         # Dependencies
└── README.md
```

### Key Dependencies
- `firebase_core` - Firebase integration
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `provider` - State management
- `go_router` - Navigation
- `flutter_localizations` - Internationalization

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Document public APIs
- Write tests for business logic

## 🔒 Security

- Firebase Authentication for secure user management
- Firestore security rules for data protection
- Input validation and sanitization
- Secure payment processing via Firebase Functions

## 📦 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
firebase deploy --only hosting
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is proprietary. All rights reserved.

## 📞 Support

For support and questions:
- Email: support@asim-platform.com
- Documentation: [docs.asim-platform.com]
- Issues: GitHub Issues

---

**Built with ❤️ using Flutter and Firebase**