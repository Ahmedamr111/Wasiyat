import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vault_item_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/trigger_model.dart';
import '../services/database_service.dart';
import 'messages_provider.dart';

// ── Vault Provider ──
final vaultProvider =
    StateNotifierProvider<VaultNotifier, AsyncValue<List<VaultItemModel>>>(
        (ref) {
  final db = ref.watch(databaseServiceProvider);
  return VaultNotifier(db);
});

class VaultNotifier extends StateNotifier<AsyncValue<List<VaultItemModel>>> {
  final DatabaseService _db;

  VaultNotifier(this._db) : super(const AsyncValue.loading());

  Future<void> loadVaultItems(String userId) async {
    state = const AsyncValue.loading();
    try {
      final items = await _db.getVaultItems(userId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<VaultItemModel> createItem(VaultItemModel item) async {
    final newItem = await _db.createVaultItem(item);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, newItem]);
    return newItem;
  }

  Future<VaultItemModel> updateItem(VaultItemModel item) async {
    final updated = await _db.updateVaultItem(item);
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((v) => v.id == updated.id);
    if (index != -1) {
      final newList = List<VaultItemModel>.from(current);
      newList[index] = updated;
      state = AsyncValue.data(newList);
    }
    return updated;
  }

  Future<void> deleteItem(String itemId) async {
    await _db.deleteVaultItem(itemId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((v) => v.id != itemId).toList(),
    );
  }
}

// ── Trusted Contacts Provider ──
final trustedContactsProvider = StateNotifierProvider<TrustedContactsNotifier,
    AsyncValue<List<TrustedContactModel>>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return TrustedContactsNotifier(db);
});

class TrustedContactsNotifier
    extends StateNotifier<AsyncValue<List<TrustedContactModel>>> {
  final DatabaseService _db;

  TrustedContactsNotifier(this._db) : super(const AsyncValue.loading());

  Future<void> loadContacts(String userId) async {
    state = const AsyncValue.loading();
    try {
      final contacts = await _db.getTrustedContacts(userId);
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<TrustedContactModel> addContact(TrustedContactModel contact) async {
    final newContact = await _db.createTrustedContact(contact);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([...current, newContact]);
    return newContact;
  }

  Future<void> removeContact(String contactId) async {
    await _db.deleteTrustedContact(contactId);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((tc) => tc.id != contactId).toList(),
    );
  }
}

// ── Trigger Provider ──
final triggerProvider =
    StateNotifierProvider<TriggerNotifier, AsyncValue<TriggerModel?>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return TriggerNotifier(db);
});

class TriggerNotifier extends StateNotifier<AsyncValue<TriggerModel?>> {
  final DatabaseService _db;

  TriggerNotifier(this._db) : super(const AsyncValue.loading());

  Future<void> loadTrigger(String userId) async {
    state = const AsyncValue.loading();
    try {
      final trigger = await _db.getActiveTrigger(userId);
      state = AsyncValue.data(trigger);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTrigger(TriggerModel trigger) async {
    final updated = await _db.updateTrigger(trigger);
    state = AsyncValue.data(updated);
  }
}

// ── Subscription/Tier Provider ──
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

// ── Locale Provider ──
final localeProvider = StateProvider<String>((ref) => 'en');

// ── Bottom Nav Index ──
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ── Onboarding Complete ──
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);
