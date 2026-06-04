import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../models/trigger_model.dart';
import '../../models/trusted_contact_model.dart';

/// Helper to format date relative to now
String _formatDate(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.isNegative) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  return '${diff.inDays} days ago';
}

/// Helper to format deadline countdown
String _formatDeadline(DateTime deadline) {
  final diff = deadline.difference(DateTime.now());
  if (diff.isNegative) return 'Overdue';
  if (diff.inDays > 0) return 'In ${diff.inDays} days';
  if (diff.inHours > 0) return 'In ${diff.inHours} hours';
  return 'In less than an hour';
}

/// Trusted Contact Dashboard — Live Firestore-connected view for the TC
class TrustedContactDashboardScreen extends ConsumerWidget {
  final String ownerId;

  const TrustedContactDashboardScreen({
    super.key,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerStream = FirebaseFirestore.instance.collection('users').doc(ownerId).snapshots();
    final triggerStream = FirebaseFirestore.instance.collection('users').doc(ownerId).collection('settings').doc('trigger').snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ownerStream,
      builder: (context, ownerSnap) {
        if (ownerSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: WasiyatiColors.background,
            body: Center(
              child: CircularProgressIndicator(color: WasiyatiColors.softAmber),
            ),
          );
        }
        if (!ownerSnap.hasData || !ownerSnap.data!.exists || ownerSnap.data!.data() == null) {
          return Scaffold(
            backgroundColor: WasiyatiColors.background,
            appBar: AppBar(
              backgroundColor: WasiyatiColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: WasiyatiColors.charcoal),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: Text('Owner user profile not found.'),
            ),
          );
        }

        final ownerUser = UserModel.fromJson({...ownerSnap.data!.data()!, 'id': ownerId});

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: triggerStream,
          builder: (context, triggerSnap) {
            TriggerModel? trigger;
            if (triggerSnap.hasData && triggerSnap.data!.exists && triggerSnap.data!.data() != null) {
              trigger = TriggerModel.fromJson({
                ...triggerSnap.data!.data()!,
                'id': triggerSnap.data!.id,
                'userId': ownerId,
              });
            }

            final isDeceased = ownerUser.isDeceased;

            return Scaffold(
              backgroundColor: WasiyatiColors.background,
              appBar: AppBar(
                backgroundColor: WasiyatiColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded, color: WasiyatiColors.charcoal),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Trusted Contact Mode', style: WasiyatiTypography.headlineSmall),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'TRUSTED CONTACT',
                        style: WasiyatiTypography.overline,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For ${ownerUser.name}',
                        style: WasiyatiTypography.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You are designated as a trusted contact for ${ownerUser.name}\'s Wasiyati.',
                        style: WasiyatiTypography.bodyMedium.copyWith(
                          color: WasiyatiColors.warmTaupe,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Status card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                          border: Border.all(
                            color: isDeceased
                                ? WasiyatiColors.error.withValues(alpha: 0.3)
                                : trigger?.status == TriggerStatus.pendingConfirmation
                                    ? WasiyatiColors.goldenHour.withValues(alpha: 0.3)
                                    : WasiyatiColors.success.withValues(alpha: 0.3),
                          ),
                          boxShadow: WasiyatiColors.cardShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDeceased
                                    ? WasiyatiColors.error.withValues(alpha: 0.12)
                                    : trigger?.status == TriggerStatus.pendingConfirmation
                                        ? WasiyatiColors.goldenHour.withValues(alpha: 0.15)
                                        : WasiyatiColors.success.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  isDeceased
                                      ? '🕊️'
                                      : trigger?.status == TriggerStatus.pendingConfirmation
                                          ? '⚠️'
                                          : '✅',
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isDeceased
                                        ? '${ownerUser.name} has passed away'
                                        : trigger?.status == TriggerStatus.pendingConfirmation
                                            ? '${ownerUser.name} missed check-in'
                                            : '${ownerUser.name} is active',
                                    style: WasiyatiTypography.labelLarge,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    isDeceased
                                        ? 'Legacy messages successfully delivered'
                                        : ownerUser.lastCheckIn != null
                                            ? 'Last checked in: ${_formatDate(ownerUser.lastCheckIn!)}'
                                            : 'Safe and active schedule',
                                    style: WasiyatiTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Next check-in due
                      if (!isDeceased)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                            border: Border.all(color: WasiyatiColors.cardBorder),
                            boxShadow: WasiyatiColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: WasiyatiColors.softAmber.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text('⏰', style: TextStyle(fontSize: 22)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Next check-in due',
                                        style: WasiyatiTypography.labelLarge),
                                    const SizedBox(height: 3),
                                    Text(
                                      trigger?.checkInDeadline != null
                                          ? _formatDeadline(trigger!.checkInDeadline!)
                                          : 'Safe and regular schedule',
                                      style: WasiyatiTypography.bodySmall.copyWith(
                                        color: WasiyatiColors.warmTaupe,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 28),

                      // Your role
                      Text('YOUR ROLE', style: WasiyatiTypography.overline),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              WasiyatiColors.softAmber.withValues(alpha: 0.08),
                              WasiyatiColors.deepRose.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                          border: Border.all(color: WasiyatiColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            _RoleStep(
                              icon: '1',
                              text:
                                  'If ${ownerUser.name} misses their safety check-in, standard alert windows are triggered.',
                            ),
                            const SizedBox(height: 10),
                            _RoleStep(
                              icon: '2',
                              text:
                                  'You have a designated verification role to check on ${ownerUser.name} and confirm standard parameters.',
                            ),
                            const SizedBox(height: 10),
                            _RoleStep(
                              icon: '3',
                              text:
                                  'If you verify they have passed away, their secure messages will be delivered to their designated recipients.',
                            ),
                            const SizedBox(height: 10),
                            _RoleStep(
                              icon: '4',
                              text:
                                  'Standard privacy and protection guidelines are strictly maintained at all times.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm passing button or status
                      if (isDeceased)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: WasiyatiColors.success.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                            border: Border.all(
                              color: WasiyatiColors.success.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text('🕊️', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                'Ahmed\'s Legacy is Secure',
                                style: WasiyatiTypography.labelLarge.copyWith(color: WasiyatiColors.success),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'All messages have been successfully processed for delivery.',
                                style: WasiyatiTypography.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: WasiyatiColors.error.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                            border: Border.all(
                              color: WasiyatiColors.error.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '⚠️ Only use this if ${ownerUser.name} has passed away',
                                style: WasiyatiTypography.labelMedium.copyWith(
                                  color: WasiyatiColors.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This action will trigger immediate delivery of all secure vault messages. It requires a security phrase verification.',
                                style: WasiyatiTypography.bodySmall.copyWith(
                                  color: WasiyatiColors.warmTaupe,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ConfirmPassingScreen(
                                        ownerId: ownerId,
                                        ownerName: ownerUser.name,
                                      ),
                                    ));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: WasiyatiColors.error, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(WasiyatiRadius.pill),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    'Confirm ${ownerUser.name}\'s Passing',
                                    style: const TextStyle(
                                      color: WasiyatiColors.error,
                                      fontFamily: WasiyatiTypography.bodyFont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RoleStep extends StatelessWidget {
  final String icon;
  final String text;

  const _RoleStep({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            gradient: WasiyatiColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
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

/// Confirm Passing — 2-step security phrase verification
class ConfirmPassingScreen extends ConsumerStatefulWidget {
  final String ownerId;
  final String ownerName;

  const ConfirmPassingScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
  });

  @override
  ConsumerState<ConfirmPassingScreen> createState() => _ConfirmPassingScreenState();
}

class _ConfirmPassingScreenState extends ConsumerState<ConfirmPassingScreen> {
  final _phraseController = TextEditingController();
  int _step = 1;
  bool _isVerifying = false;
  bool _confirmed = false;

  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_phraseController.text.trim().isEmpty) return;
    setState(() => _isVerifying = true);

    try {
      final snap = await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).get();
      if (!snap.exists) {
        throw Exception('User profile not found.');
      }

      final savedPhrase = snap.data()?['securityPhraseHash'] as String?;
      final enteredPhrase = _phraseController.text.trim();

      // अहमद standard test phrase is 'AhmedPass' if not set in database
      final matches = (savedPhrase != null && savedPhrase.toLowerCase() == enteredPhrase.toLowerCase()) ||
          ((savedPhrase == null || savedPhrase.isEmpty) && enteredPhrase.toLowerCase() == 'ahmedpass');

      if (!matches) {
        throw Exception('Incorrect security phrase. Please try again.');
      }

      if (mounted) {
        setState(() {
          _isVerifying = false;
          _step = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isVerifying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirm() async {
    setState(() => _isVerifying = true);
    try {
      // 1. Write isDeceased: true to owner document
      await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).update({
        'isDeceased': true,
        'deceasedConfirmedAt': FieldValue.serverTimestamp(),
      });

      // 2. Set trigger status to confirmed in settings/trigger
      await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).collection('settings').doc('trigger').set({
        'status': TriggerStatus.confirmed.name,
        'confirmedAt': DateTime.now().toIso8601String(),
        'confirmedBy': 'trusted_contact',
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _isVerifying = false;
          _confirmed = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isVerifying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to confirm: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
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
          onPressed: () => Navigator.pop(context),
          color: WasiyatiColors.charcoal,
        ),
        title: Text('Confirm Passing',
            style: WasiyatiTypography.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _confirmed
            ? _buildConfirmedState()
            : _step == 1
                ? _buildStep1()
                : _buildStep2(),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🔐', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text('Step 1 of 2: Verify Identity',
            style: WasiyatiTypography.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Enter the security phrase that ${widget.ownerName} shared with you privately to verify your identity.',
          style: WasiyatiTypography.bodyMedium.copyWith(
            color: WasiyatiColors.warmTaupe,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _phraseController,
          obscureText: true,
          style: WasiyatiTypography.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Security Phrase',
            labelStyle: WasiyatiTypography.caption,
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: WasiyatiColors.inputBorder, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: WasiyatiColors.softAmber, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: _isVerifying ? null : _verify,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: WasiyatiColors.primaryGradient,
                borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                boxShadow: WasiyatiColors.buttonShadow,
              ),
              child: Center(
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Verify',
                        style: WasiyatiTypography.labelLarge
                            .copyWith(color: Colors.white),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⚠️', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text('Step 2 of 2: Final Confirmation',
            style: WasiyatiTypography.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Security phrase verified. This will immediately trigger delivery of all of ${widget.ownerName}\'s legacy messages. This action cannot be undone.',
          style: WasiyatiTypography.bodyMedium.copyWith(
            color: WasiyatiColors.warmTaupe,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WasiyatiColors.error.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(WasiyatiRadius.lg),
            border: Border.all(
                color: WasiyatiColors.error.withValues(alpha: 0.2)),
          ),
          child: Text(
            'By confirming, you attest that ${widget.ownerName} has passed away and agree to the responsibility of triggering message delivery on their behalf.',
            style: WasiyatiTypography.bodySmall.copyWith(
              color: WasiyatiColors.error,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                    border: Border.all(color: WasiyatiColors.cardBorder),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: WasiyatiTypography.labelMedium.copyWith(
                        color: WasiyatiColors.warmTaupe,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _isVerifying ? null : _confirm,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: WasiyatiColors.error,
                    borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  ),
                  child: Center(
                    child: _isVerifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Confirm',
                            style: WasiyatiTypography.labelMedium
                                .copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmedState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🕊️', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        Text(
          'Messages Delivered',
          style: WasiyatiTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.ownerName}\'s messages are being delivered to their loved ones. May Allah have mercy on their soul.',
          style: WasiyatiTypography.bodyMedium.copyWith(
            color: WasiyatiColors.warmTaupe,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Text(
          'إِنَّا لِلّهِ وَإِنَّـا إِلَيْهِ رَاجِعُون',
          style: WasiyatiTypography.arabicDisplay,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '"Indeed, to Allah we belong and to Him we shall return."',
          style: WasiyatiTypography.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// WhatsApp Verification Bot Simulator Screen for Non-registered Contacts
class WhatsAppBotSimulatorScreen extends ConsumerStatefulWidget {
  final String ownerId;
  final String ownerName;
  final String contactName;
  final String contactId;

  const WhatsAppBotSimulatorScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
    required this.contactName,
    required this.contactId,
  });

  @override
  ConsumerState<WhatsAppBotSimulatorScreen> createState() =>
      _WhatsAppBotSimulatorScreenState();
}

class _WhatsAppBotSimulatorScreenState
    extends ConsumerState<WhatsAppBotSimulatorScreen> {
  final List<Map<String, dynamic>> _messages = [];
  bool _replied = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Initialize standard WhatsApp Bot conversation messages
    _messages.addAll([
      {
        'isMe': false,
        'text': 'Hello ${widget.contactName}! Wasiyati here. 🤝\n\n${widget.ownerName} has listed you as a Trusted Contact on our secure platform.',
        'time': '10:00 AM',
      },
      {
        'isMe': false,
        'text': '⚠️ ALERT: ${widget.ownerName} has missed their scheduled safety check-in window and is currently unreachable.',
        'time': '10:01 AM',
      },
      {
        'isMe': false,
        'text': 'As a Trusted Contact, can you please confirm:\n\nHas ${widget.ownerName} passed away? 😢\n\nTap [Yes] to initiate delivery of their legacy messages, or [No] if this is a false alarm.',
        'time': '10:01 AM',
      },
    ]);
  }

  Future<void> _handleReply(bool passedAway) async {
    setState(() {
      _replied = true;
      _isProcessing = true;
      _messages.add({
        'isMe': true,
        'text': passedAway
            ? 'Yes, ${widget.ownerName} has passed away. 😢'
            : 'No, ${widget.ownerName} is alive and safe. 💚',
        'time': '10:02 AM',
      });
    });

    // Simulate standard chatbot delay
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      if (passedAway) {
        // 1. Update owner user doc isDeceased = true
        await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).update({
          'isDeceased': true,
          'deceasedConfirmedAt': FieldValue.serverTimestamp(),
        });

        // 2. Set trigger status = confirmed in trigger doc
        await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).collection('settings').doc('trigger').set({
          'status': TriggerStatus.confirmed.name,
          'confirmedAt': DateTime.now().toIso8601String(),
          'confirmedBy': widget.contactId,
        }, SetOptions(merge: true));

        // 3. Mark contact status as accepted since they responded
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.ownerId)
            .collection('trustedContacts')
            .doc(widget.contactId)
            .update({
          'status': TrustedContactStatus.accepted.name,
          'acceptedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() {
            _isProcessing = false;
            _messages.add({
              'isMe': false,
              'text': 'May Allah have mercy on ${widget.ownerName}\'s soul. 🕊️\n\nWe have verified this confirmation. All secure messages and documents in their vault will be delivered to their designated recipients shortly.',
              'time': '10:02 AM',
            });
          });
        }
      } else {
        // False alarm, reset checking deadline to 30 days
        final newDeadline = DateTime.now().add(const Duration(days: 30));

        await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).collection('settings').doc('trigger').set({
          'status': TriggerStatus.watching.name,
          'cancelledAt': DateTime.now().toIso8601String(),
          'checkInDeadline': newDeadline.toIso8601String(),
        }, SetOptions(merge: true));

        await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).update({
          'isDeceased': false,
        });

        if (mounted) {
          setState(() {
            _isProcessing = false;
            _messages.add({
              'isMe': false,
              'text': 'Alhamdulillah! Thank Allah! 💚\n\nWe have cancelled the alert and reset ${widget.ownerName}\'s safety schedule safely. Thank you for your response!',
              'time': '10:02 AM',
            });
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF128C7E),
        elevation: 1,
        leadingWidth: 70,
        leading: Row(
          children: [
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🕊️', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wasiyati Verification Bot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _isProcessing ? 'typing...' : 'online',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'] as String,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg['time'] as String,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.done_all,
                                size: 14,
                                color: Color(0xFF34B7F1),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (!_replied)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CHOOSE AN ANSWER TO SIMULATE THE BOT REPLY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleReply(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WasiyatiColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                          ),
                          child: Text(
                            'Yes, ${widget.ownerName} Passed Away 😢',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleReply(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WasiyatiColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                          ),
                          child: Text(
                            'No, ${widget.ownerName} is Alive 💚',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _messages.last['isMe'] == true
                        ? Icons.hourglass_top_rounded
                        : Icons.check_circle_rounded,
                    color: _messages.last['isMe'] == true
                        ? WasiyatiColors.goldenHour
                        : WasiyatiColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _messages.last['isMe'] == true
                        ? 'Simulating Wasiyati bot response...'
                        : 'Simulation successfully processed!',
                    style: TextStyle(
                      fontFamily: WasiyatiTypography.bodyFont,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WasiyatiColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
