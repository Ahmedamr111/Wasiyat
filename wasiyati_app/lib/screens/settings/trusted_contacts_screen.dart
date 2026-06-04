import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/trusted_contact_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vault_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';
import '../trusted_contact/tc_screens.dart';

/// Trusted Contacts management screen
class TrustedContactsScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const TrustedContactsScreen({super.key, required this.onBack});

  @override
  ConsumerState<TrustedContactsScreen> createState() =>
      _TrustedContactsScreenState();
}

class _TrustedContactsScreenState
    extends ConsumerState<TrustedContactsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _showAddForm = false;
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvitation() async {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isSending = true);
    try {
      final contact = TrustedContactModel(
        id: '',
        userId: user.id,
        name: _nameController.text.trim(),
        externalEmail: _emailController.text.trim(),
        status: TrustedContactStatus.invited,
        invitedAt: DateTime.now(),
      );

      await ref.read(trustedContactsProvider.notifier).addContact(contact);

      if (mounted) {
        setState(() {
          _isSending = false;
          _showAddForm = false;
          _nameController.clear();
          _emailController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✉️ Invitation sent successfully!'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send invitation: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts =
        ref.watch(trustedContactsProvider).valueOrNull ?? [];
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
        title:
            Text('Trusted Contacts', style: WasiyatiTypography.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // What are trusted contacts?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WasiyatiColors.softAmber.withValues(alpha: 0.1),
                    WasiyatiColors.deepRose.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🤝 What are Trusted Contacts?',
                      style: WasiyatiTypography.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Your trusted contacts are the people who can confirm your passing to Wasiyati. Once confirmed, your messages will be delivered to your loved ones.\n\nFree plan: 1 contact · Premium: 2 contacts',
                    style: WasiyatiTypography.bodySmall.copyWith(
                      color: WasiyatiColors.warmTaupe,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current contacts
            Row(
              children: [
                Text('YOUR CONTACTS', style: WasiyatiTypography.overline),
                const Spacer(),
                Text(
                  '${contacts.length}/1',
                  style: WasiyatiTypography.labelSmall.copyWith(
                    color: WasiyatiColors.deepRose,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...contacts.map((contact) => _TrustedContactCard(
                  contact: contact,
                  owner: ref.watch(currentUserProvider),
                  onRevoke: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Remove Trusted Contact?'),
                        content: Text(
                            'This will remove ${contact.name} as your trusted contact.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Removing contact...')),
                                );
                                await ref.read(trustedContactsProvider.notifier).removeContact(contact.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✓ Trusted contact removed.'),
                                      backgroundColor: WasiyatiColors.success,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: WasiyatiColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Remove',
                                style: TextStyle(color: WasiyatiColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                )),

            // Add button
            if (contacts.isEmpty || true) ...[
              const SizedBox(height: 16),
              if (!_showAddForm)
                GestureDetector(
                  onTap: () => setState(() => _showAddForm = true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                      border: Border.all(
                        color: WasiyatiColors.softAmber.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: WasiyatiColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.add_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Invite a Trusted Contact',
                          style: WasiyatiTypography.labelMedium.copyWith(
                            color: WasiyatiColors.deepRose,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],

            // Add form
            if (_showAddForm) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                  border: Border.all(color: WasiyatiColors.softAmber),
                  boxShadow: WasiyatiColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invite Trusted Contact',
                        style: WasiyatiTypography.labelLarge),
                    const SizedBox(height: 6),
                    Text(
                      'They will receive an invitation email explaining their role.',
                      style: WasiyatiTypography.caption,
                    ),
                    const SizedBox(height: 16),
                    WasiyatiInput(
                      label: 'Full Name',
                      hint: 'Mohamed',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    WasiyatiInput(
                      label: 'Email Address',
                      hint: 'mohamed@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: WasiyatiButton(
                            label: 'Send Invite',
                            onPressed: _sendInvitation,
                            isLoading: _isSending,
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
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _TrustedContactCard extends StatelessWidget {
  final TrustedContactModel contact;
  final UserModel? owner;
  final VoidCallback onRevoke;

  const _TrustedContactCard({
    required this.contact,
    this.owner,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepted = contact.status == TrustedContactStatus.accepted;
    final isNonUser = contact.contactUserId == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
        border: Border.all(color: WasiyatiColors.cardBorder),
        boxShadow: WasiyatiColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isAccepted
                      ? WasiyatiColors.primaryGradient
                      : const LinearGradient(
                          colors: [Color(0xFFB8A99A), Color(0xFF8B7355)]),
                ),
                child: Center(
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0] : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: WasiyatiTypography.labelMedium),
                    const SizedBox(height: 3),
                    Text(
                      contact.externalEmail ?? '',
                      style: WasiyatiTypography.caption,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isAccepted
                            ? WasiyatiColors.success.withValues(alpha: 0.12)
                            : WasiyatiColors.goldenHour.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAccepted ? '✓ Accepted' : '⏳ Pending',
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isAccepted
                              ? WasiyatiColors.success
                              : const Color(0xFFB8860B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRevoke,
                child: const Icon(Icons.more_vert_rounded,
                    color: WasiyatiColors.muted, size: 20),
              ),
            ],
          ),
          if (isNonUser && owner != null) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: WasiyatiColors.divider),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WhatsAppBotSimulatorScreen(
                          ownerId: owner!.id,
                          ownerName: owner!.name,
                          contactName: contact.name,
                          contactId: contact.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💬', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          'Simulate WhatsApp Bot',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF128C7E),
                            fontFamily: WasiyatiTypography.bodyFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
