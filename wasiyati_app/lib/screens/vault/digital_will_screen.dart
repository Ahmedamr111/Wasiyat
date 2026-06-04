import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/vault_item_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vault_provider.dart';
import '../../widgets/common/wasiyati_button.dart';

/// Digital Will editor screen — Premium
class DigitalWillScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const DigitalWillScreen({super.key, required this.onBack});

  @override
  ConsumerState<DigitalWillScreen> createState() => _DigitalWillScreenState();
}

class _DigitalWillScreenState extends ConsumerState<DigitalWillScreen> {
  final _contentController = TextEditingController();
  bool _isSaving = false;
  bool _hasChanges = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() => setState(() => _hasChanges = true));
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save(VaultItemModel? existingItem) async {
    setState(() => _isSaving = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Not signed in');

      final content = _contentController.text.trim();

      if (existingItem != null) {
        final updated = existingItem.copyWith(
          contentPlain: content,
          updatedAt: DateTime.now(),
        );
        await ref.read(vaultProvider.notifier).updateItem(updated);
      } else {
        final newItem = VaultItemModel(
          id: '',
          userId: user.id,
          type: VaultItemType.digitalWill,
          title: 'Digital Will',
          contentPlain: content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(vaultProvider.notifier).createItem(newItem);
      }

      if (mounted) {
        setState(() {
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📜 Your will has been saved securely'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving will: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaultState = ref.watch(vaultProvider);
    final vaultItems = vaultState.valueOrNull ?? [];

    final existingItem = vaultItems
        .where((v) => v.type == VaultItemType.digitalWill)
        .firstOrNull;

    // Initialize controller only once from Firestore when stream yields data
    if (!_isInitialized && existingItem != null) {
      _contentController.text = existingItem.contentPlain ?? '';
      _isInitialized = true;
      _hasChanges = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5), // parchment
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: widget.onBack,
          color: WasiyatiColors.charcoal,
        ),
        title: Text(
          '📜 Digital Will',
          style: WasiyatiTypography.headlineSmall,
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : () => _save(existingItem),
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: WasiyatiColors.deepRose,
                        fontFamily: WasiyatiTypography.bodyFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: vaultState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => Column(
          children: [
            // Info banner
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: WasiyatiColors.goldenHour.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                border: Border.all(
                    color: WasiyatiColors.goldenHour.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is securely encrypted. Only your Trusted Contacts can access it after your passing.',
                      style: WasiyatiTypography.bodySmall.copyWith(
                        color: WasiyatiColors.warmTaupe,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAF5),
                    borderRadius: BorderRadius.circular(WasiyatiRadius.lg),
                  ),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    style: WasiyatiTypography.editorContent,
                    decoration: InputDecoration(
                      hintText:
                          'Write your wishes here...\n\nYou can include how you want your assets distributed, who to contact, your final wishes, and anything else important to you.',
                      hintStyle: WasiyatiTypography.editorPlaceholder,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom actions
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: WasiyatiButton(
                  label: _hasChanges ? 'Save Will' : 'Saved ✓',
                  onPressed: _hasChanges ? () => _save(existingItem) : null,
                  isLoading: _isSaving,
                  fullWidth: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
