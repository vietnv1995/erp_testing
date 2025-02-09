import 'SaleOrderItem.dart';

class SaleOrder {
  final int id;
  final String customerName;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SaleOrderLine> items;

  SaleOrder({
    required this.id,
    required this.customerName,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  // Phương thức tạo SaleOrder từ Map (JSON)
  factory SaleOrder.fromJson(Map<String, dynamic> json) {
    var items = (json['items'] as List)
        .map((item) => SaleOrderLine.fromJson(item))
        .toList();

    return SaleOrder(
      id: json['id'],
      customerName: json['customer_name'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      totalAmount: json['total_amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: items,
    );
  }

  // Phương thức chuyển SaleOrder thành Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
