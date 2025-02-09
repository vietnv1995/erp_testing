import 'package:json_annotation/json_annotation.dart';

part 'Inventory.g.dart';

@JsonSerializable()
class Inventory {
  int? id;

  @JsonKey(name: 'product_name')
  String productName;

  @JsonKey(name: 'sku')
  String sku;

  int quantity;

  @JsonKey(name: 'cost_price')
  double costPrice;

  @JsonKey(name: 'sale_price')
  double salePrice;

  @JsonKey(name: 'image_url')
  String? imageUrl;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Inventory({
    this.id,
    required this.productName,
    required this.sku,
    this.quantity = 0,
    required this.costPrice,
    required this.salePrice,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
