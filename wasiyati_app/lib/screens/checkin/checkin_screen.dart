import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/trigger_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/messages_provider.dart';
import '../../providers/vault_provider.dart';
import '../../widgets/common/wasiyati_card.dart';
import '../../config/translations.dart';

/// Check-in screen — "Are you still with us?"
class CheckinScreen extends ConsumerWidget {
  final VoidCallback onConfirm;
  final VoidCallback onRemindLater;

  const CheckinScreen({
    super.key,
    required this.onConfirm,
    required this.onRemindLater,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(translationsProvider);
    final triggerState = ref.watch(triggerProvider);
    final trigger = triggerState.valueOrNull ??
        TriggerModel(
          id: 'default',
          userId: '',
          status: TriggerStatus.watching,
          checkInDeadline: DateTime.now().add(const Duration(days: 6)),
        );

    final contacts = ref.watch(trustedContactsProvider).valueOrNull ?? [];
    final trustedContact = contacts.isNotEmpty ? contacts.first : null;
    final messagesCount = ref.watch(messagesProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                s.get('checkin'),
                style: WasiyatiTypography.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                s.get('let_us_know_alright'),
                style: WasiyatiTypography.bodySmall,
              ),
              const SizedBox(height: 20),

              // Main check-in card
              WasiyatiCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const Text('🌙', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      s.get('are_you_still_with_us'),
                      style: WasiyatiTypography.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      s.get('checkin_desc'),
                      style: WasiyatiTypography.bodyMedium.copyWith(
                        color: WasiyatiColors.muted,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Timer ring
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: WasiyatiColors.softAmber.withValues(alpha: 0.2),
                          width: 4,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated progress arc
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: trigger.daysRemaining / 7.0,
                              strokeWidth: 4,
                              color: WasiyatiColors.softAmber,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Text(
                            '${trigger.daysRemaining > 7 ? 6 : (trigger.daysRemaining < 0 ? 0 : trigger.daysRemaining)} ${s.get('days_left')}',
                            style: WasiyatiTypography.bodySmall.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7DB87D), Color(0xFF5A9E5A)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5A9E5A).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            await ref.read(authStateProvider.notifier).checkIn();
                            onConfirm();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              '✓  ${s.get('yes_im_alright')}',
                              style: TextStyle(
                                fontFamily: WasiyatiTypography.bodyFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: onRemindLater,
                      child: Text(
                        s.get('remind_tomorrow'),
                        style: WasiyatiTypography.bodySmall.copyWith(
                          color: WasiyatiColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Trusted contact card
              if (trustedContact != null)
                WasiyatiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: WasiyatiColors.primaryGradient,
                            ),
                            child: Center(
                              child: Text(
                                trustedContact.name.isNotEmpty ? trustedContact.name[0] : 'C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${trustedContact.name} (Trusted Contact)',
                                  style: WasiyatiTypography.labelMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${trustedContact.relationship} · Will be notified if no response',
                                  style: WasiyatiTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: WasiyatiColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'If you don\'t respond within 7 days, ${trustedContact.name} will receive a notification to confirm your status.',
                          style: WasiyatiTypography.caption.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                WasiyatiCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('🤝', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          'No Trusted Contact Added',
                          style: WasiyatiTypography.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add a trusted contact in Settings to confirm your status if you are unreachable.',
                          style: WasiyatiTypography.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: WasiyatiCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('📬', style: TextStyle(fontSize: 22)),
                          const SizedBox(height: 6),
                          Text(
                            '$messagesCount',
                            style: WasiyatiTypography.headlineLarge
                                .copyWith(fontSize: 22),
                          ),
                          Text('Messages ready',
                              style: WasiyatiTypography.caption),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WasiyatiCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('🛡️', style: TextStyle(fontSize: 22)),
                          const SizedBox(height: 6),
                          Text(
                            'AES',
                            style: WasiyatiTypography.headlineLarge
                                .copyWith(fontSize: 22),
                          ),
                          Text('256-bit encrypted',
                              style: WasiyatiTypography.caption),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
