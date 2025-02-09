import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_test/client/models/inventory/Inventory.dart';

class InventoryManager {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.3.2:8080", // Thay API endpoint của bạn
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<List<Inventory>> getAllProduct() async{
    List<Inventory> products = <Inventory>[];
    try {
      Response response = await _dio.get("/inventory/get");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.data);
        List<Inventory> products = data.map((json) => Inventory.fromJson(json)).toList();
        return products;
      } else {
        return products;
      }
    } catch (e) {
      print("API Error: $e");
      return products;
    }
  }
}