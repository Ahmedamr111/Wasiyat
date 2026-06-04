/// Trigger model matching Firestore /triggers/{triggerId} schema
/// Tracks the Dead Man's Switch state machine
class TriggerModel {
  final String id;
  final String userId;
  final TriggerStatus status;
  final DateTime? lastCheckInSent;
  final DateTime? checkInDeadline;
  final DateTime? confirmationRequestedAt;
  final String? confirmedBy; // contactId
  final DateTime? confirmedAt;
  final DateTime? gracePeriodEndsAt;
  final DateTime? cancelledAt;

  const TriggerModel({
    required this.id,
    required this.userId,
    this.status = TriggerStatus.watching,
    this.lastCheckInSent,
    this.checkInDeadline,
    this.confirmationRequestedAt,
    this.confirmedBy,
    this.confirmedAt,
    this.gracePeriodEndsAt,
    this.cancelledAt,
  });

  /// Days remaining until check-in deadline
  int get daysRemaining {
    if (checkInDeadline == null) return 0;
    final diff = checkInDeadline!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Hours remaining in grace period
  int get graceHoursRemaining {
    if (gracePeriodEndsAt == null) return 0;
    final diff = gracePeriodEndsAt!.difference(DateTime.now()).inHours;
    return diff > 0 ? diff : 0;
  }

  bool get isInGracePeriod => status == TriggerStatus.gracePeriod;
  bool get isWatching => status == TriggerStatus.watching;
  bool get isPendingConfirmation => status == TriggerStatus.pendingConfirmation;

  TriggerModel copyWith({
    String? id,
    String? userId,
    TriggerStatus? status,
    DateTime? lastCheckInSent,
    DateTime? checkInDeadline,
    DateTime? confirmationRequestedAt,
    String? confirmedBy,
    DateTime? confirmedAt,
    DateTime? gracePeriodEndsAt,
    DateTime? cancelledAt,
  }) {
    return TriggerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      lastCheckInSent: lastCheckInSent ?? this.lastCheckInSent,
      checkInDeadline: checkInDeadline ?? this.checkInDeadline,
      confirmationRequestedAt:
          confirmationRequestedAt ?? this.confirmationRequestedAt,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      gracePeriodEndsAt: gracePeriodEndsAt ?? this.gracePeriodEndsAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'status': status.name,
    'lastCheckInSent': lastCheckInSent?.toIso8601String(),
    'checkInDeadline': checkInDeadline?.toIso8601String(),
    'confirmationRequestedAt': confirmationRequestedAt?.toIso8601String(),
    'confirmedBy': confirmedBy,
    'confirmedAt': confirmedAt?.toIso8601String(),
    'gracePeriodEndsAt': gracePeriodEndsAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
  };

  factory TriggerModel.fromJson(Map<String, dynamic> json) => TriggerModel(
    id: json['id'] as String? ?? '',
    userId: json['userId'] as String? ?? '',
    status: TriggerStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => TriggerStatus.watching,
    ),
    lastCheckInSent: _parseDate(json['lastCheckInSent']),
    checkInDeadline: _parseDate(json['checkInDeadline']),
    confirmationRequestedAt: _parseDate(json['confirmationRequestedAt']),
    confirmedBy: json['confirmedBy'] as String?,
    confirmedAt: _parseDate(json['confirmedAt']),
    gracePeriodEndsAt: _parseDate(json['gracePeriodEndsAt']),
    cancelledAt: _parseDate(json['cancelledAt']),
  );

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    try { return (v as dynamic).toDate() as DateTime; } catch (_) { return null; }
  }
}


enum TriggerStatus {
  watching,           // Normal state — monitoring check-ins
  pendingConfirmation, // Missed check-in — waiting for trusted contact
  gracePeriod,         // Confirmed by TC — 48hr grace before delivery
  confirmed,           // Grace period expired — messages being delivered
  cancelled,           // False alarm — user cancelled during grace
}
