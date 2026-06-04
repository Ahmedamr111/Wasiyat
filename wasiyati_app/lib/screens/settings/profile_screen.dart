import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';
import '../trusted_contact/tc_screens.dart';
import 'trusted_contacts_screen.dart';
import 'checkin_settings_screen.dart';
import 'subscription_screen.dart';
import 'language_region_screen.dart';
import 'security_privacy_screen.dart';
import 'edit_profile_screen.dart';

/// Profile & Settings screen
class ProfileScreen extends ConsumerWidget {
  final VoidCallback onUpgrade;

  const ProfileScreen({super.key, required this.onUpgrade});

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

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile header
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: WasiyatiColors.primaryGradient,
                    ),
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.name, style: WasiyatiTypography.headlineLarge),
                  const SizedBox(height: 4),
                  Text(user.email, style: WasiyatiTypography.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: user.isPremium
                          ? WasiyatiColors.goldenHour.withValues(alpha: 0.15)
                          : WasiyatiColors.warmTaupe.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.isPremium ? '✨ Premium' : 'Free Plan',
                      style: TextStyle(
                        fontFamily: WasiyatiTypography.bodyFont,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: user.isPremium
                            ? const Color(0xFFB8860B)
                            : WasiyatiColors.warmTaupe,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Settings sections
              _SettingsSection(
                title: 'Account',
                items: [
                   _SettingsItem(
                    icon: '👤',
                    label: 'Edit Profile',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  _SettingsItem(
                    icon: '🤝',
                    label: 'Trusted Contacts',
                    subtitle: '1 contact',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrustedContactsScreen(
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  _SettingsItem(
                    icon: '⏰',
                    label: 'Check-in Settings',
                    subtitle: 'Every 30 days',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckinSettingsScreen(
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'Security',
                items: [
                  _SettingsItem(
                    icon: '🔒',
                    label: 'Security & Privacy',
                    subtitle: 'PIN, biometrics, encryption',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SecurityPrivacyScreen(
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  _SettingsItem(
                    icon: '🔑',
                    label: 'Security Phrase',
                    subtitle: user.securityPhraseHash != null ? 'Phrase is active ✓' : 'Set secret verification phrase',
                    onTap: () => _showSecurityPhraseSheet(context, ref, user),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'Preferences',
                items: [
                  _SettingsItem(
                    icon: '🌍',
                    label: 'Language & Region',
                    subtitle: 'English',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LanguageRegionScreen(
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  _SettingsItem(
                    icon: '💳',
                    label: 'Subscription & Billing',
                    subtitle: user.isPremium ? 'Premium' : 'Free',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubscriptionScreen(
                          onBack: () => Navigator.pop(context),
                          onUpgrade: onUpgrade,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'Support',
                items: [
                  _SettingsItem(
                    icon: '❓',
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: '📋',
                    label: 'Terms of Service',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: '🔐',
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: '👥',
                    label: 'Switch to Trusted Contact View',
                    subtitle: 'Verify and confirm passing for Ahmed',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrustedContactDashboardScreen(ownerId: user.id),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign out
              WasiyatiButton(
                label: 'Sign Out',
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).signOut();
                },
                isOutlined: true,
                fullWidth: true,
              ),
              const SizedBox(height: 12),

              Text(
                'Wasiyati v1.0.0',
                style: WasiyatiTypography.caption,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _showSecurityPhraseSheet(BuildContext context, WidgetRef ref, UserModel user) {
    final controller = TextEditingController(text: user.securityPhraseHash ?? '');
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: WasiyatiColors.muted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '🔑 Security Phrase',
                style: WasiyatiTypography.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Create a secret word or phrase. Share this phrase PRIVATELY with your Trusted Contacts so they can verify their identity and trigger your messages only when needed.',
                style: WasiyatiTypography.bodySmall.copyWith(color: WasiyatiColors.warmTaupe),
              ),
              const SizedBox(height: 24),
              WasiyatiInput(
                label: 'YOUR SECRET PHRASE',
                hint: 'e.g. AhmedLegacy2026',
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 32),
              WasiyatiButton(
                label: 'Save Security Phrase',
                isLoading: isSaving,
                fullWidth: true,
                onPressed: () async {
                  if (controller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a secret phrase')),
                    );
                    return;
                  }
                  setState(() => isSaving = true);
                  try {
                    await ref.read(authStateProvider.notifier).updateProfile(
                      securityPhraseHash: controller.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ Security Phrase saved successfully!'),
                          backgroundColor: WasiyatiColors.success,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: WasiyatiColors.error,
                        ),
                      );
                    }
                  } finally {
                    setState(() => isSaving = false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: WasiyatiTypography.overline,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
            border: Border.all(color: WasiyatiColors.cardBorder),
            boxShadow: WasiyatiColors.cardShadow,
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 54,
                      color: WasiyatiColors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
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
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: WasiyatiTypography.labelMedium),
                  if (subtitle != null)
                    Text(subtitle!, style: WasiyatiTypography.caption),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: WasiyatiColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
