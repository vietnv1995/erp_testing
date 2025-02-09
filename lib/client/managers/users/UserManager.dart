import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_test/client/models/users/ErpUser.dart';

class UserManager {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.3.2:8080", // Thay API endpoint của bạn
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<bool> createUser(ErpUser erpUser) async{
    try {
      Response response = await _dio.post("/users/register", data: {
        "username": erpUser.user_name,
        "email": erpUser.email,
        "password": erpUser.password,
      });

      if (response.statusCode == 200) {
        return true; // Đăng ký thành công
      } else {
        return false;
      }
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }

  static Future<ErpUser?> login(String username, String password) async {
    try {
      Response response = await _dio.post("/users/login", data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200) {
        return ErpUser.fromJson(Map<String,dynamic>.from(jsonDecode(response.data))); // Trả về token nếu đăng nhập thành công
      } else {
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}