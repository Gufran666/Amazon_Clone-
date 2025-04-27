import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/order.dart';

import '../widgets/order_history_item.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with TickerProviderStateMixin {
  late TextEditingController _searchController;
  List<Order> orders = [
    Order(
      id: 'ORD-2023-0001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: 149.99,
      status: 'delivered',
      items: [
        OrderItem(productId: 'P101', quantity: 1),
        OrderItem(productId: 'P102', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0002',
      date: DateTime.now().subtract(const Duration(days: 5)),
      totalAmount: 99.99,
      status: 'shipped',
      items: [
        OrderItem(productId: 'P103', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0003',
      date: DateTime.now().subtract(const Duration(days: 10)),
      totalAmount: 249.99,
      status: 'pending',
      items: [
        OrderItem(productId: 'P104', quantity: 1),
        OrderItem(productId: 'P105', quantity: 2),
      ],
    ),
  ];
  List<String> filterOptions = ['All', 'Pending', 'Shipped', 'Delivered'];
  String selectedFilter = 'All';
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Order> getFilteredOrders() {
    if (selectedDateRange != null) {
      return orders.where((order) {
        return order.date.isAfter(selectedDateRange!.start) &&
            order.date.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    } else if (selectedFilter != 'All') {
      return orders.where((order) => order.status == selectedFilter.toLowerCase()).toList();
    }
    return orders;
  }

  void _showDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
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
            'Order History',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: _showFilterOptions,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterRow(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: getFilteredOrders().length,
                  itemBuilder: (context, index) {
                    final order = getFilteredOrders()[index];
                    return OrderHistoryItem(
                      order: order,
                      onExpand: () {
                        HapticFeedback.lightImpact();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search orders',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(127),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.primaryColor,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
      ),
      onChanged: (value) {
        // Implement search logic
      },
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        DropdownButton<String>(
          value: selectedFilter,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          ),
          underline: Container(
            height: 2,
            color: AppTheme.darkTheme.primaryColor,
          ),
          onChanged: (String? value) {
            setState(() {
              selectedFilter = value!;
              selectedDateRange = null;
            });
          },
          items: filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.date_range),
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          onPressed: _showDatePicker,
        ),
      ],
    );
  }

  void _showFilterOptions() {
    setState(() {
      if (selectedFilter == 'All') {
        selectedFilter = filterOptions[1];
      } else {
        selectedFilter = 'All';
      }
    });
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3, // Set to 3 since this is the Orders screen
      selectedItemColor: Colors.white,
      unselectedItemColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0: Navigator.pushNamed(context, '/home'); break;
          case 1: Navigator.pushNamed(context, '/search'); break;
          case 2: Navigator.pushNamed(context, '/cart'); break;
          case 3: Navigator.pushNamed(context, '/orders'); break;
          case 4: Navigator.pushNamed(context, '/profile'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}