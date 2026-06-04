/// Message model matching Firestore /messages/{messageId} schema
class MessageModel {
  final String id;
  final String userId;
  final String title;
  final MessageType type;
  final ContentType contentType;
  final String? contentEncrypted;
  final String? contentPlain; // Used locally before encryption
  final String? mediaUrl;
  final List<MessageRecipient> recipients;
  final MessageSchedule? schedule;
  final bool isDelivered;
  final List<DeliveryLogEntry> deliveryLog;
  final bool isPinLocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MessageModel({
    required this.id,
    required this.userId,
    required this.title,
    this.type = MessageType.immediate,
    this.contentType = ContentType.text,
    this.contentEncrypted,
    this.contentPlain,
    this.mediaUrl,
    this.recipients = const [],
    this.schedule,
    this.isDelivered = false,
    this.deliveryLog = const [],
    this.isPinLocked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get typeLabel {
    switch (type) {
      case MessageType.immediate:
        return 'Immediate';
      case MessageType.recurring:
        return 'Recurring';
      case MessageType.occasion:
        return 'Occasion';
      case MessageType.milestone:
        return 'Milestone';
    }
  }

  String get contentTypeIcon {
    switch (contentType) {
      case ContentType.text:
        return '📝';
      case ContentType.voice:
        return '🎙️';
      case ContentType.photo:
        return '🖼️';
      case ContentType.video:
        return '🎥';
      case ContentType.file:
        return '📎';
    }
  }

  MessageModel copyWith({
    String? id,
    String? userId,
    String? title,
    MessageType? type,
    ContentType? contentType,
    String? contentEncrypted,
    String? contentPlain,
    String? mediaUrl,
    List<MessageRecipient>? recipients,
    MessageSchedule? schedule,
    bool? isDelivered,
    List<DeliveryLogEntry>? deliveryLog,
    bool? isPinLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      contentType: contentType ?? this.contentType,
      contentEncrypted: contentEncrypted ?? this.contentEncrypted,
      contentPlain: contentPlain ?? this.contentPlain,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      recipients: recipients ?? this.recipients,
      schedule: schedule ?? this.schedule,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveryLog: deliveryLog ?? this.deliveryLog,
      isPinLocked: isPinLocked ?? this.isPinLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'type': type.name,
    'contentType': contentType.name,
    'contentEncrypted': contentEncrypted,
    'contentPlain': contentPlain,
    'mediaUrl': mediaUrl,
    'recipients': recipients.map((r) => r.toJson()).toList(),
    'schedule': schedule?.toJson(),
    'isDelivered': isDelivered,
    'deliveryLog': deliveryLog.map((d) => d.toJson()).toList(),
    'isPinLocked': isPinLocked,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    title: json['title'] as String,
    type: MessageType.values.firstWhere((e) => e.name == json['type']),
    contentType:
        ContentType.values.firstWhere((e) => e.name == json['contentType']),
    contentEncrypted: json['contentEncrypted'] as String?,
    contentPlain: json['contentPlain'] as String?,
    mediaUrl: json['mediaUrl'] as String?,
    recipients: (json['recipients'] as List<dynamic>?)
            ?.map((e) => MessageRecipient.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    schedule: json['schedule'] != null
        ? MessageSchedule.fromJson(json['schedule'] as Map<String, dynamic>)
        : null,
    isDelivered: json['isDelivered'] as bool? ?? false,
    deliveryLog: (json['deliveryLog'] as List<dynamic>?)
            ?.map((e) => DeliveryLogEntry.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    isPinLocked: json['isPinLocked'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

enum MessageType { immediate, recurring, occasion, milestone }

enum ContentType { text, voice, photo, video, file }

class MessageRecipient {
  final String recipientId;
  final String channel; // 'whatsapp', 'email', 'sms'

  const MessageRecipient({
    required this.recipientId,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
    'recipientId': recipientId,
    'channel': channel,
  };

  factory MessageRecipient.fromJson(Map<String, dynamic> json) =>
      MessageRecipient(
        recipientId: json['recipientId'] as String,
        channel: json['channel'] as String,
      );
}

class MessageSchedule {
  final RecurringType? recurringType;
  final RecurringDuration? recurringFor;
  final DateTime? occasionDate;
  final String? milestoneLabel;

  const MessageSchedule({
    this.recurringType,
    this.recurringFor,
    this.occasionDate,
    this.milestoneLabel,
  });

  Map<String, dynamic> toJson() => {
    'recurringType': recurringType?.name,
    'recurringFor': recurringFor?.name,
    'occasionDate': occasionDate?.toIso8601String(),
    'milestoneLabel': milestoneLabel,
  };

  factory MessageSchedule.fromJson(Map<String, dynamic> json) =>
      MessageSchedule(
        recurringType: json['recurringType'] != null
            ? RecurringType.values
                .firstWhere((e) => e.name == json['recurringType'])
            : null,
        recurringFor: json['recurringFor'] != null
            ? RecurringDuration.values
                .firstWhere((e) => e.name == json['recurringFor'])
            : null,
        occasionDate: json['occasionDate'] != null
            ? DateTime.parse(json['occasionDate'] as String)
            : null,
        milestoneLabel: json['milestoneLabel'] as String?,
      );
}

enum RecurringType { weekly, monthly, yearly }

enum RecurringDuration { threeMonths, oneYear, forever }

class DeliveryLogEntry {
  final DateTime timestamp;
  final String status; // 'sent', 'failed', 'retrying'
  final String? error;

  const DeliveryLogEntry({
    required this.timestamp,
    required this.status,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'status': status,
    'error': error,
  };

  factory DeliveryLogEntry.fromJson(Map<String, dynamic> json) =>
      DeliveryLogEntry(
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: json['status'] as String,
        error: json['error'] as String?,
      );
}
