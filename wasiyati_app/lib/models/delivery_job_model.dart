/// Delivery Job model matching Firestore /deliveryQueue/{jobId} schema
class DeliveryJobModel {
  final String id;
  final String messageId;
  final String recipientId;
  final String channel; // 'email', 'sms', 'whatsapp'
  final DateTime scheduledFor;
  final DeliveryStatus status;
  final int attempts;
  final DateTime? lastAttemptAt;
  final DateTime? sentAt;
  final String? errorMessage;

  const DeliveryJobModel({
    required this.id,
    required this.messageId,
    required this.recipientId,
    required this.channel,
    required this.scheduledFor,
    this.status = DeliveryStatus.queued,
    this.attempts = 0,
    this.lastAttemptAt,
    this.sentAt,
    this.errorMessage,
  });

  bool get isSent => status == DeliveryStatus.sent;
  bool get isFailed => status == DeliveryStatus.failed;
  bool get isRetrying => status == DeliveryStatus.retrying;

  DeliveryJobModel copyWith({
    String? id,
    String? messageId,
    String? recipientId,
    String? channel,
    DateTime? scheduledFor,
    DeliveryStatus? status,
    int? attempts,
    DateTime? lastAttemptAt,
    DateTime? sentAt,
    String? errorMessage,
  }) {
    return DeliveryJobModel(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      recipientId: recipientId ?? this.recipientId,
      channel: channel ?? this.channel,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      sentAt: sentAt ?? this.sentAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'messageId': messageId,
    'recipientId': recipientId,
    'channel': channel,
    'scheduledFor': scheduledFor.toIso8601String(),
    'status': status.name,
    'attempts': attempts,
    'lastAttemptAt': lastAttemptAt?.toIso8601String(),
    'sentAt': sentAt?.toIso8601String(),
    'errorMessage': errorMessage,
  };

  factory DeliveryJobModel.fromJson(Map<String, dynamic> json) =>
      DeliveryJobModel(
        id: json['id'] as String,
        messageId: json['messageId'] as String,
        recipientId: json['recipientId'] as String,
        channel: json['channel'] as String,
        scheduledFor: DateTime.parse(json['scheduledFor'] as String),
        status: DeliveryStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => DeliveryStatus.queued,
        ),
        attempts: json['attempts'] as int? ?? 0,
        lastAttemptAt: json['lastAttemptAt'] != null
            ? DateTime.parse(json['lastAttemptAt'] as String)
            : null,
        sentAt: json['sentAt'] != null
            ? DateTime.parse(json['sentAt'] as String)
            : null,
        errorMessage: json['errorMessage'] as String?,
      );
}

enum DeliveryStatus { queued, sent, failed, retrying }
