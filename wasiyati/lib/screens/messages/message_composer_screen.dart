import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../data/mock_data.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/animations/animations.dart';

/// Full-screen immersive message composer
class MessageComposerScreen extends ConsumerStatefulWidget {
  final MessageModel? existingMessage;
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const MessageComposerScreen({
    super.key,
    this.existingMessage,
    required this.onBack,
    required this.onSaved,
  });

  @override
  ConsumerState<MessageComposerScreen> createState() =>
      _MessageComposerScreenState();
}

class _MessageComposerScreenState
    extends ConsumerState<MessageComposerScreen> {
  late MessageType _selectedType;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedRecurring = 'Weekly';
  bool _showSeal = false;
  bool _isAutoSaved = false;

  final _recipients = <_SelectedRecipient>[
    _SelectedRecipient(id: 'rec_001', name: 'Sara', initial: 'S'),
    _SelectedRecipient(id: 'rec_002', name: 'Khalid', initial: 'K'),
  ];

  @override
  void initState() {
    super.initState();
    final msg = widget.existingMessage;
    _selectedType = msg?.type ?? MessageType.immediate;
    _titleController = TextEditingController(text: msg?.title ?? '');
    _contentController = TextEditingController(
      text: msg?.contentPlain ??
          'My dearest children,\n\nBy the time you read this, I will have returned to my Lord. Know that every moment I spent with you was the greatest blessing of my life...',
    );

    // Auto-save simulation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isAutoSaved = true);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveMessage() {
    setState(() => _showSeal = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onSaved();
    });
  }

  @override
  Widget build(BuildContext context) {
    final types = MessageType.values;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: WasiyatiColors.divider),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: WasiyatiColors.warmTaupe.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                        color: WasiyatiColors.charcoal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.existingMessage != null
                          ? 'Edit Message'
                          : 'New Message',
                      style: WasiyatiTypography.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _saveMessage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: WasiyatiColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Save 🪶',
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Type selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: types.map((type) {
                    final label = _typeLabel(type);
                    final isActive = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: WasiyatiChipButton(
                        label: label,
                        isActive: isActive,
                        onTap: () => setState(() => _selectedType = type),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Editor body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _titleController,
                        style: WasiyatiTypography.headlineSmall,
                        cursorColor: WasiyatiColors.softAmber,
                        decoration: InputDecoration(
                          hintText: 'Message title (private)...',
                          hintStyle: WasiyatiTypography.editorPlaceholder
                              .copyWith(fontSize: 20),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Parchment editor
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      constraints: const BoxConstraints(minHeight: 220),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: WasiyatiColors.parchmentGradient,
                              borderRadius: BorderRadius.circular(
                                WasiyatiRadius.xl,
                              ),
                              border: Border.all(
                                color: WasiyatiColors.softAmber
                                    .withValues(alpha: 0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: WasiyatiColors.warmTaupe
                                      .withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            // Line pattern overlay
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                WasiyatiRadius.xl,
                              ),
                              backgroundBlendMode: BlendMode.darken,
                            ),
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              style: WasiyatiTypography.editorContent,
                              cursorColor: WasiyatiColors.softAmber,
                              decoration: InputDecoration(
                                hintText:
                                    'Write your message here...\n\nLet your heart speak.',
                                hintStyle: WasiyatiTypography.editorPlaceholder,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),

                          // Wax seal
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: WaxSealAnimation(
                              isVisible: _showSeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recipients
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SEND TO',
                            style: WasiyatiTypography.overline,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._recipients.map((r) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: WasiyatiColors.softAmber
                                            .withValues(alpha: 0.3),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: WasiyatiColors
                                                .primaryGradient,
                                          ),
                                          child: Center(
                                            child: Text(
                                              r.initial,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          r.name,
                                          style: TextStyle(
                                            fontFamily:
                                                WasiyatiTypography.bodyFont,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: WasiyatiColors.charcoal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: WasiyatiColors.warmTaupe
                                      .withValues(alpha: 0.07),
                                  border: Border.all(
                                    color: WasiyatiColors.warmTaupe
                                        .withValues(alpha: 0.25),
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '+ Add',
                                  style: TextStyle(
                                    fontFamily: WasiyatiTypography.bodyFont,
                                    fontSize: 12,
                                    color: WasiyatiColors.warmTaupe,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recurring options
                    if (_selectedType == MessageType.recurring)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SEND EVERY',
                              style: WasiyatiTypography.overline,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: ['Weekly', 'Monthly', 'Yearly']
                                  .map((f) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: WasiyatiChipButton(
                                          label: f,
                                          isActive:
                                              f == _selectedRecurring,
                                          onTap: () => setState(
                                              () => _selectedRecurring = f),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),

                    // Occasion date picker
                    if (_selectedType == MessageType.occasion)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OCCASION DATE',
                              style: WasiyatiTypography.overline,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    WasiyatiRadius.md,
                                  ),
                                  border: Border.all(
                                    color: WasiyatiColors.cardBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Text('📅',
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Select date...',
                                      style: WasiyatiTypography.bodyMedium
                                          .copyWith(
                                        color: WasiyatiColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Milestone label
                    if (_selectedType == MessageType.milestone)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MILESTONE',
                              style: WasiyatiTypography.overline,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              style: WasiyatiTypography.bodyMedium,
                              cursorColor: WasiyatiColors.softAmber,
                              decoration: InputDecoration(
                                hintText:
                                    'e.g., When my child graduates...',
                                hintStyle: WasiyatiTypography.bodyMedium
                                    .copyWith(
                                  color: WasiyatiColors.muted,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: WasiyatiColors.inputBorder,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Media bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: WasiyatiColors.warmTaupe.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _MediaButton(icon: '🎙️', onTap: () {}),
                  const SizedBox(width: 10),
                  _MediaButton(icon: '📷', onTap: () {}),
                  const SizedBox(width: 10),
                  _MediaButton(
                    icon: '🎥',
                    isPremium: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _MediaButton(icon: '📎', onTap: () {}),
                  const Spacer(),
                  if (_isAutoSaved)
                    Row(
                      children: [
                        const PulseGlow(
                          color: Color(0xFF7DB87D),
                          size: 6,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Auto-saved',
                          style: WasiyatiTypography.caption,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(MessageType type) {
    switch (type) {
      case MessageType.immediate:
        return 'Immediate';
      case MessageType.recurring:
        return 'Recurring';
      case MessageType.occasion:
        return 'Occasion';
      case MessageType.milestone:
        return 'Milestone';
    }
  }
}

class _SelectedRecipient {
  final String id;
  final String name;
  final String initial;

  const _SelectedRecipient({
    required this.id,
    required this.name,
    required this.initial,
  });
}

class _MediaButton extends StatelessWidget {
  final String icon;
  final bool isPremium;
  final VoidCallback? onTap;

  const _MediaButton({
    required this.icon,
    this.isPremium = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WasiyatiColors.warmTaupe.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Opacity(
                opacity: isPremium ? 0.5 : 1.0,
                child: Text(icon, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
          if (isPremium)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: WasiyatiColors.goldenHour,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('👑', style: TextStyle(fontSize: 8)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
