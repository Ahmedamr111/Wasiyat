import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../config/translations.dart';
import '../../providers/vault_provider.dart';
import '../home/dashboard_screen.dart';
import '../messages/messages_list_screen.dart';
import '../recipients/recipients_list_screen.dart';
import '../vault/vault_home_screen.dart';
import '../settings/profile_screen.dart';

/// Home shell — bottom navigation with 5 tabs
class HomeShell extends ConsumerWidget {
  final VoidCallback onNewMessage;
  final Function(String) onViewMessage;
  final VoidCallback onCheckIn;
  final VoidCallback onUpgrade;

  const HomeShell({
    super.key,
    required this.onNewMessage,
    required this.onViewMessage,
    required this.onCheckIn,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final s = ref.watch(translationsProvider);

    final screens = [
      DashboardScreen(
        onNewMessage: onNewMessage,
        onViewMessage: onViewMessage,
        onCheckIn: onCheckIn,
        onUpgrade: onUpgrade,
      ),
      MessagesListScreen(
        onNewMessage: onNewMessage,
        onViewMessage: onViewMessage,
      ),
      RecipientsListScreen(),
      VaultHomeScreen(onUpgrade: onUpgrade),
      ProfileScreen(onUpgrade: onUpgrade),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: WasiyatiColors.warmTaupe.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _NavItem(
                  icon: '🏠',
                  label: s.get('dashboard'),
                  isActive: currentIndex == 0,
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 0,
                ),
                _NavItem(
                  icon: '📝',
                  label: s.get('messages'),
                  isActive: currentIndex == 1,
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 1,
                ),
                _NavItem(
                  icon: '👥',
                  label: s.get('people'),
                  isActive: currentIndex == 2,
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 2,
                ),
                _NavItem(
                  icon: '🏛️',
                  label: s.get('vault'),
                  isActive: currentIndex == 3,
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 3,
                ),
                _NavItem(
                  icon: '👤',
                  label: s.get('profile'),
                  isActive: currentIndex == 4,
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 4,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: currentIndex == 0
          ? Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: WasiyatiColors.primaryGradient,
                borderRadius: BorderRadius.circular(WasiyatiRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: WasiyatiColors.deepRose.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNewMessage,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.lg),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 22,
                color: isActive ? null : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: WasiyatiTypography.bodyFont,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? WasiyatiColors.deepRose
                    : WasiyatiColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
