import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

enum NotificationType {
  email,
  sms,
  whatsapp,
  push,
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Configuration
  static const String _sendGridApiKey = 'SG.your_sendgrid_api_key_here';
  static const String _twilioAccountSid = 'your_twilio_account_sid_here';
  static const String _twilioAuthToken = 'your_twilio_auth_token_here';
  static const String _twilioWhatsAppNumber = 'whatsapp:+14155238886';

  bool get isEmailConfigured => _sendGridApiKey.isNotEmpty;
  bool get isSmsConfigured => _twilioAccountSid.isNotEmpty && _twilioAuthToken.isNotEmpty;
  bool get isWhatsAppConfigured => isSmsConfigured && _twilioWhatsAppNumber.isNotEmpty;

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('Notification service initialized (demo mode)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Notification service initialization failed: $e');
      }
      rethrow;
    }
  }

  /// Send order confirmation email
  Future<bool> sendOrderConfirmationEmail({
    required String email,
    required OrderModel order,
    required UserModel user,
  }) async {
    try {
      // Simulate email sending
      await Future.delayed(const Duration(seconds: 1));

      final emailContent = _generateOrderConfirmationEmailContent(order, user);
      
      if (kDebugMode) {
        print('Email sent to $email:');
        print('Subject: Your eSIM Order Confirmation - ${order.id}');
        print('Content: $emailContent');
      }

      // In real implementation, use SendGrid API
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send email: $e');
      }
      return false;
    }
  }

  /// Send order confirmation WhatsApp message
  Future<bool> sendOrderConfirmationWhatsApp({
    required String phoneNumber,
    required OrderModel order,
    required UserModel user,
  }) async {
    try {
      // Simulate WhatsApp sending
      await Future.delayed(const Duration(seconds: 1));

      final message = _generateOrderConfirmationWhatsAppMessage(order, user);
      
      if (kDebugMode) {
        print('WhatsApp message sent to $phoneNumber:');
        print(message);
      }

      // In real implementation, use Twilio WhatsApp API
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send WhatsApp message: $e');
      }
      return false;
    }
  }

  /// Send eSIM delivery email
  Future<bool> sendESimDeliveryEmail({
    required String email,
    required OrderModel order,
    required String qrCodeData,
    required Map<String, dynamic> activationInstructions,
  }) async {
    try {
      // Simulate email sending with QR code
      await Future.delayed(const Duration(seconds: 1));

      final emailContent = _generateESimDeliveryEmailContent(order, qrCodeData, activationInstructions);
      
      if (kDebugMode) {
        print('eSIM delivery email sent to $email:');
        print('Subject: Your eSIM is Ready! - ${order.id}');
        print('Content: $emailContent');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send eSIM delivery email: $e');
      }
      return false;
    }
  }

  /// Send eSIM delivery WhatsApp message
  Future<bool> sendESimDeliveryWhatsApp({
    required String phoneNumber,
    required OrderModel order,
    required String qrCodeData,
  }) async {
    try {
      // Simulate WhatsApp sending with QR code
      await Future.delayed(const Duration(seconds: 1));

      final message = _generateESimDeliveryWhatsAppMessage(order, qrCodeData);
      
      if (kDebugMode) {
        print('eSIM delivery WhatsApp sent to $phoneNumber:');
        print(message);
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send eSIM delivery WhatsApp: $e');
      }
      return false;
    }
  }

  /// Send SMS notification
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      // Simulate SMS sending
      await Future.delayed(const Duration(milliseconds: 500));

      if (kDebugMode) {
        print('SMS sent to $phoneNumber: $message');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send SMS: $e');
      }
      return false;
    }
  }

  /// Send push notification
  Future<bool> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Simulate push notification
      await Future.delayed(const Duration(milliseconds: 300));

      if (kDebugMode) {
        print('Push notification sent to $userId:');
        print('Title: $title');
        print('Body: $body');
        print('Data: $data');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send push notification: $e');
      }
      return false;
    }
  }

  /// Generate order confirmation email content
  String _generateOrderConfirmationEmailContent(OrderModel order, UserModel user) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - ${order.id}</title>
</head>
<body>
    <h1>Thank you for your order, ${user.firstName}!</h1>
    
    <h2>Order Details</h2>
    <p><strong>Order ID:</strong> ${order.id}</p>
    <p><strong>Plan:</strong> ${order.planName}</p>
    <p><strong>Data:</strong> ${order.planDataAmountGB}GB</p>
    <p><strong>Duration:</strong> ${order.planDurationDays} days</p>
    <p><strong>Country:</strong> ${order.planCountryCode}</p>
    <p><strong>Total Amount:</strong> \$${order.totalAmount.toStringAsFixed(2)}</p>
    
    <h2>What's Next?</h2>
    <p>Your eSIM is being prepared and will be delivered within 5-10 minutes.</p>
    <p>You will receive another email with your eSIM QR code and activation instructions.</p>
    
    <p>Thank you for choosing ASIM!</p>
</body>
</html>
    ''';
  }

  /// Generate order confirmation WhatsApp message
  String _generateOrderConfirmationWhatsAppMessage(OrderModel order, UserModel user) {
    return '''
🎉 Order Confirmed!

Hello ${user.firstName},

Your eSIM order has been confirmed:

📱 Order ID: ${order.id}
📊 Plan: ${order.planName}
💾 Data: ${order.planDataAmountGB}GB
⏰ Duration: ${order.planDurationDays} days
🌍 Country: ${order.planCountryCode}
💰 Total: \$${order.totalAmount.toStringAsFixed(2)}

Your eSIM will be ready in 5-10 minutes. We'll send you the QR code and activation instructions shortly.

Thank you for choosing ASIM! 🚀
    ''';
  }

  /// Generate eSIM delivery email content
  String _generateESimDeliveryEmailContent(
    OrderModel order,
    String qrCodeData,
    Map<String, dynamic> activationInstructions,
  ) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>Your eSIM is Ready! - ${order.id}</title>
</head>
<body>
    <h1>Your eSIM is Ready!</h1>
    
    <h2>eSIM Details</h2>
    <p><strong>Order ID:</strong> ${order.id}</p>
    <p><strong>Plan:</strong> ${order.planName}</p>
    <p><strong>QR Code:</strong> $qrCodeData</p>
    
    <h2>Activation Instructions</h2>
    <ol>
        <li>Go to Settings > Cellular > Add Cellular Plan</li>
        <li>Scan the QR code above</li>
        <li>Follow the on-screen instructions</li>
        <li>Your eSIM will be activated!</li>
    </ol>
    
    <p>Need help? Contact our support team.</p>
</body>
</html>
    ''';
  }

  /// Generate eSIM delivery WhatsApp message
  String _generateESimDeliveryWhatsAppMessage(OrderModel order, String qrCodeData) {
    return '''
📱 Your eSIM is Ready!

Order ID: ${order.id}
Plan: ${order.planName}

🔲 QR Code: $qrCodeData

📋 Activation Steps:
1. Settings > Cellular > Add Cellular Plan
2. Scan the QR code
3. Follow instructions
4. Enjoy your data!

Need help? Reply to this message.
    ''';
  }

  /// Get notification preferences for user
  Future<Map<String, bool>> getUserNotificationPreferences(String userId) async {
    // Simulate database lookup
    await Future.delayed(const Duration(milliseconds: 200));
    
    return {
      'email': true,
      'sms': false,
      'whatsapp': true,
      'push': true,
    };
  }

  /// Update notification preferences for user
  Future<bool> updateUserNotificationPreferences(
    String userId,
    Map<String, bool> preferences,
  ) async {
    try {
      // Simulate database update
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (kDebugMode) {
        print('Updated notification preferences for $userId: $preferences');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update notification preferences: $e');
      }
      return false;
    }
  }
}
