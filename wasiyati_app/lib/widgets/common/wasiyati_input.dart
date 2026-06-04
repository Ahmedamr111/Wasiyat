import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Wasiyati Input — borderless with warm underline, Cormorant Garamond for display fields
class WasiyatiInput extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisplayFont;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? focusNode;
  final String? errorText;

  const WasiyatiInput({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.onChanged,
    this.isDisplayFont = false,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!.toUpperCase(),
              style: WasiyatiTypography.overline,
            ),
          ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          focusNode: focusNode,
          style: isDisplayFont
              ? WasiyatiTypography.headlineSmall
              : WasiyatiTypography.bodyLarge,
          cursorColor: WasiyatiColors.softAmber,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: isDisplayFont
                ? WasiyatiTypography.editorPlaceholder.copyWith(fontSize: 20)
                : WasiyatiTypography.bodyLarge.copyWith(
                    color: WasiyatiColors.muted.withValues(alpha: 0.6),
                  ),
            prefixIcon: prefix,
            suffixIcon: suffix,
            errorText: errorText,
            errorStyle: TextStyle(
              color: WasiyatiColors.error,
              fontSize: 12,
              fontFamily: WasiyatiTypography.bodyFont,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: WasiyatiColors.inputBorder,
                width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: WasiyatiColors.inputBorder,
                width: 2,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: WasiyatiColors.softAmber,
                width: 2,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: WasiyatiColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}

/// Search input with warm styling
class WasiyatiSearchInput extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const WasiyatiSearchInput({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WasiyatiRadius.md),
        border: Border.all(color: WasiyatiColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: WasiyatiTypography.bodyMedium,
        cursorColor: WasiyatiColors.softAmber,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: WasiyatiTypography.bodyMedium.copyWith(
            color: WasiyatiColors.muted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: WasiyatiColors.muted,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
