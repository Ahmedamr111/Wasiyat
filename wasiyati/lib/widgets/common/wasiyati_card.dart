import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Wasiyati Card — warm shadow, 20px rounded corners, subtle border
class WasiyatiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool isWide;
  final Color? backgroundColor;
  final List<BoxShadow>? customShadow;

  const WasiyatiCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isWide = false,
    this.backgroundColor,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding ?? const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor ?? WasiyatiColors.cardWhite,
          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
          border: Border.all(color: WasiyatiColors.cardBorder),
          boxShadow: customShadow ?? WasiyatiColors.cardShadow,
        ),
        child: child,
      ),
    );
  }
}

/// Stat Card for the dashboard grid
class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final bool isWide;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.isWide = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (isWide && trailing != null) {
      return WasiyatiCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: WasiyatiTypography.labelMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(label, style: WasiyatiTypography.caption),
                ],
              ),
            ),
            trailing!,
          ],
        ),
      );
    }

    return WasiyatiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(value, style: WasiyatiTypography.statNumber),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: WasiyatiTypography.caption.copyWith(
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium Banner — dark gradient with gold accent
class PremiumBanner extends StatelessWidget {
  final VoidCallback? onUpgrade;

  const PremiumBanner({super.key, this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: WasiyatiColors.darkGradient,
        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ Unlock Premium',
                  style: TextStyle(
                    fontFamily: WasiyatiTypography.displayFont,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: WasiyatiColors.goldenHour,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlimited messages · Video · The Vault',
                  style: TextStyle(
                    fontFamily: WasiyatiTypography.bodyFont,
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUpgrade,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: WasiyatiColors.goldGradient,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
              ),
              child: Text(
                'Upgrade',
                style: TextStyle(
                  fontFamily: WasiyatiTypography.bodyFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: WasiyatiColors.charcoal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
