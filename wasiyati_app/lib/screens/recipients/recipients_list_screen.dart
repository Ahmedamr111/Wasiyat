import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/recipients_provider.dart';
import '../../providers/messages_provider.dart';
import 'add_edit_recipient_screen.dart';
import 'recipient_profile_screen.dart';

/// Recipients list screen
class RecipientsListScreen extends ConsumerWidget {
  const RecipientsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipientsState = ref.watch(recipientsProvider);

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text('People',
                        style: WasiyatiTypography.displaySmall),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditRecipientScreen(
                          onBack: () => Navigator.pop(context),
                          onSaved: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: WasiyatiColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+ Add',
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: recipientsState.when(
                data: (recipients) {
                  if (recipients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👥', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'No recipients yet',
                            style: WasiyatiTypography.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add trusted people to receive your messages.',
                            style: WasiyatiTypography.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: recipients.length,
                    itemBuilder: (context, index) {
                      final r = recipients[index];
                      // Count messages for this recipient
                      final messages = ref.watch(messagesProvider).valueOrNull ?? [];
                      final msgCount = messages
                          .where((m) => m.recipients
                              .any((rec) => rec.recipientId == r.id))
                          .length;

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipientProfileScreen(
                              recipient: r,
                              onBack: () => Navigator.pop(context),
                              onEdit: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditRecipientScreen(
                                    recipient: r,
                                    onBack: () => Navigator.pop(context),
                                    onSaved: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(WasiyatiRadius.xl),
                            border: Border.all(color: WasiyatiColors.cardBorder),
                            boxShadow: WasiyatiColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: WasiyatiColors.primaryGradient,
                                ),
                                child: Center(
                                  child: Text(
                                    r.initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: WasiyatiTypography.labelMedium,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${r.relationship} · $msgCount messages',
                                      style: WasiyatiTypography.caption,
                                    ),
                                  ],
                                ),
                              ),
                              // Channels
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (r.email != null)
                                    _ChannelDot(label: '📧'),
                                  if (r.phone != null)
                                    _ChannelDot(label: '📱'),
                                  if (r.whatsapp != null)
                                    _ChannelDot(label: '💬'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: WasiyatiColors.softAmber),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Error loading recipients: $error',
                      style: const TextStyle(color: WasiyatiColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelDot extends StatelessWidget {
  final String label;
  const _ChannelDot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
