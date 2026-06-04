/// User model matching Firestore /users/{userId} schema
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String language;
  final String? country;
  final String? timezone;
  final UserPlan plan;
  final DateTime? planExpiresAt;
  final List<String> trustedContactIds;
  final bool isDeceased;
  final DateTime? deceasedConfirmedAt;
  final DateTime? lastCheckIn;
  final String? securityPhraseHash;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.language = 'en',
    this.country,
    this.timezone,
    this.plan = UserPlan.free,
    this.planExpiresAt,
    this.trustedContactIds = const [],
    this.isDeceased = false,
    this.deceasedConfirmedAt,
    this.lastCheckIn,
    this.securityPhraseHash,
    required this.createdAt,
  });

  bool get isPremium => plan == UserPlan.premium;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? language,
    String? country,
    String? timezone,
    UserPlan? plan,
    DateTime? planExpiresAt,
    List<String>? trustedContactIds,
    bool? isDeceased,
    DateTime? deceasedConfirmedAt,
    DateTime? lastCheckIn,
    String? securityPhraseHash,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      country: country ?? this.country,
      timezone: timezone ?? this.timezone,
      plan: plan ?? this.plan,
      planExpiresAt: planExpiresAt ?? this.planExpiresAt,
      trustedContactIds: trustedContactIds ?? this.trustedContactIds,
      isDeceased: isDeceased ?? this.isDeceased,
      deceasedConfirmedAt: deceasedConfirmedAt ?? this.deceasedConfirmedAt,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      securityPhraseHash: securityPhraseHash ?? this.securityPhraseHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'photoUrl': photoUrl,
    'language': language,
    'country': country,
    'timezone': timezone,
    'plan': plan.name,
    'planExpiresAt': planExpiresAt?.toIso8601String(),
    'trustedContactIds': trustedContactIds,
    'isDeceased': isDeceased,
    'deceasedConfirmedAt': deceasedConfirmedAt?.toIso8601String(),
    'lastCheckIn': lastCheckIn?.toIso8601String(),
    'securityPhraseHash': securityPhraseHash,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String?,
    photoUrl: json['photoUrl'] as String?,
    language: json['language'] as String? ?? 'en',
    country: json['country'] as String?,
    timezone: json['timezone'] as String?,
    plan: UserPlan.values.firstWhere(
      (e) => e.name == json['plan'],
      orElse: () => UserPlan.free,
    ),
    planExpiresAt: _parseDate(json['planExpiresAt']),
    trustedContactIds: (json['trustedContactIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    isDeceased: json['isDeceased'] as bool? ?? false,
    deceasedConfirmedAt: _parseDate(json['deceasedConfirmedAt']),
    lastCheckIn: _parseDate(json['lastCheckIn']),
    securityPhraseHash: json['securityPhraseHash'] as String?,
    createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
  );

  /// Handles both Firestore Timestamp and ISO8601 String
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    // Firestore Timestamp — use dynamic access to avoid importing firebase
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}

enum UserPlan { free, premium }
