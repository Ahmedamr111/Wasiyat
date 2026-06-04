import 'dart:async';
import '../models/message_model.dart';
import '../models/recipient_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/trigger_model.dart';
import '../models/vault_item_model.dart';
import '../data/mock_data.dart';

/// Abstract database service — swap mock for Firestore later
abstract class DatabaseService {
  // Messages
  Future<List<MessageModel>> getMessages(String userId);
  Future<MessageModel?> getMessage(String messageId);
  Future<MessageModel> createMessage(MessageModel message);
  Future<MessageModel> updateMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);

  // Recipients
  Future<List<RecipientModel>> getRecipients(String userId);
  Future<RecipientModel?> getRecipient(String recipientId);
  Future<RecipientModel> createRecipient(RecipientModel recipient);
  Future<RecipientModel> updateRecipient(RecipientModel recipient);
  Future<void> deleteRecipient(String recipientId);

  // Trusted Contacts
  Future<List<TrustedContactModel>> getTrustedContacts(String userId);
  Future<TrustedContactModel> createTrustedContact(TrustedContactModel contact);
  Future<TrustedContactModel> updateTrustedContact(TrustedContactModel contact);
  Future<void> deleteTrustedContact(String contactId);

  // Triggers
  Future<TriggerModel?> getActiveTrigger(String userId);
  Future<TriggerModel> updateTrigger(TriggerModel trigger);

  // Vault
  Future<List<VaultItemModel>> getVaultItems(String userId);
  Future<VaultItemModel> createVaultItem(VaultItemModel item);
  Future<VaultItemModel> updateVaultItem(VaultItemModel item);
  Future<void> deleteVaultItem(String itemId);
}

/// Mock implementation using in-memory data
class MockDatabaseService implements DatabaseService {
  // In-memory stores initialized from MockData
  final List<MessageModel> _messages = List.from(MockData.messages);
  final List<RecipientModel> _recipients = List.from(MockData.recipients);
  final List<TrustedContactModel> _trustedContacts =
      List.from(MockData.trustedContacts);
  TriggerModel _trigger = MockData.currentTrigger;
  final List<VaultItemModel> _vaultItems = List.from(MockData.vaultItems);

  int _idCounter = 100;
  String _nextId(String prefix) => '${prefix}_${++_idCounter}';

  // ── Messages ──

  @override
  Future<List<MessageModel>> getMessages(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages.where((m) => m.userId == userId).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<MessageModel?> getMessage(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _messages.firstWhere((m) => m.id == messageId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MessageModel> createMessage(MessageModel message) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newMessage = message.copyWith(
      id: _nextId('msg'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _messages.add(newMessage);
    return newMessage;
  }

  @override
  Future<MessageModel> updateMessage(MessageModel message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index == -1) throw Exception('Message not found');
    final updated = message.copyWith(updatedAt: DateTime.now());
    _messages[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _messages.removeWhere((m) => m.id == messageId);
  }

  // ── Recipients ──

  @override
  Future<List<RecipientModel>> getRecipients(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _recipients.where((r) => r.userId == userId).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<RecipientModel?> getRecipient(String recipientId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _recipients.firstWhere((r) => r.id == recipientId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RecipientModel> createRecipient(RecipientModel recipient) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newRecipient = recipient.copyWith(
      id: _nextId('rec'),
      createdAt: DateTime.now(),
    );
    _recipients.add(newRecipient);
    return newRecipient;
  }

  @override
  Future<RecipientModel> updateRecipient(RecipientModel recipient) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _recipients.indexWhere((r) => r.id == recipient.id);
    if (index == -1) throw Exception('Recipient not found');
    _recipients[index] = recipient;
    return recipient;
  }

  @override
  Future<void> deleteRecipient(String recipientId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _recipients.removeWhere((r) => r.id == recipientId);
  }

  // ── Trusted Contacts ──

  @override
  Future<List<TrustedContactModel>> getTrustedContacts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _trustedContacts.where((tc) => tc.userId == userId).toList();
  }

  @override
  Future<TrustedContactModel> createTrustedContact(
      TrustedContactModel contact) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newContact = contact.copyWith(
      id: _nextId('tc'),
      invitedAt: DateTime.now(),
    );
    _trustedContacts.add(newContact);
    return newContact;
  }

  @override
  Future<TrustedContactModel> updateTrustedContact(
      TrustedContactModel contact) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _trustedContacts.indexWhere((tc) => tc.id == contact.id);
    if (index == -1) throw Exception('Trusted contact not found');
    _trustedContacts[index] = contact;
    return contact;
  }

  @override
  Future<void> deleteTrustedContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _trustedContacts.removeWhere((tc) => tc.id == contactId);
  }

  // ── Triggers ──

  @override
  Future<TriggerModel?> getActiveTrigger(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _trigger.userId == userId ? _trigger : null;
  }

  @override
  Future<TriggerModel> updateTrigger(TriggerModel trigger) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _trigger = trigger;
    return trigger;
  }

  // ── Vault ──

  @override
  Future<List<VaultItemModel>> getVaultItems(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _vaultItems.where((v) => v.userId == userId).toList();
  }

  @override
  Future<VaultItemModel> createVaultItem(VaultItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newItem = item.copyWith(
      id: _nextId('vault'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _vaultItems.add(newItem);
    return newItem;
  }

  @override
  Future<VaultItemModel> updateVaultItem(VaultItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _vaultItems.indexWhere((v) => v.id == item.id);
    if (index == -1) throw Exception('Vault item not found');
    final updated = item.copyWith(updatedAt: DateTime.now());
    _vaultItems[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteVaultItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _vaultItems.removeWhere((v) => v.id == itemId);
  }
}
