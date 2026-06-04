import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/messages_provider.dart';
import '../../providers/recipients_provider.dart';
import '../../providers/vault_provider.dart';
import '../../widgets/common/wasiyati_card.dart';
import '../../widgets/animations/animations.dart';

/// Dashboard — Main home screen
class DashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback onNewMessage;
  final Function(String) onViewMessage;
  final VoidCallback onCheckIn;
  final VoidCallback onUpgrade;

  const DashboardScreen({
    super.key,
    required this.onNewMessage,
    required this.onViewMessage,
    required this.onCheckIn,
    required this.onUpgrade,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data
    Future.microtask(() {
      ref.read(messagesProvider.notifier).loadMessages('user_001');
      ref.read(recipientsProvider.notifier).loadRecipients('user_001');
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider) ?? MockData.currentUser;
    final messages = ref.watch(messagesProvider);
    final messagesCount = ref.watch(messagesCountProvider);
    final recipientsCount = ref.watch(recipientsCountProvider);
    final trigger = MockData.currentTrigger;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: WasiyatiColors.headerGradient,
              ),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlideTransition(
                    child: Text(
                      'Good morning',
                      style: WasiyatiTypography.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      '${user.name} 🌙',
                      style: WasiyatiTypography.displaySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WasiyatiColors.success.withValues(alpha: 0.12),
                        border: Border.all(
                          color: WasiyatiColors.success.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulseGlow(size: 6),
                          const SizedBox(width: 6),
                          Text(
                            'Legacy is safe',
                            style: TextStyle(
                              fontFamily: WasiyatiTypography.bodyFont,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: WasiyatiColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: '📝',
                          value: '$messagesCount',
                          label: 'Messages',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: '👥',
                          value: '$recipientsCount',
                          label: 'Recipients',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Next check-in card
                  WasiyatiCard(
                    onTap: widget.onCheckIn,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⏰',
                                  style: TextStyle(fontSize: 24)),
                              const SizedBox(height: 4),
                              Text(
                                'Next check-in',
                                style: WasiyatiTypography.labelMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${trigger.daysRemaining} days remaining',
                                style: WasiyatiTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Jun 21',
                              style:
                                  WasiyatiTypography.displaySmall.copyWith(
                                fontSize: 28,
                                color: WasiyatiColors.softAmber,
                              ),
                            ),
                            Text('2025', style: WasiyatiTypography.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Premium banner
          SliverToBoxAdapter(
            child: PremiumBanner(onUpgrade: widget.onUpgrade),
          ),

          // Recent messages header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Text(
                'Your Messages',
                style: WasiyatiTypography.headlineSmall,
              ),
            ),
          ),

          // Messages list
          messages.when(
            data: (msgs) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= msgs.length) return null;
                  final msg = msgs[index];
                  return _MessageListCard(
                    message: msg,
                    onTap: () => widget.onViewMessage(msg.id),
                  );
                },
                childCount: msgs.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: WasiyatiColors.softAmber,
                  ),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error loading messages: $e'),
              ),
            ),
          ),

          // New message button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GestureDetector(
                onTap: widget.onNewMessage,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: WasiyatiColors.primaryGradient,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                    boxShadow: WasiyatiColors.buttonShadow,
                  ),
                  child: Center(
                    child: Text(
                      '+ New Message',
                      style: WasiyatiTypography.labelLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

/// Message card in the dashboard list
class _MessageListCard extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onTap;

  const _MessageListCard({
    required this.message,
    required this.onTap,
  });

  Color get _iconBg {
    switch (message.type) {
      case MessageType.immediate:
        return WasiyatiColors.softAmber.withValues(alpha: 0.15);
      case MessageType.recurring:
        return WasiyatiColors.goldenHour.withValues(alpha: 0.15);
      case MessageType.occasion:
        return WasiyatiColors.deepRose.withValues(alpha: 0.12);
      case MessageType.milestone:
        return WasiyatiColors.warmTaupe.withValues(alpha: 0.12);
    }
  }

  String get _icon {
    switch (message.type) {
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

  Color get _badgeColor {
    switch (message.type) {
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

  Color get _badgeBg {
    switch (message.type) {
      case MessageType.immediate:
        return WasiyatiColors.deepRose.withValues(alpha: 0.12);
      case MessageType.recurring:
        return WasiyatiColors.softAmber.withValues(alpha: 0.15);
      case MessageType.occasion:
        return WasiyatiColors.goldenHour.withValues(alpha: 0.15);
      case MessageType.milestone:
        return WasiyatiColors.warmTaupe.withValues(alpha: 0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
            border: Border.all(color: WasiyatiColors.cardBorder),
            boxShadow: WasiyatiColors.cardShadow,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                ),
                child: Center(
                  child: Text(_icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.title,
                      style: WasiyatiTypography.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${message.typeLabel} · ${message.recipients.length} recipient${message.recipients.length != 1 ? 's' : ''}',
                      style: WasiyatiTypography.caption,
                    ),
                  ],
                ),
              ),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message.typeLabel,
                  style: TextStyle(
                    fontFamily: WasiyatiTypography.bodyFont,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _badgeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
