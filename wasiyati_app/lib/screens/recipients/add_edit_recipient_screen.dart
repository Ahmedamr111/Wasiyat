import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/recipient_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/recipients_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';

/// Add or Edit a Recipient
class AddEditRecipientScreen extends ConsumerStatefulWidget {
  final RecipientModel? recipient; // null = add new
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const AddEditRecipientScreen({
    super.key,
    this.recipient,
    required this.onBack,
    required this.onSaved,
  });

  @override
  ConsumerState<AddEditRecipientScreen> createState() => _AddEditRecipientScreenState();
}

class _AddEditRecipientScreenState extends ConsumerState<AddEditRecipientScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _selectedRelationship = 'Spouse';
  String _selectedLanguage = 'en';
  bool _isSaving = false;

  static const _relationships = [
    'Spouse', 'Partner', 'Son', 'Daughter', 'Father', 'Mother',
    'Brother', 'Sister', 'Grandfather', 'Grandmother', 'Friend',
    'Colleague', 'Lawyer', 'Other',
  ];

  static const _languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'tr': 'Türkçe',
    'ur': 'اردو',
  };

  @override
  void initState() {
    super.initState();
    if (widget.recipient != null) {
      final r = widget.recipient!;
      _nameController.text = r.name;
      _emailController.text = r.email ?? '';
      _phoneController.text = r.phone ?? '';
      _whatsappController.text = r.whatsapp ?? '';
      _selectedRelationship = r.relationship;
      _selectedLanguage = r.language;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save recipients')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final recipient = RecipientModel(
        id: widget.recipient?.id ?? '',
        userId: user.id,
        name: _nameController.text.trim(),
        relationship: _selectedRelationship,
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        whatsapp: _whatsappController.text.trim().isEmpty ? null : _whatsappController.text.trim(),
        language: _selectedLanguage,
        createdAt: widget.recipient?.createdAt ?? DateTime.now(),
      );

      if (widget.recipient == null) {
        await ref.read(recipientsProvider.notifier).createRecipient(recipient);
      } else {
        await ref.read(recipientsProvider.notifier).updateRecipient(recipient);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.recipient == null
                ? '${_nameController.text} added! 🎉'
                : 'Changes saved!'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipient != null;

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
        title: Text(
          isEditing ? 'Edit Recipient' : 'Add Recipient',
          style: WasiyatiTypography.headlineSmall,
        ),
        actions: isEditing
            ? [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Remove Recipient?'),
                        content: Text(
                          'Are you sure you want to remove ${widget.recipient!.name}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Removing recipient...')),
                                );
                                if (widget.recipient != null) {
                                  await ref
                                      .read(recipientsProvider.notifier)
                                      .deleteRecipient(widget.recipient!.id);
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✓ Recipient removed successfully'),
                                      backgroundColor: WasiyatiColors.success,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: WasiyatiColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: WasiyatiColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: WasiyatiColors.error,
                      fontFamily: WasiyatiTypography.bodyFont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: WasiyatiColors.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Change Photo',
                  style: WasiyatiTypography.bodySmall.copyWith(
                    color: WasiyatiColors.deepRose,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            WasiyatiInput(
              label: 'Full Name *',
              hint: 'e.g. Sara Ahmed',
              controller: _nameController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Relationship
            Text('RELATIONSHIP', style: WasiyatiTypography.overline),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: WasiyatiColors.inputBorder, width: 2),
                ),
              ),
              child: DropdownButton<String>(
                value: _selectedRelationship,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                style: WasiyatiTypography.bodyLarge.copyWith(
                  color: WasiyatiColors.charcoal,
                ),
                items: _relationships
                    .map((rel) => DropdownMenuItem(
                          value: rel,
                          child: Text(rel),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRelationship = val);
                },
              ),
            ),
            const SizedBox(height: 32),

            // Contact channels
            Text('CONTACT CHANNELS', style: WasiyatiTypography.overline),
            const SizedBox(height: 4),
            Text(
              'Add at least one channel to deliver messages',
              style: WasiyatiTypography.bodySmall,
            ),
            const SizedBox(height: 16),

            WasiyatiInput(
              label: 'Email',
              hint: 'sara@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefix: const Text('📧 ',
                  style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),

            WasiyatiInput(
              label: 'WhatsApp Number',
              hint: '+966 50 xxx xxxx',
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              prefix: const Text('💬 ',
                  style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),

            WasiyatiInput(
              label: 'Phone (SMS)',
              hint: '+966 50 xxx xxxx',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefix: const Text('📱 ',
                  style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),

            // Language preference
            Text('PREFERRED LANGUAGE', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _languages.entries.map((entry) {
                final isSelected = _selectedLanguage == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedLanguage = entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected ? WasiyatiColors.primaryGradient : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                      border: isSelected
                          ? null
                          : Border.all(color: WasiyatiColors.cardBorder),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontFamily: WasiyatiTypography.bodyFont,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : WasiyatiColors.warmTaupe,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            WasiyatiButton(
              label: isEditing ? 'Save Changes' : 'Add Recipient',
              onPressed: _save,
              isLoading: _isSaving,
              fullWidth: true,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
