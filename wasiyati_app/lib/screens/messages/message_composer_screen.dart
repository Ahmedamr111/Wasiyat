import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/messages_provider.dart';
import '../../providers/recipients_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/animations/animations.dart';
import '../ai/ai_writing_assistant_screen.dart';

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
  final _milestoneController = TextEditingController();
  DateTime? _selectedOccasionDate;
  String _selectedRecurring = 'Weekly';
  bool _showSeal = false;
  bool _isAutoSaved = false;

  List<MessageRecipient> _selectedRecipients = [];

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
    _selectedOccasionDate = msg?.schedule?.occasionDate;
    _milestoneController.text = msg?.schedule?.milestoneLabel ?? '';
    if (msg?.schedule?.recurringType != null) {
      final rType = msg!.schedule!.recurringType!;
      _selectedRecurring = rType.name[0].toUpperCase() + rType.name.substring(1);
    }
    _selectedRecipients = msg != null ? List.from(msg.recipients) : [];

    // Auto-save simulation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isAutoSaved = true);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _milestoneController.dispose();
    super.dispose();
  }

  Future<void> _saveMessage() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter message content')),
      );
      return;
    }
    if (_selectedRecipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one recipient')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save messages')),
      );
      return;
    }

    setState(() => _showSeal = true);

    try {
      final msgSchedule = MessageSchedule(
        recurringType: _selectedType == MessageType.recurring
            ? (_selectedRecurring == 'Weekly'
                ? RecurringType.weekly
                : _selectedRecurring == 'Monthly'
                    ? RecurringType.monthly
                    : RecurringType.yearly)
            : null,
        occasionDate: _selectedType == MessageType.occasion ? _selectedOccasionDate : null,
        milestoneLabel: _selectedType == MessageType.milestone ? _milestoneController.text.trim() : null,
      );

      final message = MessageModel(
        id: widget.existingMessage?.id ?? '',
        userId: user.id,
        title: _titleController.text.trim(),
        type: _selectedType,
        contentType: ContentType.text,
        contentPlain: _contentController.text.trim(),
        recipients: _selectedRecipients,
        schedule: msgSchedule,
        isDelivered: widget.existingMessage?.isDelivered ?? false,
        createdAt: widget.existingMessage?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.existingMessage == null) {
        await ref.read(messagesProvider.notifier).createMessage(message);
      } else {
        await ref.read(messagesProvider.notifier).updateMessage(message);
      }

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message saved successfully! 🪶'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
        widget.onSaved();
      }
    } catch (e) {
      setState(() => _showSeal = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving message: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    }
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
                  const SizedBox(width: 8),
                  // AI Assistant button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AIWritingAssistantScreen(
                          onBack: () => Navigator.pop(context),
                          onUseContent: (content) {
                            Navigator.pop(context);
                            _contentController.text = content;
                          },
                        ),
                      ),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: WasiyatiColors.goldenHour.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: WasiyatiColors.goldenHour.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Center(
                        child: Text('✨', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                              ..._selectedRecipients.map((mr) {
                                final realRecipientsList = ref.watch(recipientsProvider).valueOrNull ?? [];
                                final r = realRecipientsList.where((rec) => rec.id == mr.recipientId).firstOrNull;
                                if (r == null) return const SizedBox.shrink();
                                return Container(
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: WasiyatiColors.primaryGradient,
                                        ),
                                        child: Center(
                                          child: Text(
                                            r.initials,
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
                                        '${r.name} (${mr.channel.toUpperCase()})',
                                        style: TextStyle(
                                          fontFamily: WasiyatiTypography.bodyFont,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: WasiyatiColors.charcoal,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedRecipients.removeWhere((x) => x.recipientId == mr.recipientId && x.channel == mr.channel);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: WasiyatiColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: _showAddRecipientDialog,
                                child: Container(
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
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedOccasionDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  setState(() => _selectedOccasionDate = date);
                                }
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
                                      _selectedOccasionDate != null
                                          ? '${_selectedOccasionDate!.day}/${_selectedOccasionDate!.month}/${_selectedOccasionDate!.year}'
                                          : 'Select date...',
                                      style: WasiyatiTypography.bodyMedium
                                          .copyWith(
                                        color: _selectedOccasionDate != null
                                            ? WasiyatiColors.charcoal
                                            : WasiyatiColors.muted,
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
                              controller: _milestoneController,
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

  void _showAddRecipientDialog() {
    final realRecipientsList = ref.read(recipientsProvider).valueOrNull ?? [];
    if (realRecipientsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add recipients first under the "People" tab!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Recipient & Channel'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: realRecipientsList.length,
            itemBuilder: (context, index) {
              final r = realRecipientsList[index];
              final channels = r.availableChannels;
              
              if (channels.isEmpty) {
                return ListTile(
                  title: Text(r.name),
                  subtitle: const Text('No contact channels added yet', style: TextStyle(color: WasiyatiColors.error)),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(r.name, style: WasiyatiTypography.labelMedium),
                  ),
                  ...channels.map((chan) {
                    final isAlreadySelected = _selectedRecipients.any(
                        (x) => x.recipientId == r.id && x.channel == chan);
                    
                    String channelIcon = '📧';
                    if (chan == 'whatsapp') channelIcon = '💬';
                    if (chan == 'sms') channelIcon = '📱';

                    return ListTile(
                      leading: Text(channelIcon),
                      title: Text(chan.toUpperCase()),
                      trailing: isAlreadySelected 
                        ? const Icon(Icons.check_circle, color: WasiyatiColors.success)
                        : const Icon(Icons.circle_outlined),
                      onTap: () {
                        setState(() {
                          if (isAlreadySelected) {
                            _selectedRecipients.removeWhere(
                                (x) => x.recipientId == r.id && x.channel == chan);
                          } else {
                            // Add recipient with channel
                            _selectedRecipients.add(MessageRecipient(
                              recipientId: r.id,
                              channel: chan,
                            ));
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  }),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
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
