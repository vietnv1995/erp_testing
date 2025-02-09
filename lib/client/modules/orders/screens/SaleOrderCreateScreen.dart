import 'package:erp_test/client/managers/orders/SaleOrderManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/inventory/Inventory.dart';
import '../../../models/orders/SaleOrder.dart';
import '../../../models/orders/SaleOrderItem.dart';
import '../../inventory/controllers/InventoryController.dart';
import '../controllers/SaleOrderController.dart';

class SaleOrderCreateScreen extends StatefulWidget {
  @override
  _SaleOrderCreateScreenState createState() => _SaleOrderCreateScreenState();
}

class _SaleOrderCreateScreenState extends State<SaleOrderCreateScreen> {
  final SaleOrderController controller = Get.find();
  final InventoryController inventoryController = Get.put(InventoryController()); // Lấy InventoryController

  final _formKey = GlobalKey<FormState>();
  final TextEditingController customerNameController = TextEditingController();
  // final TextEditingController statusController = TextEditingController();
  // final TextEditingController orderDateController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();

  final List<SaleOrderLine> orderItems = [];
  Inventory? selectedProduct;

  // Biến lưu trạng thái đã chọn
  String? _orderStatus = 'Pending';

  // Danh sách trạng thái
  final List<String> _statuses = ['Pending', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Sale Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Order Status"),
                    SizedBox(width: 16,),
                    DropdownButton<String>(
                      value: _orderStatus,
                      items: _statuses.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _orderStatus = newValue;
                        });
                      },
                    ),
                  ],
                ),
                // TextFormField(
                //   controller: orderDateController,
                //   decoration: InputDecoration(labelText: 'Order Date (YYYY-MM-DD)'),
                //   keyboardType: TextInputType.datetime,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter order date';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 16),
                Text('Order Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),

                // Dropdown cho phép chọn sản phẩm từ inventory
                Obx(() {
                  if (inventoryController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return DropdownButton<Inventory>(
                    value: selectedProduct,
                    hint: Text('Select Product'),
                    onChanged: (Inventory? product) {
                      setState(() {
                        selectedProduct = product;
                      });
                    },
                    items: inventoryController.listProducts.map((Inventory product) {
                      return DropdownMenuItem<Inventory>(
                        value: product,
                        child: Text(product.productName),
                      );
                    }).toList(),
                  );
                }),

                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),

                ElevatedButton(
                  onPressed: () {
                    if (selectedProduct != null &&
                        quantityController.text.isNotEmpty) {
                      setState(() {
                        orderItems.insert(0, SaleOrderLine(
                          product: selectedProduct,
                          id: orderItems.length + 1,
                          salesOrderId: 0, // Sẽ cập nhật sau khi tạo đơn hàng
                          productId: selectedProduct!.id!, // Sử dụng id của sản phẩm đã chọn
                          quantity: int.parse(quantityController.text),
                          price: selectedProduct!.salePrice,
                          totalAmount: int.parse(quantityController.text) *
                              selectedProduct!.salePrice,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ));
                        selectedProduct = null;
                        quantityController.text = "";
                      });
                    }
                  },
                  child: Text('Add Item'),
                ),
                SizedBox(height: 16),
                Text('Items in Order:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    SaleOrderLine item = orderItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('Product: ${item.product?.sku??""}|${item.product?.productName??""}', overflow: TextOverflow.ellipsis,),
                        subtitle: Text('Quantity: ${item.quantity} | Price: \$${item.price.toStringAsFixed(2)}'),
                        trailing: Text('Total: \$${item.totalAmount.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Tạo SaleOrder mới
                      SaleOrder newOrder = SaleOrder(
                        id: 0, // Sẽ tự động tạo ID
                        customerName: customerNameController.text,
                        orderDate: DateTime.now(),
                        status: _orderStatus!.toUpperCase(),
                        totalAmount: orderItems.fold(0.0, (sum, item) => sum + item.totalAmount),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        items: orderItems,
                      );

                      SaleOrderManager.createSaleOrder(newOrder);

                      // Lưu đơn hàng hoặc gọi API để tạo đơn hàng
                      controller.saleOrders.add(newOrder);

                      // Quay lại màn hình quản lý đơn hàng
                      Get.back();
                    }
                  },
                  child: Text('Create Sale Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
