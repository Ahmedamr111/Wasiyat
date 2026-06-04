import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Wasiyati primary gradient button (pill-shaped, amber → rose)
class WasiyatiButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isGold;
  final bool fullWidth;
  final IconData? icon;
  final double? height;

  const WasiyatiButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isGold = false,
    this.fullWidth = false,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return _buildOutlined();
    }
    return _buildFilled();
  }

  Widget _buildFilled() {
    final gradient = isGold
        ? WasiyatiColors.goldGradient
        : WasiyatiColors.primaryGradient;
    final shadow = isGold
        ? WasiyatiColors.goldButtonShadow
        : WasiyatiColors.buttonShadow;

    return Container(
      width: fullWidth ? double.infinity : null,
      height: height ?? 52,
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? WasiyatiColors.muted.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
        boxShadow: onPressed != null ? shadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: WasiyatiTypography.labelLarge.copyWith(
                          color: isGold
                              ? WasiyatiColors.charcoal
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlined() {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: height ?? 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
        border: Border.all(
          color: WasiyatiColors.warmTaupe.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: WasiyatiColors.warmTaupe,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: WasiyatiColors.warmTaupe, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: WasiyatiTypography.labelMedium.copyWith(
                          color: WasiyatiColors.warmTaupe,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Small tag/chip button
class WasiyatiChipButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const WasiyatiChipButton({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? WasiyatiColors.primaryGradient : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
          border: isActive
              ? null
              : Border.all(
                  color: WasiyatiColors.warmTaupe.withValues(alpha: 0.2),
                  width: 1.5,
                ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: WasiyatiColors.deepRose.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: WasiyatiTypography.bodyFont,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : WasiyatiColors.warmTaupe,
          ),
        ),
      ),
    );
  }
}
