import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/wasiyati_card.dart';
import 'digital_will_screen.dart';
import 'credentials_locker_screen.dart';
import '../../config/translations.dart';

/// Vault home screen (Premium feature)
class VaultHomeScreen extends ConsumerWidget {
  final VoidCallback onUpgrade;

  const VaultHomeScreen({super.key, required this.onUpgrade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final s = ref.watch(translationsProvider);

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('🏛️', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.get('vault'),
                            style: WasiyatiTypography.displaySmall),
                        Text(
                          s.get('encrypted_private_space'),
                          style: WasiyatiTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (!isPremium) ...[
                // Premium lock overlay
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: WasiyatiColors.darkGradient,
                    borderRadius:
                        BorderRadius.circular(WasiyatiRadius.xl),
                  ),
                  child: Column(
                    children: [
                      const Text('🔒',
                          style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text(
                        s.get('premium_feature'),
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.displayFont,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: WasiyatiColors.goldenHour,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.get('premium_desc'),
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: onUpgrade,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: WasiyatiColors.goldGradient,
                            borderRadius:
                                BorderRadius.circular(WasiyatiRadius.pill),
                          ),
                          child: Text(
                            s.get('unlock_premium'),
                            style: TextStyle(
                              fontFamily: WasiyatiTypography.bodyFont,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: WasiyatiColors.charcoal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Vault categories grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _VaultCategory(
                      icon: '📜',
                      label: s.get('digital_will'),
                      subtitle: 'Your last wishes',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DigitalWillScreen(
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                    _VaultCategory(
                      icon: '🔐',
                      label: s.get('credentials_label'),
                      subtitle: 'Encrypted accounts',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CredentialsLockerScreen(
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                    _VaultCategory(
                      icon: '🎬',
                      label: s.get('video_testament'),
                      subtitle: 'Record your words',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video recording coming soon!')),
                      ),
                    ),
                    _VaultCategory(
                      icon: '🌍',
                      label: s.get('letter_world'),
                      subtitle: 'Public or private',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DigitalWillScreen(
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // Security info
              WasiyatiCard(
                child: Row(
                  children: [
                    const Text('🛡️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.get('zero_knowledge'),
                            style: WasiyatiTypography.labelMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.get('zero_knowledge_desc'),
                            style: WasiyatiTypography.caption
                                .copyWith(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaultCategory extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _VaultCategory({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
          border: Border.all(color: WasiyatiColors.cardBorder),
          boxShadow: WasiyatiColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(label, style: WasiyatiTypography.labelMedium),
            const SizedBox(height: 2),
            Text(subtitle, style: WasiyatiTypography.caption),
          ],
        ),
      ),
    );
  }
}
