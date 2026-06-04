import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';
import '../models/recipient_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/trigger_model.dart';
import '../models/vault_item_model.dart';
import 'database_service.dart';

/// Firestore implementation of [DatabaseService]
///
/// All data is scoped under: users/{userId}/collection/{docId}
class FirestoreDatabaseService implements DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Collection refs ───────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _messages(String userId) =>
      _db.collection('users').doc(userId).collection('messages');

  CollectionReference<Map<String, dynamic>> _recipients(String userId) =>
      _db.collection('users').doc(userId).collection('recipients');

  CollectionReference<Map<String, dynamic>> _trustedContacts(String userId) =>
      _db.collection('users').doc(userId).collection('trustedContacts');

  CollectionReference<Map<String, dynamic>> _vaultItems(String userId) =>
      _db.collection('users').doc(userId).collection('vaultItems');

  DocumentReference<Map<String, dynamic>> _trigger(String userId) =>
      _db.collection('users').doc(userId).collection('settings').doc('trigger');

  // ── Real-time Streams ─────────────────────────────────────────────────────

  /// Real-time stream of messages — used by Riverpod StreamProvider
  Stream<List<MessageModel>> messagesStream(String userId) {
    return _messages(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MessageModel.fromJson({...d.data(), 'id': d.id}))
            .toList());
  }

  /// Real-time stream of recipients
  Stream<List<RecipientModel>> recipientsStream(String userId) {
    return _recipients(userId)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RecipientModel.fromJson({...d.data(), 'id': d.id}))
            .toList());
  }

  /// Real-time stream of vault items
  Stream<List<VaultItemModel>> vaultItemsStream(String userId) {
    return _vaultItems(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => VaultItemModel.fromJson({...d.data(), 'id': d.id}))
            .toList());
  }

  /// Real-time stream of trusted contacts
  Stream<List<TrustedContactModel>> trustedContactsStream(String userId) {
    return _trustedContacts(userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => TrustedContactModel.fromJson({...d.data(), 'id': d.id}))
            .toList());
  }

  /// Real-time stream of the active trigger
  Stream<TriggerModel?> triggerStream(String userId) {
    return _trigger(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return TriggerModel.fromJson({...doc.data()!, 'id': doc.id, 'userId': userId});
    });
  }

  // ── Messages ──────────────────────────────────────────────────────────────

  @override
  Future<List<MessageModel>> getMessages(String userId) async {
    final snap = await _messages(userId)
        .orderBy('updatedAt', descending: true)
        .get();
    return snap.docs
        .map((d) => MessageModel.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<MessageModel?> getMessage(String messageId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _messages(uid).doc(messageId).get();
    if (!doc.exists || doc.data() == null) return null;
    return MessageModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<MessageModel> createMessage(MessageModel message) async {
    final data = message.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data.remove('id');

    final ref = await _messages(message.userId).add(data);
    return message.copyWith(id: ref.id, createdAt: DateTime.now(), updatedAt: DateTime.now());
  }

  @override
  Future<MessageModel> updateMessage(MessageModel message) async {
    final data = message.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data.remove('id');

    await _messages(message.userId).doc(message.id).update(data);
    return message.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _messages(uid).doc(messageId).delete();
    }
  }

  // ── Recipients ────────────────────────────────────────────────────────────

  @override
  Future<List<RecipientModel>> getRecipients(String userId) async {
    final snap = await _recipients(userId).orderBy('name').get();
    return snap.docs
        .map((d) => RecipientModel.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<RecipientModel?> getRecipient(String recipientId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _recipients(uid).doc(recipientId).get();
    if (!doc.exists || doc.data() == null) return null;
    return RecipientModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<RecipientModel> createRecipient(RecipientModel recipient) async {
    final data = recipient.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    data.remove('id');

    final ref = await _recipients(recipient.userId).add(data);
    return recipient.copyWith(id: ref.id);
  }

  @override
  Future<RecipientModel> updateRecipient(RecipientModel recipient) async {
    final data = recipient.toJson();
    data.remove('id');
    await _recipients(recipient.userId).doc(recipient.id).update(data);
    return recipient;
  }

  @override
  Future<void> deleteRecipient(String recipientId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _recipients(uid).doc(recipientId).delete();
    }
  }

  // ── Trusted Contacts ──────────────────────────────────────────────────────

  @override
  Future<List<TrustedContactModel>> getTrustedContacts(String userId) async {
    final snap = await _trustedContacts(userId).get();
    return snap.docs
        .map((d) => TrustedContactModel.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<TrustedContactModel> createTrustedContact(
      TrustedContactModel contact) async {
    final data = contact.toJson();
    data['invitedAt'] = FieldValue.serverTimestamp();
    data.remove('id');

    final ref = await _trustedContacts(contact.userId).add(data);
    return contact.copyWith(id: ref.id);
  }

  @override
  Future<TrustedContactModel> updateTrustedContact(
      TrustedContactModel contact) async {
    final data = contact.toJson();
    data.remove('id');
    await _trustedContacts(contact.userId).doc(contact.id).update(data);
    return contact;
  }

  @override
  Future<void> deleteTrustedContact(String contactId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _trustedContacts(uid).doc(contactId).delete();
    }
  }

  // ── Trigger ───────────────────────────────────────────────────────────────

  @override
  Future<TriggerModel?> getActiveTrigger(String userId) async {
    final doc = await _trigger(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return TriggerModel.fromJson({...doc.data()!, 'id': doc.id, 'userId': userId});
  }

  @override
  Future<TriggerModel> updateTrigger(TriggerModel trigger) async {
    final data = trigger.toJson();
    data.remove('id');
    await _trigger(trigger.userId).set(data, SetOptions(merge: true));
    return trigger;
  }

  // ── Vault Items ───────────────────────────────────────────────────────────

  @override
  Future<List<VaultItemModel>> getVaultItems(String userId) async {
    final snap = await _vaultItems(userId)
        .orderBy('updatedAt', descending: true)
        .get();
    return snap.docs
        .map((d) => VaultItemModel.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<VaultItemModel> createVaultItem(VaultItemModel item) async {
    final data = item.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data.remove('id');

    final ref = await _vaultItems(item.userId).add(data);
    return item.copyWith(id: ref.id, createdAt: DateTime.now(), updatedAt: DateTime.now());
  }

  @override
  Future<VaultItemModel> updateVaultItem(VaultItemModel item) async {
    final data = item.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    data.remove('id');
    await _vaultItems(item.userId).doc(item.id).update(data);
    return item.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteVaultItem(String itemId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _vaultItems(uid).doc(itemId).delete();
    }
  }
}
