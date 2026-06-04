import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipient_model.dart';
import 'messages_provider.dart';
import 'auth_provider.dart';

// ── Real-time Recipients Stream ────────────────────────────────────────────
final recipientsStreamProvider = StreamProvider<List<RecipientModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final db = ref.watch(firestoreServiceProvider);
  return db.recipientsStream(user.id);
});

// ── Recipients Provider ────────────────────────────────────────────────────
final recipientsProvider =
    StateNotifierProvider<RecipientsNotifier, AsyncValue<List<RecipientModel>>>(
        (ref) {
  final notifier = RecipientsNotifier(ref);
  ref.listen<AsyncValue<List<RecipientModel>>>(
    recipientsStreamProvider,
    (_, next) => notifier.syncFromStream(next),
    fireImmediately: true,
  );
  return notifier;
});

class RecipientsNotifier
    extends StateNotifier<AsyncValue<List<RecipientModel>>> {
  final Ref _ref;

  RecipientsNotifier(this._ref) : super(const AsyncValue.loading());

  void syncFromStream(AsyncValue<List<RecipientModel>> streamValue) {
    state = streamValue;
  }

  Future<RecipientModel> createRecipient(RecipientModel recipient) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.createRecipient(recipient);
  }

  Future<RecipientModel> updateRecipient(RecipientModel recipient) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.updateRecipient(recipient);
  }

  Future<void> deleteRecipient(String recipientId) async {
    final db = _ref.read(firestoreServiceProvider);
    await db.deleteRecipient(recipientId);
  }

  RecipientModel? getRecipientById(String id) {
    return state.valueOrNull?.where((r) => r.id == id).firstOrNull;
  }
}

final recipientsCountProvider = Provider<int>((ref) {
  return ref.watch(recipientsProvider).valueOrNull?.length ?? 0;
});
