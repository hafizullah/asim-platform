enum OrderStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  activated,
  expired,
}

class ESimOrder {
  final String id;
  final String userId;
  final String planId;
  final String countryCode;
  final OrderStatus status;
  final double price;
  final String currency;
  final String paymentMethodId;
  final String? transactionId;
  final String? eSimIccid;
  final String? activationCode;
  final String? qrCodeUrl;
  final String? eSimProfileUrl;
  final String? recipientEmail;
  final String? recipientWhatsApp;
  final DateTime? activatedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  
  ESimOrder({
    required this.id,
    required this.userId,
    required this.planId,
    required this.countryCode,
    required this.status,
    required this.price,
    required this.currency,
    required this.paymentMethodId,
    this.transactionId,
    this.eSimIccid,
    this.activationCode,
    this.qrCodeUrl,
    this.eSimProfileUrl,
    this.recipientEmail,
    this.recipientWhatsApp,
    this.activatedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });
  
  bool get isPending => status == OrderStatus.pending;
  bool get isProcessing => status == OrderStatus.processing;
  bool get isCompleted => status == OrderStatus.completed;
  bool get isFailed => status == OrderStatus.failed;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isActivated => status == OrderStatus.activated;
  bool get isExpired => status == OrderStatus.expired;
  bool get canBeActivated => isCompleted && !isActivated && !isExpired;
  bool get hasESimData => eSimIccid != null && activationCode != null;
  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
  
  String get statusDisplayText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending Payment';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.completed:
        return 'Ready to Activate';
      case OrderStatus.failed:
        return 'Failed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.activated:
        return 'Activated';
      case OrderStatus.expired:
        return 'Expired';
    }
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'countryCode': countryCode,
      'status': status.name,
      'price': price,
      'currency': currency,
      'paymentMethodId': paymentMethodId,
      'transactionId': transactionId,
      'eSimIccid': eSimIccid,
      'activationCode': activationCode,
      'qrCodeUrl': qrCodeUrl,
      'eSimProfileUrl': eSimProfileUrl,
      'recipientEmail': recipientEmail,
      'recipientWhatsApp': recipientWhatsApp,
      'activatedAt': activatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }
  
  factory ESimOrder.fromMap(Map<String, dynamic> map) {
    return ESimOrder(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      planId: map['planId'] ?? '',
      countryCode: map['countryCode'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      price: (map['price'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      paymentMethodId: map['paymentMethodId'] ?? '',
      transactionId: map['transactionId'],
      eSimIccid: map['eSimIccid'],
      activationCode: map['activationCode'],
      qrCodeUrl: map['qrCodeUrl'],
      eSimProfileUrl: map['eSimProfileUrl'],
      recipientEmail: map['recipientEmail'],
      recipientWhatsApp: map['recipientWhatsApp'],
      activatedAt: map['activatedAt'] != null ? DateTime.parse(map['activatedAt']) : null,
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      metadata: map['metadata'],
    );
  }
  
  ESimOrder copyWith({
    String? id,
    String? userId,
    String? planId,
    String? countryCode,
    OrderStatus? status,
    double? price,
    String? currency,
    String? paymentMethodId,
    String? transactionId,
    String? eSimIccid,
    String? activationCode,
    String? qrCodeUrl,
    String? eSimProfileUrl,
    String? recipientEmail,
    String? recipientWhatsApp,
    DateTime? activatedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ESimOrder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      countryCode: countryCode ?? this.countryCode,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      transactionId: transactionId ?? this.transactionId,
      eSimIccid: eSimIccid ?? this.eSimIccid,
      activationCode: activationCode ?? this.activationCode,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      eSimProfileUrl: eSimProfileUrl ?? this.eSimProfileUrl,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      recipientWhatsApp: recipientWhatsApp ?? this.recipientWhatsApp,
      activatedAt: activatedAt ?? this.activatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ESimOrder && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'ESimOrder(id: $id, status: $status, price: $formattedPrice)';
  }
}
