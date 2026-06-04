import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../models/recipient_model.dart';
import '../../providers/recipients_provider.dart';
import '../../providers/messages_provider.dart';

/// Message detail — sealed, read-only preview of a composed message
class MessageDetailScreen extends ConsumerStatefulWidget {
  final MessageModel message;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDeleted;

  const MessageDetailScreen({
    super.key,
    required this.message,
    required this.onBack,
    required this.onEdit,
    required this.onDeleted,
  });

  @override
  ConsumerState<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sealController;
  late Animation<double> _sealScale;

  @override
  void initState() {
    super.initState();
    _sealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sealScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sealController, curve: Curves.elasticOut),
    );
    // Animate seal in after a brief delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _sealController.forward();
    });
  }

  @override
  void dispose() {
    _sealController.dispose();
    super.dispose();
  }

  String get _typeIcon {
    switch (widget.message.type) {
      case MessageType.immediate:
        return '✉️';
      case MessageType.recurring:
        return '🌿';
      case MessageType.occasion:
        return '🎂';
      case MessageType.milestone:
        return '🎓';
    }
  }

  Color get _typeColor {
    switch (widget.message.type) {
      case MessageType.immediate:
        return WasiyatiColors.deepRose;
      case MessageType.recurring:
        return WasiyatiColors.softAmber;
      case MessageType.occasion:
        return const Color(0xFFB8860B);
      case MessageType.milestone:
        return WasiyatiColors.warmTaupe;
    }
  }

  String get _scheduleLabel {
    final s = widget.message.schedule;
    if (s == null) return 'Upon delivery confirmation';
    if (s.occasionDate != null) {
      final d = s.occasionDate!;
      return 'On ${d.day}/${d.month}/${d.year}';
    }
    if (s.milestoneLabel != null) return s.milestoneLabel!;
    if (s.recurringType != null) {
      switch (s.recurringType!) {
        case RecurringType.weekly:
          return 'Every week';
        case RecurringType.monthly:
          return 'Every month';
        case RecurringType.yearly:
          return 'Every year';
      }
    }
    return 'Upon delivery';
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message?'),
        content: Text(
          '"${widget.message.title}" will be permanently deleted. This cannot be undone.',
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
                  const SnackBar(content: Text('Deleting message...')),
                );
                await ref.read(messagesProvider.notifier).deleteMessage(widget.message.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Message deleted successfully'),
                      backgroundColor: WasiyatiColors.success,
                    ),
                  );
                  Navigator.pop(context);
                  widget.onDeleted();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting message: $e'),
                      backgroundColor: WasiyatiColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: WasiyatiColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: WasiyatiColors.charcoal,
          onPressed: widget.onBack,
        ),
        title: Text('Message', style: WasiyatiTypography.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            color: WasiyatiColors.deepRose,
            onPressed: widget.onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: WasiyatiColors.error,
            onPressed: _showDeleteDialog,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge + status
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                    border: Border.all(
                        color: _typeColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_typeIcon,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        msg.typeLabel,
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (msg.isPinLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: WasiyatiColors.charcoal.withValues(alpha: 0.07),
                      borderRadius:
                          BorderRadius.circular(WasiyatiRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded,
                            size: 12, color: WasiyatiColors.muted),
                        const SizedBox(width: 4),
                        Text('PIN locked',
                            style: WasiyatiTypography.caption),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(msg.title, style: WasiyatiTypography.displaySmall),
            const SizedBox(height: 6),
            Text(
              'Created ${_formatDate(msg.createdAt)}',
              style: WasiyatiTypography.caption,
            ),
            const SizedBox(height: 24),

            // Parchment content
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 180),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: WasiyatiColors.parchmentGradient,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(
                  color: WasiyatiColors.softAmber.withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: WasiyatiColors.warmTaupe.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Content
                  Text(
                    msg.contentPlain ??
                        'This message has encrypted content.',
                    style: WasiyatiTypography.editorContent.copyWith(
                      height: 1.8,
                    ),
                  ),
                  // Wax seal stamp
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _sealController,
                      builder: (_, v) => Transform.scale(
                        scale: _sealScale.value,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0xFFC4736A),
                                Color(0xFF9B4F47)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9B4F47)
                                    .withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child:
                                Text('🕊️', style: TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Delivery schedule
            _InfoCard(
              icon: '⏰',
              title: 'Delivery Schedule',
              value: _scheduleLabel,
            ),
            const SizedBox(height: 12),

            // Recipients
            _RecipientsSummaryCard(message: msg),
            const SizedBox(height: 12),

            // Delivery status
            _DeliveryStatusCard(message: msg),
            const SizedBox(height: 32),

            // Edit button
            GestureDetector(
              onTap: widget.onEdit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: WasiyatiColors.primaryGradient,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  boxShadow: WasiyatiColors.buttonShadow,
                ),
                child: Center(
                  child: Text(
                    '✏️  Edit Message',
                    style: WasiyatiTypography.labelLarge
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showDeleteDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: WasiyatiColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  border: Border.all(
                      color: WasiyatiColors.error.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    '🗑️  Delete Message',
                    style: WasiyatiTypography.labelLarge
                        .copyWith(color: WasiyatiColors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m];
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
        border: Border.all(color: WasiyatiColors.cardBorder),
        boxShadow: WasiyatiColors.cardShadow,
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: WasiyatiTypography.caption),
                const SizedBox(height: 2),
                Text(value, style: WasiyatiTypography.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipientsSummaryCard extends ConsumerWidget {
  final MessageModel message;

  const _RecipientsSummaryCard({
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipients = ref.watch(recipientsProvider).valueOrNull ?? [];
    
    // Clean up the phone number (remove spaces, +, etc. for wa.me)
    String cleanPhone(String phone) {
      return phone.replaceAll(RegExp(r'[^0-9]'), '');
    }

    Future<void> launchChannel(RecipientModel recipient, String channel, String title, String content) async {
      String? contactValue;
      Uri? uri;

      if (channel == 'whatsapp') {
        contactValue = recipient.whatsapp;
        if (contactValue != null && contactValue.isNotEmpty) {
          final clean = cleanPhone(contactValue);
          uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(content)}');
        }
      } else if (channel == 'sms') {
        contactValue = recipient.phone;
        if (contactValue != null && contactValue.isNotEmpty) {
          uri = Uri.parse('sms:${recipient.phone}?body=${Uri.encodeComponent(content)}');
        }
      } else if (channel == 'email') {
        contactValue = recipient.email;
        if (contactValue != null && contactValue.isNotEmpty) {
          uri = Uri.parse('mailto:${recipient.email}?subject=${Uri.encodeComponent(title)}&body=${Uri.encodeComponent(content)}');
        }
      }

      if (uri != null) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch ${channel.toUpperCase()}: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No contact information found for ${channel.toUpperCase()}')),
        );
      }
    }

    return Container(
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
              const Text('👥', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
              Text(
                '${message.recipients.length} Recipient${message.recipients.length != 1 ? 's' : ''}',
                style: WasiyatiTypography.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (message.recipients.isEmpty)
            const Text('No recipients selected for this message.', style: TextStyle(fontStyle: FontStyle.italic))
          else
            ...message.recipients.map((mr) {
              final r = recipients.where((rec) => rec.id == mr.recipientId).firstOrNull;
              if (r == null) return const SizedBox.shrink();

              String channelIcon = '📧';
              if (mr.channel == 'whatsapp') channelIcon = '💬';
              if (mr.channel == 'sms') channelIcon = '📱';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: WasiyatiColors.primaryGradient,
                      ),
                      child: Center(
                        child: Text(
                          r.initials,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name, style: WasiyatiTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            'Channel: $channelIcon ${mr.channel.toUpperCase()}',
                            style: WasiyatiTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: WasiyatiColors.deepRose),
                      onPressed: () => launchChannel(
                        r, 
                        mr.channel, 
                        message.title, 
                        message.contentPlain ?? 'This is a secure legacy message left for you.'
                      ),
                      tooltip: 'Send Immediately via ${mr.channel.toUpperCase()}',
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _DeliveryStatusCard extends StatelessWidget {
  final MessageModel message;

  const _DeliveryStatusCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: message.isDelivered
            ? WasiyatiColors.success.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
        border: Border.all(
          color: message.isDelivered
              ? WasiyatiColors.success.withValues(alpha: 0.25)
              : WasiyatiColors.cardBorder,
        ),
        boxShadow: WasiyatiColors.cardShadow,
      ),
      child: Row(
        children: [
          Text(message.isDelivered ? '✅' : '🔒',
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isDelivered ? 'Delivered' : 'Sealed & Waiting',
                  style: WasiyatiTypography.labelMedium.copyWith(
                    color: message.isDelivered
                        ? WasiyatiColors.success
                        : WasiyatiColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.isDelivered
                      ? 'This message has been delivered to your recipients.'
                      : 'This message is encrypted and waiting for delivery.',
                  style: WasiyatiTypography.caption.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
