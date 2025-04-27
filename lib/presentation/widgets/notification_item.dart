import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // ✅ Added import for DateFormat
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/notification.dart' as AppModel; // ✅ Aliased import

class NotificationItem extends StatefulWidget {
  final AppModel.AppNotification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> with SingleTickerProviderStateMixin {
  late AnimationController _readAnimationController;
  late AppModel.AppNotification notification; // ✅ Created a local mutable copy

  @override
  void initState() {
    super.initState();
    notification = widget.notification; // ✅ Assigning the initial notification
    _readAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (notification.isRead) {
      _readAnimationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _readAnimationController.dispose();
    super.dispose();
  }

  void _markAsRead() async {
    try {
      await HapticFeedback.lightImpact();
      setState(() {
        notification = notification.copyWith(isRead: true); // ✅ Correct way to update state
        _readAnimationController.forward();
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _markAsRead,
      child: AnimatedBuilder(
        animation: _readAnimationController,
        builder: (context, child) {
          final backgroundColor = notification.isRead
              ? AppTheme.darkTheme.scaffoldBackgroundColor
              : AppTheme.darkTheme.primaryColor.withAlpha(255);
          final textColor = notification.isRead
              ? AppTheme.darkTheme.textTheme.bodyMedium!.color
              : AppTheme.darkTheme.primaryColor;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat.jm().format(notification.timestamp),
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(255),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
