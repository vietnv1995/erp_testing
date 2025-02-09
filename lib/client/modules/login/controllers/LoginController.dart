import 'package:erp_test/client/managers/users/UserManager.dart';
import 'package:erp_test/client/models/users/ErpUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../home/screens/HomeScreen.dart';

class LoginController extends GetxController {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async{
    String username = usernameController.text;
    String password = passwordController.text;
    // TODO: Handle login logic here
    print('Login with: $username, $password');
    ErpUser? user = await UserManager.login(username, password);
    if (user != null) {
      Get.snackbar("Success", "Welcome ${user.user_name}",
          snackPosition: SnackPosition.BOTTOM);

      // Lưu user vào GetX Storage hoặc SharedPreferences
      Get.offAll(HomeScreen()); // Chuyển sang màn hình chính
    } else {
      Get.snackbar("Error", "Invalid credentials",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}