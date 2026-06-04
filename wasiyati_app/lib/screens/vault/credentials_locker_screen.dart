import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vault_provider.dart';
import '../../models/vault_item_model.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';

/// Credentials Locker — encrypted key-value pairs
class CredentialsLockerScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const CredentialsLockerScreen({super.key, required this.onBack});

  @override
  ConsumerState<CredentialsLockerScreen> createState() =>
      _CredentialsLockerScreenState();
}

class _CredentialsLockerScreenState extends ConsumerState<CredentialsLockerScreen> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  bool _showAddForm = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _addCredential(
      VaultItemModel? existingItem, List<MapEntry<String, String>> currentCredentials) async {
    if (_keyController.text.trim().isEmpty ||
        _valueController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final newKey = _keyController.text.trim();
      final newValue = _valueController.text.trim();

      final newMetadata = <String, String>{};
      for (final entry in currentCredentials) {
        newMetadata[entry.key] = entry.value;
      }
      newMetadata[newKey] = newValue;

      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Not signed in');

      if (existingItem != null) {
        final updated = existingItem.copyWith(
          metadata: newMetadata,
          updatedAt: DateTime.now(),
        );
        await ref.read(vaultProvider.notifier).updateItem(updated);
      } else {
        final newItem = VaultItemModel(
          id: '',
          userId: user.id,
          type: VaultItemType.credentials,
          title: 'Credentials Locker',
          metadata: newMetadata,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(vaultProvider.notifier).createItem(newItem);
      }

      _keyController.clear();
      _valueController.clear();
      setState(() {
        _showAddForm = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔐 Credential saved securely'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving credential: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteCredential(
      VaultItemModel existingItem, String keyToDelete, List<MapEntry<String, String>> currentCredentials) async {
    try {
      final newMetadata = <String, String>{};
      for (final entry in currentCredentials) {
        if (entry.key != keyToDelete) {
          newMetadata[entry.key] = entry.value;
        }
      }

      final updated = existingItem.copyWith(
        metadata: newMetadata,
        updatedAt: DateTime.now(),
      );
      await ref.read(vaultProvider.notifier).updateItem(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Credential deleted'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting credential: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaultState = ref.watch(vaultProvider);
    final vaultItems = vaultState.valueOrNull ?? [];

    final credentialsItem = vaultItems
        .where((v) => v.type == VaultItemType.credentials)
        .firstOrNull;

    final credentials = (credentialsItem?.metadata ?? {})
        .entries
        .map((e) => MapEntry(e.key, e.value.toString()))
        .toList();

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        backgroundColor: WasiyatiColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: widget.onBack,
          color: WasiyatiColors.charcoal,
        ),
        title: Text('🔐 Credentials Locker',
            style: WasiyatiTypography.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () => setState(() => _showAddForm = !_showAddForm),
            color: WasiyatiColors.deepRose,
          ),
        ],
      ),
      body: vaultState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WasiyatiColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                  border: Border.all(
                      color: WasiyatiColors.error.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All credentials are AES-256 encrypted. They will only be accessible to your Trusted Contacts after your passing is confirmed.',
                        style: WasiyatiTypography.bodySmall.copyWith(
                          color: WasiyatiColors.warmTaupe,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Add form
              if (_showAddForm)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                    border: Border.all(color: WasiyatiColors.softAmber),
                    boxShadow: WasiyatiColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add New Credential',
                          style: WasiyatiTypography.labelLarge),
                      const SizedBox(height: 16),
                      WasiyatiInput(
                        label: 'Label',
                        hint: 'e.g. Bank Account, Email Password',
                        controller: _keyController,
                      ),
                      const SizedBox(height: 16),
                      WasiyatiInput(
                        label: 'Value / Note',
                        hint: 'e.g. Account number, Instructions',
                        controller: _valueController,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: WasiyatiButton(
                              label: 'Save',
                              isLoading: _isSaving,
                              onPressed: () => _addCredential(credentialsItem, credentials),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: WasiyatiButton(
                              label: 'Cancel',
                              isOutlined: true,
                              onPressed: () =>
                                  setState(() => _showAddForm = false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Credentials list
              Text('SAVED CREDENTIALS', style: WasiyatiTypography.overline),
              const SizedBox(height: 12),

              if (credentials.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                    border: Border.all(color: WasiyatiColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      const Text('🔓', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'No credentials yet',
                        style: WasiyatiTypography.bodyMedium.copyWith(
                          color: WasiyatiColors.warmTaupe,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap + to add passwords, accounts, and important info',
                        style: WasiyatiTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                    border: Border.all(color: WasiyatiColors.cardBorder),
                    boxShadow: WasiyatiColors.cardShadow,
                  ),
                  child: Column(
                    children: credentials.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cred = entry.value;
                      return Column(
                        children: [
                          _CredentialTile(
                            keyText: cred.key,
                            valueText: cred.value,
                            onDelete: () {
                              if (credentialsItem != null) {
                                _deleteCredential(credentialsItem, cred.key, credentials);
                              }
                            },
                          ),
                          if (index < credentials.length - 1)
                            Divider(
                                height: 1, color: WasiyatiColors.divider),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _CredentialTile extends StatefulWidget {
  final String keyText;
  final String valueText;
  final VoidCallback onDelete;

  const _CredentialTile({
    required this.keyText,
    required this.valueText,
    required this.onDelete,
  });

  @override
  State<_CredentialTile> createState() => _CredentialTileState();
}

class _CredentialTileState extends State<_CredentialTile> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WasiyatiColors.deepRose.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(WasiyatiRadius.md),
            ),
            child: const Center(
              child: Text('🔑', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.keyText, style: WasiyatiTypography.labelMedium),
                const SizedBox(height: 2),
                Text(
                  _revealed ? widget.valueText : '••••••••',
                  style: WasiyatiTypography.bodySmall,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _revealed = !_revealed),
            child: Icon(
              _revealed ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: WasiyatiColors.muted,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onDelete,
            child: const Icon(Icons.delete_outline_rounded,
                color: WasiyatiColors.muted, size: 18),
          ),
        ],
      ),
    );
  }
}
