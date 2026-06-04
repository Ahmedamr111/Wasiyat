import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Check-in Settings screen — frequency, notifications, etc.
class CheckinSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CheckinSettingsScreen({super.key, required this.onBack});

  @override
  State<CheckinSettingsScreen> createState() => _CheckinSettingsScreenState();
}

class _CheckinSettingsScreenState extends State<CheckinSettingsScreen> {
  int _checkinIntervalDays = 30;
  int _responseWindowDays = 7;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _isSaving = false;

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
        title:
            Text('Check-in Settings', style: WasiyatiTypography.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // How it works card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WasiyatiColors.softAmber.withValues(alpha: 0.1),
                    WasiyatiColors.deepRose.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⏰ How Check-in Works',
                      style: WasiyatiTypography.labelLarge),
                  const SizedBox(height: 10),
                  _HowItWorksStep(
                    number: '1',
                    text:
                        'Wasiyati sends you a check-in notification every $_checkinIntervalDays days.',
                  ),
                  const SizedBox(height: 6),
                  _HowItWorksStep(
                    number: '2',
                    text:
                        'You have $_responseWindowDays days to respond with "Yes, I\'m alright".',
                  ),
                  const SizedBox(height: 6),
                  const _HowItWorksStep(
                    number: '3',
                    text:
                        'If no response, your Trusted Contacts receive a 48-hour grace period alert.',
                  ),
                  const SizedBox(height: 6),
                  const _HowItWorksStep(
                    number: '4',
                    text:
                        'If confirmed, your messages are delivered to your recipients.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Check-in frequency
            Text('CHECK-IN FREQUENCY', style: WasiyatiTypography.overline),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
                boxShadow: WasiyatiColors.cardShadow,
              ),
              child: Column(
                children: [
                  _IntervalOption(
                    label: 'Every 14 days',
                    sublabel: 'More frequent checks',
                    isSelected: _checkinIntervalDays == 14,
                    onTap: () => setState(() => _checkinIntervalDays = 14),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _IntervalOption(
                    label: 'Every 30 days',
                    sublabel: 'Recommended',
                    isSelected: _checkinIntervalDays == 30,
                    isDefault: true,
                    onTap: () => setState(() => _checkinIntervalDays = 30),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _IntervalOption(
                    label: 'Every 60 days',
                    sublabel: 'Less frequent',
                    isSelected: _checkinIntervalDays == 60,
                    onTap: () => setState(() => _checkinIntervalDays = 60),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _IntervalOption(
                    label: 'Every 90 days',
                    sublabel: 'Quarterly check-ins',
                    isSelected: _checkinIntervalDays == 90,
                    onTap: () => setState(() => _checkinIntervalDays = 90),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Response window
            Text('RESPONSE WINDOW', style: WasiyatiTypography.overline),
            const SizedBox(height: 4),
            Text(
              'How long you have to respond before Trusted Contacts are alerted',
              style: WasiyatiTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
                boxShadow: WasiyatiColors.cardShadow,
              ),
              child: Column(
                children: [
                  _IntervalOption(
                    label: '3 days',
                    isSelected: _responseWindowDays == 3,
                    onTap: () => setState(() => _responseWindowDays = 3),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _IntervalOption(
                    label: '7 days',
                    sublabel: 'Recommended',
                    isSelected: _responseWindowDays == 7,
                    isDefault: true,
                    onTap: () => setState(() => _responseWindowDays = 7),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _IntervalOption(
                    label: '14 days',
                    isSelected: _responseWindowDays == 14,
                    onTap: () => setState(() => _responseWindowDays = 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notification channels
            Text('NOTIFICATION CHANNELS',
                style: WasiyatiTypography.overline),
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
                  _NotificationToggle(
                    icon: '🔔',
                    label: 'Push Notifications',
                    value: _pushNotifications,
                    onChanged: (v) =>
                        setState(() => _pushNotifications = v),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _NotificationToggle(
                    icon: '📧',
                    label: 'Email Notifications',
                    value: _emailNotifications,
                    onChanged: (v) =>
                        setState(() => _emailNotifications = v),
                  ),
                  Divider(color: WasiyatiColors.divider, height: 1),
                  _NotificationToggle(
                    icon: '📱',
                    label: 'SMS Notifications',
                    value: _smsNotifications,
                    onChanged: (v) =>
                        setState(() => _smsNotifications = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () async {
                  setState(() => _isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  await Future.delayed(const Duration(milliseconds: 600));
                  if (!mounted) return;
                  setState(() => _isSaving = false);
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('✓ Check-in settings saved'),
                      backgroundColor: WasiyatiColors.success,
                    ),
                  );
                  widget.onBack();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: WasiyatiColors.primaryGradient,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                    boxShadow: WasiyatiColors.buttonShadow,
                  ),
                  child: Center(
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Settings',
                            style: WasiyatiTypography.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String number;
  final String text;

  const _HowItWorksStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: WasiyatiColors.deepRose,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: WasiyatiTypography.bodySmall),
        ),
      ],
    );
  }
}

class _IntervalOption extends StatelessWidget {
  final String label;
  final String? sublabel;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback onTap;

  const _IntervalOption({
    required this.label,
    this.sublabel,
    required this.isSelected,
    this.isDefault = false,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label, style: WasiyatiTypography.labelMedium),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                WasiyatiColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'recommended',
                            style: TextStyle(
                              fontFamily: WasiyatiTypography.bodyFont,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: WasiyatiColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (sublabel != null)
                    Text(sublabel!, style: WasiyatiTypography.caption),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? WasiyatiColors.deepRose
                      : WasiyatiColors.muted,
                  width: 2,
                ),
                color: isSelected ? WasiyatiColors.deepRose : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: WasiyatiTypography.labelMedium),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: WasiyatiColors.deepRose,
          ),
        ],
      ),
    );
  }
}
