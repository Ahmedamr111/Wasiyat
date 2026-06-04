import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Notification & Activity Center
class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationsScreen({super.key, required this.onBack});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifItem> _notifications = [
    _NotifItem(
      icon: '⏰',
      title: 'Check-in reminder',
      body: 'Your monthly check-in is due in 3 days. Tap to confirm you\'re alright.',
      time: '2 hours ago',
      isRead: false,
      type: _NotifType.checkin,
    ),
    _NotifItem(
      icon: '🤝',
      title: 'Trusted contact accepted',
      body: 'Amine Benali has accepted your trusted contact invitation.',
      time: 'Yesterday',
      isRead: false,
      type: _NotifType.trustedContact,
    ),
    _NotifItem(
      icon: '📝',
      title: 'Message auto-saved',
      body: '"A letter to my children" was automatically saved.',
      time: '2 days ago',
      isRead: true,
      type: _NotifType.message,
    ),
    _NotifItem(
      icon: '🔐',
      title: 'Security update',
      body: 'Your vault has been re-encrypted with a new key.',
      time: '3 days ago',
      isRead: true,
      type: _NotifType.security,
    ),
    _NotifItem(
      icon: '✨',
      title: 'Welcome to Wasiyati',
      body: 'Start by writing your first message to someone you love.',
      time: '1 week ago',
      isRead: true,
      type: _NotifType.system,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
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
        title: Text('Notifications', style: WasiyatiTypography.headlineSmall),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontFamily: WasiyatiTypography.bodyFont,
                  fontSize: 13,
                  color: WasiyatiColors.deepRose,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              separatorBuilder: (_, i) =>
                  Divider(color: WasiyatiColors.divider, height: 1),
              itemBuilder: (context, index) {
                final n = _notifications[index];
                return _NotifTile(
                  item: n,
                  onTap: () => setState(() => n.isRead = true),
                  onDismiss: () => setState(() => _notifications.removeAt(index)),
                );
              },
            ),
    );
  }
}

enum _NotifType { checkin, trustedContact, message, security, system }

class _NotifItem {
  final String icon;
  final String title;
  final String body;
  final String time;
  bool isRead;
  final _NotifType type;

  _NotifItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}

class _NotifTile extends StatelessWidget {
  final _NotifItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotifTile({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  Color get _iconBg {
    switch (item.type) {
      case _NotifType.checkin:
        return WasiyatiColors.softAmber.withValues(alpha: 0.15);
      case _NotifType.trustedContact:
        return WasiyatiColors.success.withValues(alpha: 0.12);
      case _NotifType.message:
        return WasiyatiColors.deepRose.withValues(alpha: 0.1);
      case _NotifType.security:
        return WasiyatiColors.charcoal.withValues(alpha: 0.08);
      case _NotifType.system:
        return WasiyatiColors.goldenHour.withValues(alpha: 0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.title + item.time),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        color: WasiyatiColors.error.withValues(alpha: 0.1),
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline_rounded,
            color: WasiyatiColors.error),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: item.isRead
              ? Colors.transparent
              : WasiyatiColors.deepRose.withValues(alpha: 0.03),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread dot
              Column(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isRead
                          ? Colors.transparent
                          : WasiyatiColors.deepRose,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                ),
                child: Center(
                  child: Text(item.icon,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: WasiyatiTypography.labelMedium.copyWith(
                              color: item.isRead
                                  ? WasiyatiColors.warmTaupe
                                  : WasiyatiColors.charcoal,
                            ),
                          ),
                        ),
                        Text(item.time, style: WasiyatiTypography.caption),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: WasiyatiTypography.bodySmall.copyWith(
                        height: 1.4,
                        color: item.isRead
                            ? WasiyatiColors.muted
                            : WasiyatiColors.warmTaupe,
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text('No notifications', style: WasiyatiTypography.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up.',
            style: WasiyatiTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
