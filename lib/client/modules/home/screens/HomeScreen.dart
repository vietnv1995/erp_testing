import 'package:erp_test/client/modules/inventory/screens/InventoryScreen.dart';
import 'package:erp_test/client/modules/orders/screens/SaleOrderScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onRowTap(String section) {
    // Get.snackbar("Navigation", "You tapped on $section",
    //     snackPosition: SnackPosition.BOTTOM);
    // Get.toNamed("/$section"); // Nếu có màn hình tương ứng
    if (section == "inventory") {
      Get.to(InventoryScreen());
    } else if (section == "orders") {
      Get.to(SaleOrderManagementScreen());
    }
  }

  Widget _buildRow(String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => _onRowTap(route),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          _buildRow("Inventory", Icons.inventory, "inventory"),
          _buildRow("Orders", Icons.shopping_cart, "orders"),
          _buildRow("Accounting", Icons.account_balance, "accounting"),
        ],
      ),
    );
  }
}