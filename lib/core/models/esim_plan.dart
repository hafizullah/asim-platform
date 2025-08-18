class ESimPlan {
  final String id;
  final String name;
  final String description;
  final String countryCode;
  final String countryName;
  final double price;
  final String currency;
  final int dataAmountGB;
  final int durationDays;
  final List<String> supportedNetworks;
  final bool isUnlimited;
  final bool hasVoice;
  final bool hasSms;
  final bool isPopular;
  final bool isActive;
  final String? promoText;
  final double? originalPrice;
  final String provider;
  final String coverage;
  final String activationPolicy;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ESimPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.countryCode,
    required this.countryName,
    required this.price,
    required this.currency,
    required this.dataAmountGB,
    required this.durationDays,
    required this.supportedNetworks,
    this.isUnlimited = false,
    this.hasVoice = false,
    this.hasSms = false,
    this.isPopular = false,
    this.isActive = true,
    this.promoText,
    this.originalPrice,
    required this.provider,
    required this.coverage,
    required this.activationPolicy,
    required this.createdAt,
    required this.updatedAt,
  });
  
  bool get isOnSale => originalPrice != null && originalPrice! > price;
  double get discountPercentage => isOnSale ? ((originalPrice! - price) / originalPrice!) * 100 : 0;
  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
  String get formattedOriginalPrice => originalPrice != null ? '$currency ${originalPrice!.toStringAsFixed(2)}' : '';
  String get dataDisplayText => isUnlimited ? 'Unlimited' : '${dataAmountGB}GB';
  String get durationDisplayText => durationDays == 1 ? '1 day' : '$durationDays days';
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'countryCode': countryCode,
      'countryName': countryName,
      'price': price,
      'currency': currency,
      'dataAmountGB': dataAmountGB,
      'durationDays': durationDays,
      'supportedNetworks': supportedNetworks,
      'isUnlimited': isUnlimited,
      'hasVoice': hasVoice,
      'hasSms': hasSms,
      'isPopular': isPopular,
      'isActive': isActive,
      'promoText': promoText,
      'originalPrice': originalPrice,
      'provider': provider,
      'coverage': coverage,
      'activationPolicy': activationPolicy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  factory ESimPlan.fromMap(Map<String, dynamic> map) {
    return ESimPlan(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      countryCode: map['countryCode'] ?? '',
      countryName: map['countryName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      dataAmountGB: map['dataAmountGB'] ?? 0,
      durationDays: map['durationDays'] ?? 0,
      supportedNetworks: List<String>.from(map['supportedNetworks'] ?? []),
      isUnlimited: map['isUnlimited'] ?? false,
      hasVoice: map['hasVoice'] ?? false,
      hasSms: map['hasSms'] ?? false,
      isPopular: map['isPopular'] ?? false,
      isActive: map['isActive'] ?? true,
      promoText: map['promoText'],
      originalPrice: map['originalPrice']?.toDouble(),
      provider: map['provider'] ?? '',
      coverage: map['coverage'] ?? '',
      activationPolicy: map['activationPolicy'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  ESimPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? countryCode,
    String? countryName,
    double? price,
    String? currency,
    int? dataAmountGB,
    int? durationDays,
    List<String>? supportedNetworks,
    bool? isUnlimited,
    bool? hasVoice,
    bool? hasSms,
    bool? isPopular,
    bool? isActive,
    String? promoText,
    double? originalPrice,
    String? provider,
    String? coverage,
    String? activationPolicy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ESimPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      dataAmountGB: dataAmountGB ?? this.dataAmountGB,
      durationDays: durationDays ?? this.durationDays,
      supportedNetworks: supportedNetworks ?? this.supportedNetworks,
      isUnlimited: isUnlimited ?? this.isUnlimited,
      hasVoice: hasVoice ?? this.hasVoice,
      hasSms: hasSms ?? this.hasSms,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      promoText: promoText ?? this.promoText,
      originalPrice: originalPrice ?? this.originalPrice,
      provider: provider ?? this.provider,
      coverage: coverage ?? this.coverage,
      activationPolicy: activationPolicy ?? this.activationPolicy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ESimPlan && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'ESimPlan(id: $id, name: $name, countryCode: $countryCode, price: $formattedPrice)';
  }
}
