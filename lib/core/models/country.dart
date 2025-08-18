class Country {
  final String code;
  final String name;
  final String flagUrl;
  final String currency;
  final List<String> supportedNetworks;
  final bool isActive;
  
  Country({
    required this.code,
    required this.name,
    required this.flagUrl,
    required this.currency,
    required this.supportedNetworks,
    this.isActive = true,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'flagUrl': flagUrl,
      'currency': currency,
      'supportedNetworks': supportedNetworks,
      'isActive': isActive,
    };
  }
  
  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      flagUrl: map['flagUrl'] ?? '',
      currency: map['currency'] ?? 'USD',
      supportedNetworks: List<String>.from(map['supportedNetworks'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.code == code;
  }
  
  @override
  int get hashCode => code.hashCode;
  
  @override
  String toString() {
    return 'Country(code: $code, name: $name)';
  }
}
