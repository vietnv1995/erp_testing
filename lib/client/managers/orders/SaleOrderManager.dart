import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_test/client/models/inventory/Inventory.dart';
import 'package:erp_test/client/models/orders/SaleOrder.dart';

class SaleOrderManager {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.3.2:8080", // Thay API endpoint của bạn
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<List<SaleOrder>> getAllSaleOrder() async{
    List<SaleOrder> saleOrders = <SaleOrder>[];
    Response response = await _dio.get("/sale-orders/get");

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.data);
      saleOrders = data.map((json) => SaleOrder.fromJson(json)).toList();
      return saleOrders;
    } else {
      return saleOrders;
    }
  }

  static Future<SaleOrder?> createSaleOrder(SaleOrder saleOrder) async {
    try {
      Response response = await _dio.post("/sale-orders/create", data: saleOrder.toJson());

      if (response.statusCode == 200) {
        return SaleOrder.fromJson(Map<String,dynamic>.from(jsonDecode(response.data))); // Trả về token nếu đăng nhập thành công
      } else {
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}