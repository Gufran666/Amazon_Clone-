
class Order {
  final String id;
  final DateTime date;
  final double totalAmount;
  final String status;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.items,
});
}

class OrderItem {
  final String productId;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.quantity,
});
}
