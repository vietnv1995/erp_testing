import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/orders/SaleOrder.dart';
import '../../../models/orders/SaleOrderItem.dart';
import '../controllers/SaleOrderController.dart';
import 'SaleOrderCreateScreen.dart';

class SaleOrderManagementScreen extends StatelessWidget {
  // Khởi tạo controller
  final SaleOrderController controller = Get.put(SaleOrderController());


  @override
  Widget build(BuildContext context) {
    controller.fetchSaleOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sale Orders Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(SaleOrderCreateScreen()); // Chuyển sang màn hình tạo đơn hàng
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.saleOrders.length,
          itemBuilder: (context, index) {
            SaleOrder order = controller.saleOrders[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(order.customerName),
                subtitle: Text('Status: ${order.status}'),
                trailing: Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                onTap: () {
                  Get.to(SaleOrderDetailScreen(order: order)); // Chuyển sang màn hình chi tiết đơn hàng
                },
              ),
            );
          },
        );
      }),
    );
  }
}

class SaleOrderDetailScreen extends StatelessWidget {
  final SaleOrder order;

  SaleOrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Order Date: ${order.orderDate.toLocal()}'),
            SizedBox(height: 8),
            Text('Status: ${order.status}'),
            SizedBox(height: 8),
            Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text('Order Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  SaleOrderLine item = order.items[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('Product ID: ${item.productId}'),
                      subtitle: Text('Quantity: ${item.quantity} | Price: \$${item.price.toStringAsFixed(2)}'),
                      trailing: Text('Total: \$${item.totalAmount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
