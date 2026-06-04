import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/firestore_database_service.dart';
import 'auth_provider.dart';

// ── Firestore Service Provider ──────────────────────────────────────────────
final firestoreServiceProvider = Provider<FirestoreDatabaseService>((ref) {
  return FirestoreDatabaseService();
});

// ── Real-time Messages Stream ──────────────────────────────────────────────
// Automatically updates when Firestore changes
final messagesStreamProvider = StreamProvider<List<MessageModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final db = ref.watch(firestoreServiceProvider);
  return db.messagesStream(user.id);
});

// ── Messages Provider (kept for backward compat with screens) ──────────────
// Wraps the stream into the existing StateNotifier pattern
final messagesProvider =
    StateNotifierProvider<MessagesNotifier, AsyncValue<List<MessageModel>>>(
        (ref) {
  final notifier = MessagesNotifier(ref);
  // Keep in sync with the real-time stream
  ref.listen<AsyncValue<List<MessageModel>>>(
    messagesStreamProvider,
    (_, next) => notifier.syncFromStream(next),
    fireImmediately: true,
  );
  return notifier;
});

class MessagesNotifier
    extends StateNotifier<AsyncValue<List<MessageModel>>> {
  final Ref _ref;

  MessagesNotifier(this._ref) : super(const AsyncValue.loading());

  void syncFromStream(AsyncValue<List<MessageModel>> streamValue) {
    state = streamValue;
  }

  Future<MessageModel> createMessage(MessageModel message) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.createMessage(message);
    // Stream will auto-update the list
  }

  Future<MessageModel> updateMessage(MessageModel message) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.updateMessage(message);
    // Stream will auto-update the list
  }

  Future<void> deleteMessage(String messageId) async {
    final db = _ref.read(firestoreServiceProvider);
    await db.deleteMessage(messageId);
    // Stream will auto-update the list
  }
}

// ── Filtered message providers ─────────────────────────────────────────────
final immediateMessagesProvider = Provider<List<MessageModel>>((ref) {
  final messages = ref.watch(messagesProvider).valueOrNull ?? [];
  return messages.where((m) => m.type == MessageType.immediate).toList();
});

final recurringMessagesProvider = Provider<List<MessageModel>>((ref) {
  final messages = ref.watch(messagesProvider).valueOrNull ?? [];
  return messages.where((m) => m.type == MessageType.recurring).toList();
});

final occasionMessagesProvider = Provider<List<MessageModel>>((ref) {
  final messages = ref.watch(messagesProvider).valueOrNull ?? [];
  return messages.where((m) => m.type == MessageType.occasion).toList();
});

final milestoneMessagesProvider = Provider<List<MessageModel>>((ref) {
  final messages = ref.watch(messagesProvider).valueOrNull ?? [];
  return messages.where((m) => m.type == MessageType.milestone).toList();
});

final messagesCountProvider = Provider<int>((ref) {
  return ref.watch(messagesProvider).valueOrNull?.length ?? 0;
});
