/// Vault Item model for the encrypted vault (Premium feature)
class VaultItemModel {
  final String id;
  final String userId;
  final VaultItemType type;
  final String title;
  final String? contentEncrypted;
  final String? contentPlain; // Used locally before encryption
  final String? mediaUrl;
  final bool isPublic; // For "letter to the world"
  final Map<String, String>? metadata; // Extra info (e.g., credential labels)
  final DateTime createdAt;
  final DateTime updatedAt;

  const VaultItemModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.contentEncrypted,
    this.contentPlain,
    this.mediaUrl,
    this.isPublic = false,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  String get typeIcon {
    switch (type) {
      case VaultItemType.digitalWill:
        return '📜';
      case VaultItemType.credentials:
        return '🔐';
      case VaultItemType.videoTestament:
        return '🎬';
      case VaultItemType.letterToWorld:
        return '🌍';
    }
  }

  String get typeLabel {
    switch (type) {
      case VaultItemType.digitalWill:
        return 'Digital Will';
      case VaultItemType.credentials:
        return 'Credentials';
      case VaultItemType.videoTestament:
        return 'Video Testament';
      case VaultItemType.letterToWorld:
        return 'Letter to the World';
    }
  }

  VaultItemModel copyWith({
    String? id,
    String? userId,
    VaultItemType? type,
    String? title,
    String? contentEncrypted,
    String? contentPlain,
    String? mediaUrl,
    bool? isPublic,
    Map<String, String>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VaultItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      contentEncrypted: contentEncrypted ?? this.contentEncrypted,
      contentPlain: contentPlain ?? this.contentPlain,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isPublic: isPublic ?? this.isPublic,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type.name,
    'title': title,
    'contentEncrypted': contentEncrypted,
    'contentPlain': contentPlain,
    'mediaUrl': mediaUrl,
    'isPublic': isPublic,
    'metadata': metadata,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory VaultItemModel.fromJson(Map<String, dynamic> json) => VaultItemModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    type: VaultItemType.values.firstWhere((e) => e.name == json['type']),
    title: json['title'] as String,
    contentEncrypted: json['contentEncrypted'] as String?,
    contentPlain: json['contentPlain'] as String?,
    mediaUrl: json['mediaUrl'] as String?,
    isPublic: json['isPublic'] as bool? ?? false,
    metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
      (k, v) => MapEntry(k, v as String),
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

enum VaultItemType {
  digitalWill,
  credentials,
  videoTestament,
  letterToWorld,
}
