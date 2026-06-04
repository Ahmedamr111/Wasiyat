import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/recipient_model.dart';
import '../../providers/messages_provider.dart';

/// Recipient Profile — shows all messages assigned + contact info
class RecipientProfileScreen extends ConsumerWidget {
  final RecipientModel recipient;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const RecipientProfileScreen({
    super.key,
    required this.recipient,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(messagesProvider).valueOrNull ?? [];
    final messages = messagesList
        .where((m) =>
            m.recipients.any((r) => r.recipientId == recipient.id))
        .toList();

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: WasiyatiColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: onBack,
              color: WasiyatiColors.charcoal,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: onEdit,
                color: WasiyatiColors.charcoal,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: WasiyatiColors.headerGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: WasiyatiColors.primaryGradient,
                      ),
                      child: Center(
                        child: Text(
                          recipient.initials,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(recipient.name,
                        style: WasiyatiTypography.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      recipient.relationship,
                      style: WasiyatiTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact channels
                  Text('CONTACT CHANNELS', style: WasiyatiTypography.overline),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                      border: Border.all(color: WasiyatiColors.cardBorder),
                      boxShadow: WasiyatiColors.cardShadow,
                    ),
                    child: Builder(
                      builder: (context) {
                        String cleanPhone(String phone) {
                          return phone.replaceAll(RegExp(r'[^0-9]'), '');
                        }

                        Future<void> launchChannel(String channel, String value) async {
                          final text = messages.isNotEmpty 
                              ? (messages.first.contentPlain ?? 'This is a secure legacy message left for you.')
                              : 'This is a secure test of my legacy message on Wasiyati (وصيتي) — Leave your words behind. Forever.';
                          final title = messages.isNotEmpty ? messages.first.title : 'A Legacy Message';
                          
                          Uri? uri;
                          if (channel == 'whatsapp') {
                            final clean = cleanPhone(value);
                            uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(text)}');
                          } else if (channel == 'sms') {
                            uri = Uri.parse('sms:$value?body=${Uri.encodeComponent(text)}');
                          } else if (channel == 'email') {
                            uri = Uri.parse('mailto:$value?subject=${Uri.encodeComponent(title)}&body=${Uri.encodeComponent(text)}');
                          }

                          if (uri != null) {
                            try {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not launch ${channel.toUpperCase()}: $e')),
                              );
                            }
                          }
                        }

                        return Column(
                          children: [
                            if (recipient.email != null)
                              _ChannelRow(
                                icon: '📧',
                                label: 'Email',
                                value: recipient.email!,
                                onTap: () => launchChannel('email', recipient.email!),
                              ),
                            if (recipient.email != null &&
                                (recipient.whatsapp != null ||
                                    recipient.phone != null))
                              Divider(color: WasiyatiColors.divider, height: 1),
                            if (recipient.whatsapp != null)
                              _ChannelRow(
                                icon: '💬',
                                label: 'WhatsApp',
                                value: recipient.whatsapp!,
                                onTap: () => launchChannel('whatsapp', recipient.whatsapp!),
                              ),
                            if (recipient.whatsapp != null && recipient.phone != null)
                              Divider(color: WasiyatiColors.divider, height: 1),
                            if (recipient.phone != null)
                              _ChannelRow(
                                icon: '📱',
                                label: 'Phone',
                                value: recipient.phone!,
                                onTap: () => launchChannel('sms', recipient.phone!),
                              ),
                            if (recipient.email == null &&
                                recipient.whatsapp == null &&
                                recipient.phone == null)
                              const Text('No contact channels added yet'),
                          ],
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Language preference
                  Text('PREFERRED LANGUAGE', style: WasiyatiTypography.overline),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                      border: Border.all(color: WasiyatiColors.cardBorder),
                      boxShadow: WasiyatiColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Text('🌍', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(
                          _languageName(recipient.language),
                          style: WasiyatiTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Assigned messages
                  Row(
                    children: [
                      Text('ASSIGNED MESSAGES',
                          style: WasiyatiTypography.overline),
                      const Spacer(),
                      Text(
                        '${messages.length}',
                        style: WasiyatiTypography.labelSmall.copyWith(
                          color: WasiyatiColors.deepRose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (messages.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                        border: Border.all(color: WasiyatiColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          const Text('📭',
                              style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 8),
                          Text(
                            'No messages assigned yet',
                            style: WasiyatiTypography.bodyMedium.copyWith(
                              color: WasiyatiColors.warmTaupe,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...messages.map((msg) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: WasiyatiColors.softAmber
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(WasiyatiRadius.md),
                                ),
                                child: Center(
                                  child: Text(
                                    _typeIcon(msg.type.name),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(msg.title,
                                        style: WasiyatiTypography.labelMedium),
                                    const SizedBox(height: 2),
                                    Text(
                                      msg.typeLabel,
                                      style: WasiyatiTypography.caption,
                                    ),
                                  ],
                                ),
                              ),
                              if (msg.isPinLocked)
                                const Icon(
                                  Icons.lock_rounded,
                                  size: 16,
                                  color: WasiyatiColors.muted,
                                ),
                            ],
                          ),
                        )),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _languageName(String code) {
    const map = {
      'en': '🇬🇧 English',
      'ar': '🇸🇦 العربية',
      'fr': '🇫🇷 Français',
      'tr': '🇹🇷 Türkçe',
      'ur': '🇵🇰 اردو',
    };
    return map[code] ?? code;
  }

  String _typeIcon(String type) {
    const icons = {
      'immediate': '⚡',
      'recurring': '🔁',
      'occasion': '🎂',
      'milestone': '🎯',
    };
    return icons[type] ?? '📝';
  }
}

class _ChannelRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ChannelRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: WasiyatiTypography.caption),
                  Text(value, style: WasiyatiTypography.bodyMedium),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.send_rounded,
                size: 18,
                color: WasiyatiColors.deepRose,
              ),
          ],
        ),
      ),
    );
  }
}
