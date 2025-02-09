import 'package:erp_test/client/managers/users/UserManager.dart';
import 'package:erp_test/client/models/users/ErpUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username",
                border: OutlineInputBorder(),),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email",
                border: OutlineInputBorder(),),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password",
                border: OutlineInputBorder(),),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                String username = usernameController.text;
                String email = emailController.text;
                String password = passwordController.text;

                if (username.isEmpty || email.isEmpty || password.isEmpty) {
                  Get.snackbar("Error", "All fields are required",
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                EasyLoading.show();
                await UserManager.createUser(ErpUser( user_name: "abc", email: "abc@123", password: "123344"));
                EasyLoading.dismiss();
                // TODO: Thực hiện đăng ký tài khoản ở đây

                Get.snackbar("Success", "Registered successfully",
                    snackPosition: SnackPosition.BOTTOM);
                Get.back(); // Quay lại màn hình login
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}