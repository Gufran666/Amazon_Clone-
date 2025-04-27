import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
class NotificationBell extends StatefulWidget {
  final int unreadNotifications;
  final VoidCallback onNotificationPressed;

  const NotificationBell({
    super.key,
    required this.unreadNotifications,
    required this.onNotificationPressed,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> with SingleTickerProviderStateMixin {
  late AnimationController _badgeController;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: Curves.elasticOut,
      ),
    );
    if (widget.unreadNotifications > 0) {
      _badgeController.forward();
    }
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.unreadNotifications != oldWidget.unreadNotifications) {
      if (widget.unreadNotifications > 0) {
        _badgeController.forward();
      } else {
        _badgeController.reverse();
      }
    }
  }

  void _handleNotificationPress() async {
    try {
      await HapticFeedback.lightImpact();
      widget.onNotificationPressed();
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _handleNotificationPress,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(
              Icons.notifications,
              color: _isHovering
                  ? AppTheme.darkTheme.primaryColor
                  : AppTheme.darkTheme.iconTheme.color,
              size: 28,
            ),
            if (widget.unreadNotifications > 0)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withAlpha(128),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.unreadNotifications.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}