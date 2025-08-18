enum OrderStatus {
  pending,
  paid,
  processing,
  delivered,
  cancelled,
  paymentFailed,
  refunded,
}

class OrderModel {
  final String id;
  final String userId;
  final String planId;
  final OrderStatus status;
  final double totalAmount;
  final String currency;
  final String? deliveryEmail;
  final String? deliveryPhoneNumber;
  final String? paymentTransactionId;
  final Map<String, dynamic>? paymentMetadata;
  final Map<String, dynamic>? planDetails;
  final Map<String, dynamic>? esimDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.totalAmount,
    required this.currency,
    this.deliveryEmail,
    this.deliveryPhoneNumber,
    this.paymentTransactionId,
    this.paymentMetadata,
    this.planDetails,
    this.esimDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    String? planId,
    OrderStatus? status,
    double? totalAmount,
    String? currency,
    String? deliveryEmail,
    String? deliveryPhoneNumber,
    String? paymentTransactionId,
    Map<String, dynamic>? paymentMetadata,
    Map<String, dynamic>? planDetails,
    Map<String, dynamic>? esimDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      deliveryEmail: deliveryEmail ?? this.deliveryEmail,
      deliveryPhoneNumber: deliveryPhoneNumber ?? this.deliveryPhoneNumber,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      paymentMetadata: paymentMetadata ?? this.paymentMetadata,
      planDetails: planDetails ?? this.planDetails,
      esimDetails: esimDetails ?? this.esimDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'status': status.name,
      'totalAmount': totalAmount,
      'currency': currency,
      'deliveryEmail': deliveryEmail,
      'deliveryPhoneNumber': deliveryPhoneNumber,
      'paymentTransactionId': paymentTransactionId,
      'paymentMetadata': paymentMetadata,
      'planDetails': planDetails,
      'esimDetails': esimDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      planId: json['planId'],
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'],
      deliveryEmail: json['deliveryEmail'],
      deliveryPhoneNumber: json['deliveryPhoneNumber'],
      paymentTransactionId: json['paymentTransactionId'],
      paymentMetadata: json['paymentMetadata'] as Map<String, dynamic>?,
      planDetails: json['planDetails'] as Map<String, dynamic>?,
      esimDetails: json['esimDetails'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.paymentFailed:
        return 'Payment Failed';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  String get planName => planDetails?['name'] ?? 'Unknown Plan';
  String get planDescription => planDetails?['description'] ?? '';
  int get planDataAmountGB => planDetails?['dataAmountGB'] ?? 0;
  int get planDurationDays => planDetails?['durationDays'] ?? 0;
  String get planCountryCode => planDetails?['countryCode'] ?? '';
  double get planPrice => (planDetails?['price'] ?? 0).toDouble();

  @override
  String toString() {
    return 'OrderModel(id: $id, status: $status, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
