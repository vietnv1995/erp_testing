import 'package:erp_test/client/managers/orders/SaleOrderManager.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../models/orders/SaleOrder.dart';

class SaleOrderController extends GetxController {
  var isLoading = true.obs;
  var saleOrders = <SaleOrder>[].obs;

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchSaleOrders();
  }

  // Fetch danh sách SaleOrders từ API
  Future<void> fetchSaleOrders() async {
    saleOrders.value = await SaleOrderManager.getAllSaleOrder();
    isLoading.value = false;
  }
}
