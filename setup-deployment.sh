#!/bin/bash

# Firebase and iOS Deployment Setup Script
# Run this script to set up your deployment pipeline

echo "🚀 Setting up Asim Platform Deployment Pipeline"
echo "=============================================="

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "📦 Installing Firebase CLI..."
    npm install -g firebase-tools
else
    echo "✅ Firebase CLI already installed"
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
else
    echo "✅ Flutter is installed"
fi

echo ""
echo "🔧 Setting up Firebase..."
echo "========================="

# Initialize Firebase if not already done
if [ ! -f ".firebaserc" ]; then
    echo "🔥 Initializing Firebase project..."
    firebase init hosting
else
    echo "✅ Firebase already initialized"
fi

echo ""
echo "🌐 Testing web build..."
echo "======================"

# Test Flutter web build
flutter clean
flutter pub get
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ Web build successful!"
else
    echo "❌ Web build failed. Please check your Flutter setup."
    exit 1
fi

echo ""
echo "🚀 Testing Firebase deployment..."
echo "================================"

# Test Firebase deployment
firebase deploy --only hosting

echo ""
echo "📋 Next Steps:"
echo "============="
echo "1. 🔐 Set up GitHub Secrets (see DEPLOYMENT_GUIDE.md)"
echo "2. 📱 Configure iOS certificates and provisioning profiles"
echo "3. 🏷️  Create a git tag to trigger iOS deployment: git tag v1.0.0 && git push origin v1.0.0"
echo "4. 🌐 Your web app should be live at: $(firebase hosting:channel:list | grep -o 'https://[^[:space:]]*')"
echo ""
echo "📖 For detailed instructions, see DEPLOYMENT_GUIDE.md"
echo "✨ Happy deploying!"
