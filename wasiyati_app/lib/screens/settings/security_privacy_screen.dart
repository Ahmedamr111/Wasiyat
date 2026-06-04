import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../security/pin_lock_screen.dart';

/// Security & Privacy settings screen
class SecurityPrivacyScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SecurityPrivacyScreen({super.key, required this.onBack});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool _pinEnabled = true;
  bool _biometricEnabled = false;
  bool _encryptionEnabled = true;
  bool _screenshotBlocked = true;
  String _autoLockDuration = '5 minutes';

  static const _autoLockOptions = [
    'Immediately',
    '1 minute',
    '5 minutes',
    '15 minutes',
    '1 hour',
  ];

  void _changePIN() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinLockScreen(
          title: 'Change PIN',
          subtitle: 'Enter your current PIN first',
          isSetup: false,
          onSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PinLockScreen(
                  title: 'Create New PIN',
                  isSetup: true,
                  onSuccess: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ PIN changed successfully'),
                        backgroundColor: WasiyatiColors.success,
                      ),
                    );
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
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
          color: WasiyatiColors.charcoal,
          onPressed: widget.onBack,
        ),
        title: Text('Security & Privacy',
            style: WasiyatiTypography.headlineSmall),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Encryption status banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  WasiyatiColors.success.withValues(alpha: 0.1),
                  WasiyatiColors.success.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
              border: Border.all(
                color: WasiyatiColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Text('🛡️', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AES-256 Encryption Active',
                        style: WasiyatiTypography.labelMedium.copyWith(
                          color: WasiyatiColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'All your messages and vault items are end-to-end encrypted.',
                        style: WasiyatiTypography.caption.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // PIN section
          Text('PIN PROTECTION', style: WasiyatiTypography.overline),
          const SizedBox(height: 10),
          _SecurityCard(
            icon: '🔐',
            title: 'App PIN Lock',
            subtitle: 'Require PIN to open the app',
            trailing: Switch(
              value: _pinEnabled,
              onChanged: (v) => setState(() => _pinEnabled = v),
              activeThumbColor: Colors.white,
              activeTrackColor: WasiyatiColors.deepRose,
            ),
          ),
          const SizedBox(height: 8),
          if (_pinEnabled) ...[
            _SecurityCard(
              icon: '👆',
              title: 'Biometric Unlock',
              subtitle: 'Use fingerprint or Face ID',
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: (v) => setState(() => _biometricEnabled = v),
                activeThumbColor: Colors.white,
                activeTrackColor: WasiyatiColors.deepRose,
              ),
            ),
            const SizedBox(height: 8),
            _SecurityCard(
              icon: '🔑',
              title: 'Change PIN',
              subtitle: 'Update your 4-digit PIN',
              onTap: _changePIN,
            ),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 16),

          // Auto-lock
          Text('AUTO-LOCK', style: WasiyatiTypography.overline),
          const SizedBox(height: 10),
          _SecurityCard(
            icon: '⏱️',
            title: 'Auto-lock After',
            subtitle: _autoLockDuration,
            onTap: () => _showAutoLockPicker(),
          ),
          const SizedBox(height: 8),
          _SecurityCard(
            icon: '🚫',
            title: 'Block Screenshots',
            subtitle: 'Prevent screen capture in app',
            trailing: Switch(
              value: _screenshotBlocked,
              onChanged: (v) => setState(() => _screenshotBlocked = v),
              activeThumbColor: Colors.white,
              activeTrackColor: WasiyatiColors.deepRose,
            ),
          ),
          const SizedBox(height: 24),

          // Encryption
          Text('ENCRYPTION', style: WasiyatiTypography.overline),
          const SizedBox(height: 10),
          _SecurityCard(
            icon: '🗝️',
            title: 'Local Encryption',
            subtitle: 'Encrypt vault on this device',
            trailing: Switch(
              value: _encryptionEnabled,
              onChanged: (v) => setState(() => _encryptionEnabled = v),
              activeThumbColor: Colors.white,
              activeTrackColor: WasiyatiColors.deepRose,
            ),
          ),
          const SizedBox(height: 8),
          _SecurityCard(
            icon: '🔄',
            title: 'Rotate Encryption Keys',
            subtitle: 'Re-encrypt all data with a new key',
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Rotate Keys?'),
                  content: const Text(
                    'This will re-encrypt all your data. It may take a few minutes.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Rotate',
                        style: TextStyle(color: WasiyatiColors.deepRose),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Danger zone
          Text('DANGER ZONE', style: WasiyatiTypography.overline),
          const SizedBox(height: 10),
          _SecurityCard(
            icon: '💣',
            title: 'Emergency Wipe',
            subtitle: 'Delete all data immediately',
            titleColor: WasiyatiColors.error,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Emergency Wipe'),
                  content: const Text(
                    'This will permanently delete ALL your data, messages, and vault items. This cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Wipe Everything',
                        style: TextStyle(color: WasiyatiColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showAutoLockPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: WasiyatiColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Auto-lock After', style: WasiyatiTypography.headlineSmall),
            const SizedBox(height: 16),
            ..._autoLockOptions.map((opt) => ListTile(
                  title: Text(opt, style: WasiyatiTypography.bodyMedium),
                  trailing: _autoLockDuration == opt
                      ? const Icon(Icons.check_rounded,
                          color: WasiyatiColors.deepRose)
                      : null,
                  onTap: () {
                    setState(() => _autoLockDuration = opt);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SecurityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
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
                  Text(
                    title,
                    style: WasiyatiTypography.labelMedium.copyWith(
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: WasiyatiTypography.caption),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: WasiyatiColors.muted),
          ],
        ),
      ),
    );
  }
}
