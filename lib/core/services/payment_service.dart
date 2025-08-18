import 'package:flutter/foundation.dart';
import '../models/esim_plan.dart';

enum PaymentMethod {
  card,
  applePay,
  googlePay,
}

enum PaymentStatus {
  pending,
  processing,
  succeeded,
  failed,
  cancelled,
}

class PaymentResult {
  final String transactionId;
  final PaymentStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  PaymentResult({
    required this.transactionId,
    required this.status,
    this.errorMessage,
    this.metadata,
  });
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Stripe configuration (to be set with real keys)
  static const String _stripePublishableKey = 'pk_test_your_publishable_key_here';
  static const String _stripeSecretKey = 'sk_test_your_secret_key_here';

  bool get isConfigured => _stripePublishableKey.isNotEmpty && _stripeSecretKey.isNotEmpty;

  /// Initialize payment service with configuration
  Future<void> initialize() async {
    try {
      // Initialize Stripe SDK here when real keys are available
      if (kDebugMode) {
        print('Payment service initialized (demo mode)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Payment service initialization failed: $e');
      }
      rethrow;
    }
  }

  /// Process payment for eSIM plan
  Future<PaymentResult> processPayment({
    required ESimPlan plan,
    required PaymentMethod method,
    required Map<String, dynamic> paymentDetails,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
      
      // Calculate total amount (including tax)
      final taxAmount = plan.price * 0.1; // 10% tax
      final totalAmount = plan.price + taxAmount;

      switch (method) {
        case PaymentMethod.card:
          return await _processCardPayment(
            transactionId: transactionId,
            amount: totalAmount,
            cardDetails: paymentDetails,
            metadata: metadata,
          );
        case PaymentMethod.applePay:
          return await _processApplePayPayment(
            transactionId: transactionId,
            amount: totalAmount,
            metadata: metadata,
          );
        case PaymentMethod.googlePay:
          return await _processGooglePayPayment(
            transactionId: transactionId,
            amount: totalAmount,
            metadata: metadata,
          );
      }
    } catch (e) {
      return PaymentResult(
        transactionId: 'failed_${DateTime.now().millisecondsSinceEpoch}',
        status: PaymentStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  /// Process card payment (Stripe integration)
  Future<PaymentResult> _processCardPayment({
    required String transactionId,
    required double amount,
    required Map<String, dynamic> cardDetails,
    Map<String, dynamic>? metadata,
  }) async {
    // Simulate payment processing for demo
    await Future.delayed(const Duration(seconds: 2));

    // Validate card details
    final cardNumber = cardDetails['cardNumber']?.replaceAll(' ', '') ?? '';
    final expiryDate = cardDetails['expiryDate'] ?? '';
    final cvv = cardDetails['cvv'] ?? '';
    final cardholderName = cardDetails['cardholderName'] ?? '';

    // Basic validation
    if (cardNumber.length < 16) {
      throw Exception('Invalid card number');
    }
    if (expiryDate.length < 5) {
      throw Exception('Invalid expiry date');
    }
    if (cvv.length < 3) {
      throw Exception('Invalid CVV');
    }
    if (cardholderName.isEmpty) {
      throw Exception('Cardholder name is required');
    }

    // Simulate different card behaviors for demo
    if (cardNumber.startsWith('4000000000000002')) {
      // Declined card
      return PaymentResult(
        transactionId: transactionId,
        status: PaymentStatus.failed,
        errorMessage: 'Your card was declined',
      );
    }

    if (cardNumber.startsWith('4000000000000119')) {
      // Processing error
      throw Exception('Processing error occurred');
    }

    // Successful payment
    return PaymentResult(
      transactionId: transactionId,
      status: PaymentStatus.succeeded,
      metadata: {
        'amount': amount,
        'currency': 'USD',
        'cardLast4': cardNumber.substring(cardNumber.length - 4),
        'cardBrand': _getCardBrand(cardNumber),
        ...?metadata,
      },
    );
  }

  /// Process Apple Pay payment
  Future<PaymentResult> _processApplePayPayment({
    required String transactionId,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    // Simulate Apple Pay processing
    await Future.delayed(const Duration(seconds: 1));

    return PaymentResult(
      transactionId: transactionId,
      status: PaymentStatus.succeeded,
      metadata: {
        'amount': amount,
        'currency': 'USD',
        'paymentMethod': 'apple_pay',
        ...?metadata,
      },
    );
  }

  /// Process Google Pay payment
  Future<PaymentResult> _processGooglePayPayment({
    required String transactionId,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    // Simulate Google Pay processing
    await Future.delayed(const Duration(seconds: 1));

    return PaymentResult(
      transactionId: transactionId,
      status: PaymentStatus.succeeded,
      metadata: {
        'amount': amount,
        'currency': 'USD',
        'paymentMethod': 'google_pay',
        ...?metadata,
      },
    );
  }

  /// Get card brand from card number
  String _getCardBrand(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5') || cardNumber.startsWith('2')) return 'Mastercard';
    if (cardNumber.startsWith('3')) return 'American Express';
    return 'Unknown';
  }

  /// Validate payment method availability
  bool isPaymentMethodAvailable(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return true; // Card payments always available
      case PaymentMethod.applePay:
        return defaultTargetPlatform == TargetPlatform.iOS; // Apple Pay only on iOS
      case PaymentMethod.googlePay:
        return defaultTargetPlatform == TargetPlatform.android; // Google Pay only on Android
    }
  }

  /// Get supported payment methods for current platform
  List<PaymentMethod> getSupportedPaymentMethods() {
    return PaymentMethod.values
        .where((method) => isPaymentMethodAvailable(method))
        .toList();
  }

  /// Refund a payment
  Future<PaymentResult> refundPayment({
    required String transactionId,
    double? amount,
    String? reason,
  }) async {
    // Simulate refund processing
    await Future.delayed(const Duration(seconds: 1));

    return PaymentResult(
      transactionId: 'refund_${DateTime.now().millisecondsSinceEpoch}',
      status: PaymentStatus.succeeded,
      metadata: {
        'originalTransactionId': transactionId,
        'refundAmount': amount,
        'reason': reason,
      },
    );
  }

  /// Get payment details by transaction ID
  Future<Map<String, dynamic>?> getPaymentDetails(String transactionId) async {
    // Simulate API call to get payment details
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock payment details for demo
    return {
      'transactionId': transactionId,
      'status': 'succeeded',
      'amount': 25.00,
      'currency': 'USD',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
