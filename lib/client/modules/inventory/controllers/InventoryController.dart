import 'package:erp_test/client/managers/inventory/InventoryManager.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../models/inventory/Inventory.dart';

class InventoryController extends GetxController {
  var listProducts = <Inventory>[].obs;  // Observable list of Inventory
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080/products';

  @override
  void onInit() {
    getAllProducts();
  } // URL API của bạn




  // Hàm để lấy tất cả sản phẩm từ API
  Future<void> getAllProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    listProducts.value = await InventoryManager.getAllProduct();
    listProducts.refresh();
    isLoading.value = false;
  }
}