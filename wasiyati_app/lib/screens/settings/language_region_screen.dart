import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/vault_provider.dart';
import '../../providers/auth_provider.dart';

/// Language & Region settings screen
class LanguageRegionScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const LanguageRegionScreen({super.key, required this.onBack});

  @override
  ConsumerState<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends ConsumerState<LanguageRegionScreen> {
  String _selectedLanguage = 'en';
  String _selectedTimezone = 'Asia/Riyadh';
  String _selectedDateFormat = 'DD/MM/YYYY';

  static const _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية', 'flag': '🇸🇦'},
    {'code': 'fr', 'name': 'French', 'native': 'Français', 'flag': '🇫🇷'},
    {'code': 'tr', 'name': 'Turkish', 'native': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'ur', 'name': 'Urdu', 'native': 'اردو', 'flag': '🇵🇰'},
  ];

  static const _timezones = [
    'Asia/Riyadh',
    'Africa/Cairo',
    'Asia/Dubai',
    'Asia/Istanbul',
    'Europe/London',
    'America/New_York',
    'Asia/Karachi',
  ];

  static const _dateFormats = [
    'DD/MM/YYYY',
    'MM/DD/YYYY',
    'YYYY-MM-DD',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(localeProvider);
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Language & Region',
            style: WasiyatiTypography.headlineSmall),
        actions: [
          TextButton(
            onPressed: () async {
              ref.read(localeProvider.notifier).state = _selectedLanguage;

              // Persist language to remote Firestore user profile
              await ref.read(authStateProvider.notifier).updateProfile(language: _selectedLanguage);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _selectedLanguage == 'ar'
                          ? '✓ تم حفظ إعدادات اللغة'
                          : '✓ Language settings saved',
                    ),
                    backgroundColor: WasiyatiColors.success,
                  ),
                );
                widget.onBack();
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: WasiyatiColors.deepRose,
                fontFamily: WasiyatiTypography.bodyFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language
            Text('APP LANGUAGE', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            ..._languages.map((lang) {
              final isSelected = _selectedLanguage == lang['code'];
              return GestureDetector(
                onTap: () => setState(() => _selectedLanguage = lang['code']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? WasiyatiColors.deepRose.withValues(alpha: 0.06)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                    border: Border.all(
                      color: isSelected
                          ? WasiyatiColors.deepRose.withValues(alpha: 0.3)
                          : WasiyatiColors.cardBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: WasiyatiColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Text(lang['flag']!,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lang['name']!,
                                style: WasiyatiTypography.labelMedium),
                            Text(lang['native']!,
                                style: WasiyatiTypography.caption),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: WasiyatiColors.deepRose,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),

            // RTL note for Arabic / Urdu
            if (_selectedLanguage == 'ar' || _selectedLanguage == 'ur')
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WasiyatiColors.goldenHour.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                  border: Border.all(
                      color:
                          WasiyatiColors.goldenHour.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Text('↔️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Right-to-Left layout will be applied.',
                        style: WasiyatiTypography.bodySmall.copyWith(
                          color: WasiyatiColors.warmTaupe,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),

            // Timezone
            Text('TIMEZONE', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
                boxShadow: WasiyatiColors.cardShadow,
              ),
              child: DropdownButton<String>(
                value: _selectedTimezone,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                style: WasiyatiTypography.bodyMedium,
                items: _timezones
                    .map((tz) => DropdownMenuItem(
                          value: tz,
                          child: Text(tz),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedTimezone = val);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Date format
            Text('DATE FORMAT', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
                boxShadow: WasiyatiColors.cardShadow,
              ),
              child: Column(
                children: _dateFormats.asMap().entries.map((entry) {
                  final fmt = entry.value;
                  final isLast = entry.key == _dateFormats.length - 1;
                  final isSelected = _selectedDateFormat == fmt;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedDateFormat = fmt),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(fmt,
                                    style: WasiyatiTypography.labelMedium),
                              ),
                              if (isSelected)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: WasiyatiColors.deepRose,
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 13),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        Divider(color: WasiyatiColors.divider, height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
