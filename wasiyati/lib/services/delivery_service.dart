import '../models/delivery_job_model.dart';

/// Delivery service — handles sending messages via email, SMS, WhatsApp
abstract class DeliveryService {
  /// Queue a message for delivery
  Future<DeliveryJobModel> queueDelivery({
    required String messageId,
    required String recipientId,
    required String channel,
    required DateTime scheduledFor,
  });

  /// Send a test message (Premium feature)
  Future<bool> sendTestMessage({
    required String recipientId,
    required String channel,
    required String content,
  });

  /// Get delivery status for a message
  Future<List<DeliveryJobModel>> getDeliveryStatus(String messageId);

  /// Retry a failed delivery
  Future<DeliveryJobModel> retryDelivery(String jobId);
}

class MockDeliveryService implements DeliveryService {
  final List<DeliveryJobModel> _jobs = [];
  int _idCounter = 0;

  @override
  Future<DeliveryJobModel> queueDelivery({
    required String messageId,
    required String recipientId,
    required String channel,
    required DateTime scheduledFor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final job = DeliveryJobModel(
      id: 'job_${++_idCounter}',
      messageId: messageId,
      recipientId: recipientId,
      channel: channel,
      scheduledFor: scheduledFor,
      status: DeliveryStatus.queued,
    );
    _jobs.add(job);
    return job;
  }

  @override
  Future<bool> sendTestMessage({
    required String recipientId,
    required String channel,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Mock: always succeed
    return true;
  }

  @override
  Future<List<DeliveryJobModel>> getDeliveryStatus(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _jobs.where((j) => j.messageId == messageId).toList();
  }

  @override
  Future<DeliveryJobModel> retryDelivery(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) throw Exception('Job not found');
    
    final updated = _jobs[index].copyWith(
      status: DeliveryStatus.retrying,
      attempts: _jobs[index].attempts + 1,
      lastAttemptAt: DateTime.now(),
    );
    _jobs[index] = updated;
    return updated;
  }
}
