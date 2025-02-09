import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../mysql_manager.dart';

class SalesOrderApi {
  final MySQLManager mysqlManager;

  SalesOrderApi(this.mysqlManager);


  Router get router {
    final router = Router();

    // API to get all users
    router.get('/get', (Request request) async {
      final results = await mysqlManager.connection.query('''
      SELECT 
        so.id AS sale_order_id,
        so.customer_name,
        so.order_date,
        so.status,
        so.total_amount AS sale_order_total,
        soi.id AS sale_order_item_id,
        soi.quantity AS item_quantity,
        soi.price AS item_price,
        soi.total_amount AS item_total_amount,
        soi.product_id,
        soi.created_at,
        soi.updated_at,
        inv.product_name,
        inv.sku,
        inv.cost_price,
        inv.sale_price,
        so.created_at as so_created_at,
        so.updated_at as so_updated_at
      FROM sales_order so
      JOIN sales_order_line soi ON so.id = soi.sales_order_id
      JOIN inventory inv ON soi.product_id = inv.id
    ''');
      // final users = results.map((row) {
      //   var fields = Map<String, dynamic>.from(row.fields);
      //   if (fields['order_date'] is DateTime) {
      //     fields['order_date'] = (fields['order_date'] as DateTime).toIso8601String();
      //   }
      //   if (fields['created_at'] is DateTime) {
      //     fields['created_at'] = (fields['created_at'] as DateTime).toIso8601String();
      //   }
      //   if (fields['updated_at'] is DateTime) {
      //     fields['updated_at'] = (fields['updated_at'] as DateTime).toIso8601String();
      //   }
      //
      //   return fields;
      // }).toList();

      Map<int, Map<String, dynamic>> saleOrders = {};

      for (var row in results) {
        int saleOrderId = row['sale_order_id'];

        if (!saleOrders.containsKey(saleOrderId)) {
          saleOrders[saleOrderId] = {
            "id": saleOrderId,
            "customer_name": row['customer_name'],
            "order_date": row['order_date'].toIso8601String(),
            "status": row['status'],
            "total_amount": row['sale_order_total'],
            "items": [],
            "created_at": (row["so_created_at"] as DateTime).toIso8601String(),
            "updated_at": (row["so_created_at"] as DateTime).toIso8601String(),
          };
        }

        (saleOrders[saleOrderId]!["items"] as List).add({
          "id": row['sale_order_item_id'],
          "sales_order_id": row['sale_order_id'],
          "product_id": row["product_id"],
          "quantity": row['item_quantity'],
          "price": row['item_price'],
          "total_amount": row['item_total_amount'],
          "product_name": row['product_name'],
          "sku": row['sku'],
          "cost_price": row['cost_price'],
          "sale_price": row['sale_price'],
          "created_at": (row["created_at"] as DateTime).toIso8601String(),
          "updated_at": (row["updated_at"] as DateTime).toIso8601String(),
        });
      }
      return Response.ok(jsonEncode(saleOrders.values.toList()));
    });

    router.post('/create', (Request request) async {
      // try {
      //   // Bắt đầu transaction
      //   await mysqlManager.connection.query('START TRANSACTION');
      //
      //   // Parse dữ liệu từ request
      //   final body = await request.readAsString();
      //   final data = jsonDecode(body);
      //
      //   final String customerName = data['customer_name'];
      //   final String status = data['status'];
      //   final double totalAmount = data['total_amount'];
      //   final List<Map<String, dynamic>> saleOrderItems = List<Map<String, dynamic>>.from(data['items']);
      //
      //   // Kiểm tra số lượng sản phẩm trong kho trước khi tạo đơn hàng
      //   for (var item in saleOrderItems) {
      //     final int productId = item['product_id'];
      //     final int requestedQuantity = item['quantity'];
      //
      //     // Kiểm tra số lượng trong inventory
      //     var results = await mysqlManager.connection.query(
      //       'SELECT quantity FROM inventory WHERE id = ? FOR UPDATE',
      //       [productId],
      //     );
      //
      //     if (results.isEmpty) {
      //       return Response.badRequest(body: 'Product not found in inventory');
      //     }
      //
      //     var inventoryItem = results.first;
      //     int availableQuantity = inventoryItem['quantity'];
      //
      //     if (availableQuantity < requestedQuantity) {
      //       return Response.badRequest(body: 'Insufficient stock for product $productId');
      //     }
      //   }
      //
      //   // Insert vào bảng sale_orders
      //   final result = await mysqlManager.connection.query(
      //     'INSERT INTO sale_orders (customer_name, status, total_amount) VALUES (?, ?, ?)',
      //     [customerName, status, totalAmount],
      //   );
      //
      //   // Lấy id của sale_order vừa tạo
      //   final saleOrderId = result.insertId;
      //
      //   // Insert vào bảng sale_order_items cho mỗi item
      //   for (var item in saleOrderItems) {
      //     await mysqlManager.connection.query(
      //       'INSERT INTO sale_order_items (sale_order_id, product_id, quantity, price, total_amount) VALUES (?, ?, ?, ?, ?)',
      //       [
      //         saleOrderId,
      //         item['product_id'],
      //         item['quantity'],
      //         item['price'],
      //         item['total_amount'],
      //       ],
      //     );
      //   }
      //
      //   // Commit transaction nếu không có lỗi
      //   await mysqlManager.connection.query('COMMIT');
      //
      //   // Trả về response thành công
      //   return Response.ok(jsonEncode({'status': 'success', 'sale_order_id': saleOrderId}));
      // } catch (e) {
      //   // Nếu có lỗi, rollback lại transaction
      //   await mysqlManager.connection.query('ROLLBACK');
      //
      //   // Trả về response lỗi
      //   return Response.internalServerError(body: 'Failed to create sale order: $e');
      // }
      // Bắt đầu transaction
      await mysqlManager.connection.query('START TRANSACTION');

      // Parse dữ liệu từ request
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String customerName = data['customer_name'];
      final String status = data['status'];
      final double totalAmount = data['total_amount'];
      final List<Map<String, dynamic>> saleOrderItems = List<Map<String, dynamic>>.from(data['items']);

      // Kiểm tra số lượng sản phẩm trong kho trước khi tạo đơn hàng
      for (var item in saleOrderItems) {
        final int productId = item['product_id'];
        final int requestedQuantity = item['quantity'];

        // Kiểm tra số lượng trong inventory
        var results = await mysqlManager.connection.query(
          'SELECT quantity FROM inventory WHERE id = ? FOR UPDATE',
          [productId],
        );

        if (results.isEmpty) {
          return Response.badRequest(body: 'Product not found in inventory');
        }

        var inventoryItem = results.first;
        int availableQuantity = inventoryItem['quantity'];

        if (availableQuantity < requestedQuantity) {
          return Response.badRequest(body: 'Insufficient stock for product $productId');
        }
      }

      // Insert vào bảng sale_orders
      final result = await mysqlManager.connection.query(
        'INSERT INTO sales_order (customer_name, status, total_amount) VALUES (?, ?, ?)',
        [customerName, status, totalAmount],
      );

      // Lấy id của sale_order vừa tạo
      final saleOrderId = result.insertId;

      // Insert vào bảng sale_order_items cho mỗi item
      for (var item in saleOrderItems) {
        await mysqlManager.connection.query(
          'INSERT INTO sales_order_line (sales_order_id, product_id, quantity, price, total_amount) VALUES (?, ?, ?, ?, ?)',
          [
            saleOrderId,
            item['product_id'],
            item['quantity'],
            item['price'],
            item['total_amount'],
          ],
        );
      }

      // Commit transaction nếu không có lỗi
      await mysqlManager.connection.query('COMMIT');

      // Trả về response thành công
      return Response.ok(jsonEncode({'status': 'success', 'sale_order_id': saleOrderId}));
    });

    return router;
  }
}