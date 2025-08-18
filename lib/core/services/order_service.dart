import 'package:flutter/foundation.dart';
import '../models/esim_plan.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'payment_service.dart';
import 'notification_service.dart';

class OrderService {
  static final OrderService _instance = OrderService._instance();
  factory OrderService() => _instance;
  OrderService._instance();

  final PaymentService _paymentService = PaymentService();
  final NotificationService _notificationService = NotificationService();

  /// Create a new order
  Future<OrderModel> createOrder({
    required UserModel user,
    required ESimPlan plan,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> paymentDetails,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final orderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
      final taxAmount = plan.price * 0.1; // 10% tax
      final totalAmount = plan.price + taxAmount;

      // Create order
      final order = OrderModel(
        id: orderId,
        userId: user.uid,
        planId: plan.id,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        currency: 'USD',
        deliveryEmail: email,
        deliveryPhoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        planDetails: {
          'name': plan.name,
          'description': plan.description,
          'dataAmountGB': plan.dataAmountGB,
          'durationDays': plan.durationDays,
          'countryCode': plan.countryCode,
          'price': plan.price,
        },
      );

      // Process payment
      final paymentResult = await _paymentService.processPayment(
        plan: plan,
        method: paymentMethod,
        paymentDetails: paymentDetails,
        metadata: {
          'orderId': orderId,
          'userId': user.uid,
          'planId': plan.id,
        },
      );

      // Update order with payment result
      final updatedOrder = order.copyWith(
        paymentTransactionId: paymentResult.transactionId,
        status: paymentResult.status == PaymentStatus.succeeded
            ? OrderStatus.paid
            : OrderStatus.paymentFailed,
        paymentMetadata: paymentResult.metadata,
        updatedAt: DateTime.now(),
      );

      if (paymentResult.status == PaymentStatus.succeeded) {
        // Provision eSIM
        await _provisionESim(updatedOrder, plan);
        
        // Send notifications
        await _sendOrderNotifications(updatedOrder, user);
      }

      return updatedOrder;
    } catch (e) {
      if (kDebugMode) {
        print('Order creation failed: $e');
      }
      rethrow;
    }
  }

  /// Provision eSIM for the order
  Future<void> _provisionESim(OrderModel order, ESimPlan plan) async {
    try {
      // Simulate eSIM provisioning
      await Future.delayed(const Duration(seconds: 1));

      // Generate QR code data (in real implementation, this would come from eSIM provider)
      final qrCodeData = _generateESimQRCode(order.id, plan);
      
      // Update order with eSIM details
      final esimDetails = {
        'qrCode': qrCodeData,
        'iccid': 'ICCID_${DateTime.now().millisecondsSinceEpoch}',
        'activationCode': 'AC_${order.id}',
        'networkName': plan.countryCode == 'US' ? 'AT&T' : 'Vodafone',
        'apn': 'internet',
        'provisionedAt': DateTime.now().toIso8601String(),
      };

      // In real implementation, save to database
      if (kDebugMode) {
        print('eSIM provisioned for order ${order.id}: $esimDetails');
      }
    } catch (e) {
      if (kDebugMode) {
        print('eSIM provisioning failed: $e');
      }
      rethrow;
    }
  }

  /// Generate eSIM QR code data
  String _generateESimQRCode(String orderId, ESimPlan plan) {
    // This is a simplified QR code format for demo
    // Real implementation would use proper eSIM profile format
    return 'LPA:1\$localhost:8080\$${orderId}_${plan.countryCode}';
  }

  /// Send order notifications
  Future<void> _sendOrderNotifications(OrderModel order, UserModel user) async {
    try {
      // Send email notification
      if (order.deliveryEmail != null) {
        await _notificationService.sendOrderConfirmationEmail(
          email: order.deliveryEmail!,
          order: order,
          user: user,
        );
      }

      // Send WhatsApp notification
      if (order.deliveryPhoneNumber != null) {
        await _notificationService.sendOrderConfirmationWhatsApp(
          phoneNumber: order.deliveryPhoneNumber!,
          order: order,
          user: user,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to send notifications: $e');
      }
      // Don't fail the order if notifications fail
    }
  }

  /// Get order by ID
  Future<OrderModel?> getOrder(String orderId) async {
    try {
      // Simulate database lookup
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return mock order for demo
      return OrderModel(
        id: orderId,
        userId: 'demo-user',
        planId: 'plan-us-1gb',
        status: OrderStatus.delivered,
        totalAmount: 25.00,
        currency: 'USD',
        deliveryEmail: 'demo@example.com',
        paymentTransactionId: 'txn_123456789',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now(),
        planDetails: {
          'name': 'USA 1GB Plan',
          'description': '1GB data for 7 days',
          'dataAmountGB': 1,
          'durationDays': 7,
          'countryCode': 'US',
          'price': 22.73,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get order: $e');
      }
      return null;
    }
  }

  /// Get orders for user
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      // Simulate database lookup
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Return mock orders for demo
      return [
        OrderModel(
          id: 'ORDER_${DateTime.now().millisecondsSinceEpoch - 3600000}',
          userId: userId,
          planId: 'plan-us-1gb',
          status: OrderStatus.delivered,
          totalAmount: 25.00,
          currency: 'USD',
          deliveryEmail: 'demo@example.com',
          paymentTransactionId: 'txn_123456789',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          planDetails: {
            'name': 'USA 1GB Plan',
            'description': '1GB data for 7 days',
            'dataAmountGB': 1,
            'durationDays': 7,
            'countryCode': 'US',
            'price': 22.73,
          },
        ),
        OrderModel(
          id: 'ORDER_${DateTime.now().millisecondsSinceEpoch - 7200000}',
          userId: userId,
          planId: 'plan-uk-5gb',
          status: OrderStatus.processing,
          totalAmount: 55.00,
          currency: 'USD',
          deliveryEmail: 'demo@example.com',
          paymentTransactionId: 'txn_987654321',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          planDetails: {
            'name': 'UK 5GB Plan',
            'description': '5GB data for 30 days',
            'dataAmountGB': 5,
            'durationDays': 30,
            'countryCode': 'UK',
            'price': 50.00,
          },
        ),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get user orders: $e');
      }
      return [];
    }
  }

  /// Update order status
  Future<OrderModel?> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      // Simulate database update
      await Future.delayed(const Duration(milliseconds: 300));
      
      final order = await getOrder(orderId);
      if (order != null) {
        return order.copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update order status: $e');
      }
      return null;
    }
  }

  /// Cancel order
  Future<bool> cancelOrder(String orderId, String reason) async {
    try {
      final order = await getOrder(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }

      if (order.status == OrderStatus.delivered || order.status == OrderStatus.cancelled) {
        throw Exception('Cannot cancel order in ${order.status.name} status');
      }

      // Process refund if payment was made
      if (order.paymentTransactionId != null && order.status == OrderStatus.paid) {
        await _paymentService.refundPayment(
          transactionId: order.paymentTransactionId!,
          amount: order.totalAmount,
          reason: reason,
        );
      }

      // Update order status
      await updateOrderStatus(orderId, OrderStatus.cancelled);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel order: $e');
      }
      return false;
    }
  }

  /// Resend order notifications
  Future<bool> resendNotifications(String orderId) async {
    try {
      final order = await getOrder(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }

      // Mock user for demo
      final user = UserModel(
        uid: order.userId,
        email: order.deliveryEmail ?? 'demo@example.com',
        firstName: 'Demo',
        lastName: 'User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _sendOrderNotifications(order, user);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to resend notifications: $e');
      }
      return false;
    }
  }
}
