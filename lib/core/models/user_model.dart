class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String preferredLanguage;
  final String preferredCurrency;
  
  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.preferredLanguage = 'en',
    this.preferredCurrency = 'USD',
  });
  
  String get fullName => '$firstName $lastName';
  String get displayName => fullName.trim().isEmpty ? email : fullName;
  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'preferredLanguage': preferredLanguage,
      'preferredCurrency': preferredCurrency,
    };
  }
  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      preferredCurrency: map['preferredCurrency'] ?? 'USD',
    );
  }
  
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? preferredLanguage,
    String? preferredCurrency,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }
  
  @override
  int get hashCode => uid.hashCode;
  
  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, fullName: $fullName)';
  }
}
