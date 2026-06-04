import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/database_service.dart';

// ── Database Service Provider ──
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return MockDatabaseService();
});

// ── Messages Provider ──
final messagesProvider =
    StateNotifierProvider<MessagesNotifier, AsyncValue<List<MessageModel>>>(
        (ref) {
  final db = ref.watch(databaseServiceProvider);
  return MessagesNotifier(db);
});

class MessagesNotifier extends StateNotifier<AsyncValue<List<MessageModel>>> {
  final DatabaseService _db;

  MessagesNotifier(this._db) : super(const AsyncValue.loading());

  Future<void> loadMessages(String userId) async {
    state = const AsyncValue.loading();
    try {
      final messages = await _db.getMessages(userId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<MessageModel> createMessage(MessageModel message) async {
    final newMessage = await _db.createMessage(message);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([newMessage, ...current]);
    return newMessage;
  }

  Future<MessageModel> updateMessage(MessageModel message) async {
    final updated = await _db.updateMessage(message);
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      final newList = List<MessageModel>.from(current);
      newList[index] = updated;
      state = AsyncValue.data(newList);
    }
    return updated;
  }

  Future<void> deleteMessage(String messageId) async {
    await _db.deleteMessage(messageId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((m) => m.id != messageId).toList(),
    );
  }
}

// ── Filtered messages ──
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
