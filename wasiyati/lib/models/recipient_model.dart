/// Recipient model matching Firestore /recipients/{recipientId} schema
class RecipientModel {
  final String id;
  final String userId;
  final String name;
  final String relationship;
  final String? photoUrl;
  final String language;
  final String? whatsapp;
  final String? email;
  final String? phone;
  final DateTime createdAt;

  const RecipientModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    this.photoUrl,
    this.language = 'en',
    this.whatsapp,
    this.email,
    this.phone,
    required this.createdAt,
  });

  /// Get the first letter of the name for avatar
  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';

  /// Check if the recipient has at least one contact method
  bool get hasContactMethod =>
      (whatsapp != null && whatsapp!.isNotEmpty) ||
      (email != null && email!.isNotEmpty) ||
      (phone != null && phone!.isNotEmpty);

  /// Get available channels for this recipient
  List<String> get availableChannels {
    final channels = <String>[];
    if (email != null && email!.isNotEmpty) channels.add('email');
    if (phone != null && phone!.isNotEmpty) channels.add('sms');
    if (whatsapp != null && whatsapp!.isNotEmpty) channels.add('whatsapp');
    return channels;
  }

  RecipientModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? relationship,
    String? photoUrl,
    String? language,
    String? whatsapp,
    String? email,
    String? phone,
    DateTime? createdAt,
  }) {
    return RecipientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'relationship': relationship,
    'photoUrl': photoUrl,
    'language': language,
    'whatsapp': whatsapp,
    'email': email,
    'phone': phone,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RecipientModel.fromJson(Map<String, dynamic> json) => RecipientModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    relationship: json['relationship'] as String,
    photoUrl: json['photoUrl'] as String?,
    language: json['language'] as String? ?? 'en',
    whatsapp: json['whatsapp'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
