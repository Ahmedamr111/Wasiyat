import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vault_item_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/trigger_model.dart';
import 'messages_provider.dart';
import 'auth_provider.dart';

// ── Real-time Vault Stream ─────────────────────────────────────────────────
final vaultStreamProvider = StreamProvider<List<VaultItemModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final db = ref.watch(firestoreServiceProvider);
  return db.vaultItemsStream(user.id);
});

// ── Real-time Trusted Contacts Stream ─────────────────────────────────────
final trustedContactsStreamProvider =
    StreamProvider<List<TrustedContactModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final db = ref.watch(firestoreServiceProvider);
  return db.trustedContactsStream(user.id);
});

// ── Vault Provider ─────────────────────────────────────────────────────────
final vaultProvider =
    StateNotifierProvider<VaultNotifier, AsyncValue<List<VaultItemModel>>>(
        (ref) {
  final notifier = VaultNotifier(ref);
  ref.listen<AsyncValue<List<VaultItemModel>>>(
    vaultStreamProvider,
    (_, next) => notifier.syncFromStream(next),
    fireImmediately: true,
  );
  return notifier;
});

class VaultNotifier extends StateNotifier<AsyncValue<List<VaultItemModel>>> {
  final Ref _ref;

  VaultNotifier(this._ref) : super(const AsyncValue.loading());

  void syncFromStream(AsyncValue<List<VaultItemModel>> streamValue) {
    state = streamValue;
  }

  Future<VaultItemModel> createItem(VaultItemModel item) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.createVaultItem(item);
  }

  Future<VaultItemModel> updateItem(VaultItemModel item) async {
    final db = _ref.read(firestoreServiceProvider);
    return await db.updateVaultItem(item);
  }

  Future<void> deleteItem(String itemId) async {
    final db = _ref.read(firestoreServiceProvider);
    await db.deleteVaultItem(itemId);
  }
}

// ── Trusted Contacts Provider ──────────────────────────────────────────────
final trustedContactsProvider = StateNotifierProvider<TrustedContactsNotifier,
    AsyncValue<List<TrustedContactModel>>>((ref) {
  final notifier = TrustedContactsNotifier(ref);
  // Auto-sync from real-time stream
  ref.listen<AsyncValue<List<TrustedContactModel>>>(
    trustedContactsStreamProvider,
    (_, next) => notifier.syncFromStream(next),
    fireImmediately: true,
  );
  return notifier;
});

class TrustedContactsNotifier
    extends StateNotifier<AsyncValue<List<TrustedContactModel>>> {
  final Ref _ref;

  TrustedContactsNotifier(this._ref) : super(const AsyncValue.loading());

  void syncFromStream(AsyncValue<List<TrustedContactModel>> v) => state = v;

  Future<TrustedContactModel> addContact(TrustedContactModel contact) async {
    final db = _ref.read(firestoreServiceProvider);
    final newContact = await db.createTrustedContact(contact);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, newContact]);
    return newContact;
  }

  Future<void> removeContact(String contactId) async {
    final db = _ref.read(firestoreServiceProvider);
    await db.deleteTrustedContact(contactId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((tc) => tc.id != contactId).toList(),
    );
  }
}

// ── Real-time Trigger Stream ──────────────────────────────────────────────
final triggerStreamProvider = StreamProvider<TriggerModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final db = ref.watch(firestoreServiceProvider);
  return db.triggerStream(user.id);
});

// ── Trigger Provider ───────────────────────────────────────────────────────
final triggerProvider =
    StateNotifierProvider<TriggerNotifier, AsyncValue<TriggerModel?>>((ref) {
  final notifier = TriggerNotifier(ref);
  ref.listen<AsyncValue<TriggerModel?>>(
    triggerStreamProvider,
    (_, next) => notifier.syncFromStream(next),
    fireImmediately: true,
  );
  return notifier;
});

class TriggerNotifier extends StateNotifier<AsyncValue<TriggerModel?>> {
  final Ref _ref;

  TriggerNotifier(this._ref) : super(const AsyncValue.loading());

  void syncFromStream(AsyncValue<TriggerModel?> streamValue) {
    state = streamValue;
  }

  Future<void> updateTrigger(TriggerModel trigger) async {
    final db = _ref.read(firestoreServiceProvider);
    await db.updateTrigger(trigger);
  }
}

// ── Subscription/Tier Provider ─────────────────────────────────────────────
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, UserSubscription>((ref) {
  return SubscriptionNotifier();
});

class UserSubscription {
  final bool isPremium;
  final String planName;
  final double? monthlyPrice;
  final DateTime? expiresAt;

  const UserSubscription({
    this.isPremium = false,
    this.planName = 'Free',
    this.monthlyPrice,
    this.expiresAt,
  });
}

class SubscriptionNotifier extends StateNotifier<UserSubscription> {
  SubscriptionNotifier() : super(const UserSubscription());

  void upgradeToPremium() {
    state = UserSubscription(
      isPremium: true,
      planName: 'Premium',
      monthlyPrice: 4.99,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }

  void downgradeToFree() {
    state = const UserSubscription();
  }
}

// ── Locale Provider ────────────────────────────────────────────────────────
final localeProvider = StateProvider<String>((ref) => 'en');

// ── Bottom Nav Index ───────────────────────────────────────────────────────
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ── Onboarding Complete ────────────────────────────────────────────────────
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);
