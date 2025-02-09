import 'package:erp_test/client/models/inventory/Inventory.dart';
import 'package:json_annotation/json_annotation.dart';

class SaleOrderLine {
  final int id;

  @JsonKey(name: 'sales_order_id')
  final int salesOrderId;

  @JsonKey(name: 'product_id')
  final int productId;


  final Inventory? product;

  final int quantity;
  final double price;

  @JsonKey(name: 'total_amount')
  final double totalAmount;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  SaleOrderLine({
    this.product,
    required this.id,
    required this.salesOrderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  // Phương thức tạo SaleOrderLine từ Map (JSON)
  factory SaleOrderLine.fromJson(Map<String, dynamic> json) {
    return SaleOrderLine(
      id: json['id'],
      salesOrderId: json['sales_order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      totalAmount: json['total_amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Phương thức chuyển SaleOrderLine thành Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sales_order_id': salesOrderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
