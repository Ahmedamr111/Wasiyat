import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipient_model.dart';
import '../services/database_service.dart';
import 'messages_provider.dart';

// ── Recipients Provider ──
final recipientsProvider =
    StateNotifierProvider<RecipientsNotifier, AsyncValue<List<RecipientModel>>>(
        (ref) {
  final db = ref.watch(databaseServiceProvider);
  return RecipientsNotifier(db);
});

class RecipientsNotifier
    extends StateNotifier<AsyncValue<List<RecipientModel>>> {
  final DatabaseService _db;

  RecipientsNotifier(this._db) : super(const AsyncValue.loading());

  Future<void> loadRecipients(String userId) async {
    state = const AsyncValue.loading();
    try {
      final recipients = await _db.getRecipients(userId);
      state = AsyncValue.data(recipients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<RecipientModel> createRecipient(RecipientModel recipient) async {
    final newRecipient = await _db.createRecipient(recipient);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, newRecipient]);
    return newRecipient;
  }

  Future<RecipientModel> updateRecipient(RecipientModel recipient) async {
    final updated = await _db.updateRecipient(recipient);
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      final newList = List<RecipientModel>.from(current);
      newList[index] = updated;
      state = AsyncValue.data(newList);
    }
    return updated;
  }

  Future<void> deleteRecipient(String recipientId) async {
    await _db.deleteRecipient(recipientId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((r) => r.id != recipientId).toList(),
    );
  }

  RecipientModel? getRecipientById(String id) {
    return state.valueOrNull?.where((r) => r.id == id).firstOrNull;
  }
}

final recipientsCountProvider = Provider<int>((ref) {
  return ref.watch(recipientsProvider).valueOrNull?.length ?? 0;
});
