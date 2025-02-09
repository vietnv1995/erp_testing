// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
      id: (json['id'] as num?)?.toInt(),
      productName: json['product_name'] as String,
      sku: json['sku'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      costPrice: (json['cost_price'] as num).toDouble(),
      salePrice: (json['sale_price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'sku': instance.sku,
      'quantity': instance.quantity,
      'cost_price': instance.costPrice,
      'sale_price': instance.salePrice,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
