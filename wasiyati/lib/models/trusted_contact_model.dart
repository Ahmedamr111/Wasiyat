/// Trusted Contact model matching Firestore /trustedContacts/{contactId} schema
class TrustedContactModel {
  final String id;
  final String userId; // owner of the account
  final String? contactUserId; // if they have an account
  final String? externalEmail; // if they don't
  final String name;
  final String? relationship;
  final TrustedContactStatus status;
  final DateTime invitedAt;
  final DateTime? acceptedAt;

  const TrustedContactModel({
    required this.id,
    required this.userId,
    this.contactUserId,
    this.externalEmail,
    required this.name,
    this.relationship,
    this.status = TrustedContactStatus.invited,
    required this.invitedAt,
    this.acceptedAt,
  });

  bool get isAccepted => status == TrustedContactStatus.accepted;

  TrustedContactModel copyWith({
    String? id,
    String? userId,
    String? contactUserId,
    String? externalEmail,
    String? name,
    String? relationship,
    TrustedContactStatus? status,
    DateTime? invitedAt,
    DateTime? acceptedAt,
  }) {
    return TrustedContactModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contactUserId: contactUserId ?? this.contactUserId,
      externalEmail: externalEmail ?? this.externalEmail,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
      invitedAt: invitedAt ?? this.invitedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'contactUserId': contactUserId,
    'externalEmail': externalEmail,
    'name': name,
    'relationship': relationship,
    'status': status.name,
    'invitedAt': invitedAt.toIso8601String(),
    'acceptedAt': acceptedAt?.toIso8601String(),
  };

  factory TrustedContactModel.fromJson(Map<String, dynamic> json) =>
      TrustedContactModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        contactUserId: json['contactUserId'] as String?,
        externalEmail: json['externalEmail'] as String?,
        name: json['name'] as String,
        relationship: json['relationship'] as String?,
        status: TrustedContactStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => TrustedContactStatus.invited,
        ),
        invitedAt: DateTime.parse(json['invitedAt'] as String),
        acceptedAt: json['acceptedAt'] != null
            ? DateTime.parse(json['acceptedAt'] as String)
            : null,
      );
}

enum TrustedContactStatus { invited, accepted, declined }
