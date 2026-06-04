import '../models/trigger_model.dart';
import '../config/constants.dart';

/// Check-in service — manages the Dead Man's Switch logic
abstract class CheckinService {
  /// Perform a check-in (user confirms they're alive)
  Future<TriggerModel> performCheckIn(TriggerModel trigger);

  /// Start the confirmation process (trusted contact notified)
  Future<TriggerModel> startConfirmation(TriggerModel trigger, String contactId);

  /// Enter grace period (trusted contact confirmed)
  Future<TriggerModel> enterGracePeriod(TriggerModel trigger, String contactId);

  /// Cancel during grace period (false alarm)
  Future<TriggerModel> cancelGracePeriod(TriggerModel trigger);

  /// Confirm passing (grace period expired)
  Future<TriggerModel> confirmPassing(TriggerModel trigger);

  /// Calculate next check-in date
  DateTime calculateNextCheckIn(DateTime lastCheckIn);

  /// Check if check-in is overdue
  bool isCheckInOverdue(TriggerModel trigger);
}

class MockCheckinService implements CheckinService {
  @override
  Future<TriggerModel> performCheckIn(TriggerModel trigger) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    return trigger.copyWith(
      status: TriggerStatus.watching,
      lastCheckInSent: now,
      checkInDeadline: calculateNextCheckIn(now),
    );
  }

  @override
  Future<TriggerModel> startConfirmation(
      TriggerModel trigger, String contactId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return trigger.copyWith(
      status: TriggerStatus.pendingConfirmation,
      confirmationRequestedAt: DateTime.now(),
    );
  }

  @override
  Future<TriggerModel> enterGracePeriod(
      TriggerModel trigger, String contactId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    return trigger.copyWith(
      status: TriggerStatus.gracePeriod,
      confirmedBy: contactId,
      confirmedAt: now,
      gracePeriodEndsAt: now.add(
        const Duration(hours: AppConstants.gracePeriodHours),
      ),
    );
  }

  @override
  Future<TriggerModel> cancelGracePeriod(TriggerModel trigger) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    return trigger.copyWith(
      status: TriggerStatus.watching,
      cancelledAt: now,
      lastCheckInSent: now,
      checkInDeadline: calculateNextCheckIn(now),
    );
  }

  @override
  Future<TriggerModel> confirmPassing(TriggerModel trigger) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return trigger.copyWith(
      status: TriggerStatus.confirmed,
    );
  }

  @override
  DateTime calculateNextCheckIn(DateTime lastCheckIn) {
    return lastCheckIn.add(
      const Duration(days: AppConstants.checkInIntervalDays),
    );
  }

  @override
  bool isCheckInOverdue(TriggerModel trigger) {
    if (trigger.checkInDeadline == null) return false;
    return DateTime.now().isAfter(trigger.checkInDeadline!);
  }
}
