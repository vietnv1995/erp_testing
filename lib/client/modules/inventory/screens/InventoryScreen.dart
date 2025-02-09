import 'package:erp_test/client/modules/inventory/controllers/InventoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  final InventoryController controller = Get.put(InventoryController());

  @override
  void initState() {
    super.initState();
    controller.getAllProducts();
  }

  String _getStatus(int quantity) {
    if (quantity == 0) return "Out of stock";
    if (quantity < 10) return "Low in stock";
    return "In stock";
  }

  Color _getStatusColor(int quantity) {
    if (quantity == 0) return Colors.red;
    if (quantity < 10) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Management"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Chuyển đến màn hình thêm sản phẩm mới
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(()=> controller.isLoading.value?Container(
          child: Center(child: CircularProgressIndicator(),),
        ):ListView.builder(
          itemCount: controller.listProducts.value.length,
          itemBuilder: (context, index) {
            final item = controller.listProducts.value[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Bo góc ảnh
                  child: item.imageUrl != null
                      ? Image.network(
                    item.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  )
                      : Icon(Icons.image_not_supported, size: 80, color: Colors.grey), // Ảnh mặc định nếu không có ảnh
                ),
                title: Text(item.productName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SKU: ${item.sku}"),
                    Text("Cost Price: ${item.costPrice} đ"),
                    Text("Sale Price: ${item.salePrice} đ"),
                    Text("Quantity: ${item.quantity}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Status: ${_getStatus(item.quantity)}", style: TextStyle(color: _getStatusColor(item.quantity))),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Chỉnh sửa sản phẩm
                  },
                ),
              ),
            );
          },
        ),)
      ),
    );
  }


}