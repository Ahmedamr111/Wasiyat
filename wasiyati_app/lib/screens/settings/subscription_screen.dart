import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

/// Subscription & Billing screen
class SubscriptionScreen extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onUpgrade;

  const SubscriptionScreen({
    super.key,
    required this.onBack,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: WasiyatiColors.softAmber),
        ),
      );
    }
    final isPremium = user.isPremium;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        backgroundColor: WasiyatiColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: onBack,
          color: WasiyatiColors.charcoal,
        ),
        title: Text('Subscription', style: WasiyatiTypography.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current plan card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isPremium
                    ? WasiyatiColors.goldGradient
                    : WasiyatiColors.darkGradient,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                boxShadow: isPremium
                    ? WasiyatiColors.goldButtonShadow
                    : WasiyatiColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPremium ? '✨ Premium' : 'Free Plan',
                    style: const TextStyle(
                      fontFamily: WasiyatiTypography.bodyFont,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPremium ? 'Active Subscription' : 'Limited Features',
                    style: WasiyatiTypography.headlineMedium
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium
                        ? 'Renews June 29, 2026 · \$4.99/month'
                        : 'Upgrade to unlock everything',
                    style: WasiyatiTypography.bodySmall
                        .copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Feature comparison
            Text('PLAN COMPARISON', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
                boxShadow: WasiyatiColors.cardShadow,
              ),
              child: Column(
                children: [
                  _PlanFeatureRow(
                    icon: '📝',
                    label: 'Messages',
                    free: 'Max 5',
                    premium: 'Unlimited',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '👥',
                    label: 'Recipients',
                    free: 'Max 3',
                    premium: 'Unlimited',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🎬',
                    label: 'Video Messages',
                    free: '✗',
                    premium: '✓',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🏛️',
                    label: 'The Vault',
                    free: '✗',
                    premium: '✓',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🤝',
                    label: 'Trusted Contacts',
                    free: '1',
                    premium: '2',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🔄',
                    label: 'Recurring Duration',
                    free: '3 months',
                    premium: 'Forever',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🧪',
                    label: 'Test Send',
                    free: '✗',
                    premium: '✓',
                    isPremium: isPremium,
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _PlanFeatureRow(
                    icon: '🎉',
                    label: 'Custom Occasions',
                    free: '✗',
                    premium: '✓',
                    isPremium: isPremium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            if (!isPremium) ...[
              // Pricing
              Text('CHOOSE A PLAN', style: WasiyatiTypography.overline),
              const SizedBox(height: 12),
              _PricingCard(
                period: 'Monthly',
                price: '\$4.99',
                sub: 'per month',
                badge: null,
                onTap: onUpgrade,
              ),
              const SizedBox(height: 10),
              _PricingCard(
                period: 'Annual',
                price: '\$39.99',
                sub: 'per year · save 33%',
                badge: 'BEST VALUE',
                onTap: onUpgrade,
              ),
              const SizedBox(height: 10),
              _PricingCard(
                period: 'Family Plan',
                price: '\$9.99',
                sub: 'per month · up to 6 members',
                badge: 'POPULAR',
                onTap: onUpgrade,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Cancel anytime. No hidden fees.',
                  style: WasiyatiTypography.caption,
                ),
              ),
            ] else ...[
              // Manage subscription
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                  border: Border.all(color: WasiyatiColors.cardBorder),
                  boxShadow: WasiyatiColors.cardShadow,
                ),
                child: Column(
                  children: [
                    _ManageItem(
                      icon: '📋',
                      label: 'View Billing History',
                      onTap: () {},
                    ),
                    Divider(color: WasiyatiColors.divider, height: 1),
                    _ManageItem(
                      icon: '💳',
                      label: 'Update Payment Method',
                      onTap: () {},
                    ),
                    Divider(color: WasiyatiColors.divider, height: 1),
                    _ManageItem(
                      icon: '❌',
                      label: 'Cancel Subscription',
                      onTap: () {},
                      isDestructive: true,
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

class _PlanFeatureRow extends StatelessWidget {
  final String icon;
  final String label;
  final String free;
  final String premium;
  final bool isPremium;

  const _PlanFeatureRow({
    required this.icon,
    required this.label,
    required this.free,
    required this.premium,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: WasiyatiTypography.bodyMedium),
          ),
          SizedBox(
            width: 60,
            child: Text(
              free,
              style: WasiyatiTypography.caption.copyWith(
                color: isPremium ? WasiyatiColors.muted : WasiyatiColors.warmTaupe,
                decoration: isPremium ? TextDecoration.lineThrough : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              premium,
              style: WasiyatiTypography.labelSmall.copyWith(
                color: WasiyatiColors.deepRose,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String period;
  final String price;
  final String sub;
  final String? badge;
  final VoidCallback onTap;

  const _PricingCard({
    required this.period,
    required this.price,
    required this.sub,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
          border: Border.all(
            color: badge != null
                ? WasiyatiColors.softAmber
                : WasiyatiColors.cardBorder,
            width: badge != null ? 2 : 1,
          ),
          boxShadow: WasiyatiColors.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(period, style: WasiyatiTypography.labelLarge),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: WasiyatiColors.goldGradient,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              fontFamily: WasiyatiTypography.bodyFont,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(sub, style: WasiyatiTypography.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: WasiyatiTypography.headlineSmall.copyWith(
                    color: WasiyatiColors.deepRose,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: WasiyatiColors.muted),
          ],
        ),
      ),
    );
  }
}

class _ManageItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ManageItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: WasiyatiTypography.labelMedium.copyWith(
                  color:
                      isDestructive ? WasiyatiColors.error : WasiyatiColors.charcoal,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: isDestructive
                    ? WasiyatiColors.error.withValues(alpha: 0.5)
                    : WasiyatiColors.muted,
                size: 20),
          ],
        ),
      ),
    );
  }
}
