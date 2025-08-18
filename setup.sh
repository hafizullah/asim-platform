#!/bin/bash

# Asim Platform Setup Script
echo "🚀 Setting up Asim eSIM Platform..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "📦 Installing Firebase CLI..."
    npm install -g firebase-tools
fi

echo "📱 Installing Flutter dependencies..."
flutter pub get

echo "🔧 Running code generation..."
flutter packages pub run build_runner build

echo "🔥 Setting up Firebase..."
echo "Please run the following commands manually:"
echo "1. firebase login"
echo "2. firebase init"
echo "3. Select your Firebase project"
echo "4. Enable Authentication, Firestore, and Functions"

echo ""
echo "📝 Don't forget to:"
echo "1. Update lib/firebase_options.dart with your Firebase config"
echo "2. Enable Email/Password authentication in Firebase Console"
echo "3. Deploy Firestore rules: firebase deploy --only firestore:rules"
echo "4. Deploy Functions: firebase deploy --only functions"

echo ""
echo "🎯 To run the app:"
echo "flutter run"
echo ""
echo "✅ Setup complete! Happy coding! 🎉"
