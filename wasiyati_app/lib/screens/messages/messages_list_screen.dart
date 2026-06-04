import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../providers/messages_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';
import 'message_detail_screen.dart';
import 'message_composer_screen.dart';

/// Messages list screen — all messages with filter tabs
class MessagesListScreen extends ConsumerStatefulWidget {
  final VoidCallback onNewMessage;
  final Function(String) onViewMessage;

  const MessagesListScreen({
    super.key,
    required this.onNewMessage,
    required this.onViewMessage,
  });

  @override
  ConsumerState<MessagesListScreen> createState() =>
      _MessagesListScreenState();
}

class _MessagesListScreenState extends ConsumerState<MessagesListScreen> {
  String _activeFilter = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openMessage(BuildContext context, MessageModel msg) {
    // If PIN-locked, show PIN screen first (future: wire PinLockScreen here)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageDetailScreen(
          message: msg,
          onBack: () => Navigator.pop(context),
          onEdit: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageComposerScreen(
                  existingMessage: msg,
                  onBack: () => Navigator.pop(context),
                  onSaved: () => Navigator.pop(context),
                ),
              ),
            );
          },
          onDeleted: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);
    final filters = ['All', 'Immediate', 'Recurring', 'Occasion', 'Milestone'];

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onNewMessage,
        backgroundColor: WasiyatiColors.deepRose,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Message',
          style: TextStyle(
            fontFamily: WasiyatiTypography.bodyFont,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Text('Messages', style: WasiyatiTypography.displaySmall),
            ),
            const SizedBox(height: 16),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: WasiyatiSearchInput(
                hint: 'Search messages...',
                controller: _searchController,
              ),
            ),
            const SizedBox(height: 16),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: filters.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: WasiyatiChipButton(
                      label: f,
                      isActive: _activeFilter == f,
                      onTap: () => setState(() => _activeFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Messages list
            Expanded(
              child: messages.when(
                data: (msgs) {
                  var filtered = msgs;
                  if (_activeFilter != 'All') {
                    final type = MessageType.values.firstWhere(
                      (t) => t.name == _activeFilter.toLowerCase(),
                      orElse: () => MessageType.immediate,
                    );
                    filtered = msgs.where((m) => m.type == type).toList();
                  }

                  // Search filter
                  final q = _searchController.text.toLowerCase();
                  if (q.isNotEmpty) {
                    filtered = filtered
                        .where((m) => m.title.toLowerCase().contains(q))
                        .toList();
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📭',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: WasiyatiTypography.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start writing your legacy.',
                            style: WasiyatiTypography.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          WasiyatiButton(
                            label: '+ New Message',
                            onPressed: widget.onNewMessage,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final msg = filtered[index];
                      return _MessageTile(
                        message: msg,
                        onTap: () => _openMessage(context, msg),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: WasiyatiColors.softAmber,
                  ),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onTap;

  const _MessageTile({required this.message, required this.onTap});

  String get _icon {
    switch (message.type) {
      case MessageType.immediate:
        return '✉️';
      case MessageType.recurring:
        return '🌿';
      case MessageType.occasion:
        return '🎂';
      case MessageType.milestone:
        return '🎓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
          border: Border.all(color: WasiyatiColors.cardBorder),
          boxShadow: WasiyatiColors.cardShadow,
        ),
        child: Row(
          children: [
            Text(_icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.title,
                    style: WasiyatiTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.typeLabel} · ${message.recipients.length} recipients · ${message.contentTypeIcon}',
                    style: WasiyatiTypography.caption,
                  ),
                ],
              ),
            ),
            if (message.isPinLocked)
              const Icon(
                Icons.lock_rounded,
                size: 16,
                color: WasiyatiColors.muted,
              ),
            const SizedBox(width: 4),
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
