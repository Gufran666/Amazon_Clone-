import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/notification.dart' as AppModel; // Aliased Import
import 'package:amazon_clone/presentation/widgets/notification_item.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;
  List<AppModel.AppNotification> notifications = [
    AppModel.AppNotification(
      id: '1',
      title: 'Order Shipped',
      body: 'Your order #ORD-2023-0001 has been shipped',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppModel.AppNotification(
      id: '2',
      title: 'Order Delivered',
      body: 'Your order #ORD-2023-0002 has been delivered',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppModel.AppNotification(
      id: '3',
      title: 'New Product Alert',
      body: 'Check out our newest product arrivals',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    AppModel.AppNotification(
      id: '4',
      title: 'Promotion Available',
      body: 'Get 20% off your next purchase',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotifications() async {
    try {
      _refreshController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        notifications = [
          AppModel.AppNotification(
            id: '1',
            title: 'Order Shipped',
            body: 'Your order #ORD-2023-0001 has been shipped',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: false,
          ),
          AppModel.AppNotification(
            id: '2',
            title: 'Order Delivered',
            body: 'Your order #ORD-2023-0002 has been delivered',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isRead: true,
          ),
          AppModel.AppNotification(
            id: '3',
            title: 'New Product Alert',
            body: 'Check out our newest product arrivals',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isRead: false,
          ),
          AppModel.AppNotification(
            id: '4',
            title: 'Promotion Available',
            body: 'Get 20% off your next purchase',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isRead: false,
          ),
        ];
      });
    } finally {
      _refreshController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshNotifications,
          displacement: 20,
          backgroundColor: AppTheme.darkTheme.primaryColor,
          color: Colors.white,
          strokeWidth: 2,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: _buildNotificationGroups(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNotificationGroups() {
    final groupedNotifications = <String, List<AppModel.AppNotification>>{};
    final formatter = DateFormat.yMMMMd();

    for (final notification in notifications) {
      final dateKey = formatter.format(notification.timestamp);
      if (!groupedNotifications.containsKey(dateKey)) {
        groupedNotifications[dateKey] = [];
      }
      groupedNotifications[dateKey]!.add(notification);
    }

    return groupedNotifications.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.key,
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppTheme.darkTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...entry.value.map((notification) => NotificationItem(notification: notification)).toList(),
        ],
      );
    }).toList();
  }
}
