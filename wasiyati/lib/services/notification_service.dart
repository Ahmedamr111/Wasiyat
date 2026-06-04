/// Notification service for push notifications and reminders
abstract class NotificationService {
  /// Initialize notification system
  Future<void> initialize();

  /// Schedule a local notification
  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  });

  /// Cancel a scheduled notification
  Future<void> cancelNotification(String id);

  /// Show an immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
  });

  /// Schedule check-in reminder
  Future<void> scheduleCheckInReminder(DateTime checkInDate);

  /// Schedule occasion reminder
  Future<void> scheduleOccasionReminder({
    required String recipientName,
    required DateTime occasionDate,
    required String messageTitle,
  });
}

class MockNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    // Mock: no-op
  }

  @override
  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    // Mock: log notification
  }

  @override
  Future<void> cancelNotification(String id) async {
    // Mock: no-op
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Mock: no-op
  }

  @override
  Future<void> scheduleCheckInReminder(DateTime checkInDate) async {
    // Mock: no-op
  }

  @override
  Future<void> scheduleOccasionReminder({
    required String recipientName,
    required DateTime occasionDate,
    required String messageTitle,
  }) async {
    // Mock: no-op
  }
}
