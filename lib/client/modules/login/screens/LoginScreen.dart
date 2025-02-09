import 'package:erp_test/client/modules/login/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/LoginController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ERP APP", style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 48,),
            TextField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(controller.isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            )),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Handle forgot password
                  print('Forgot Password');
                },
                child: Text('Forgot Password?'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to Register Screen
                    Get.to(RegisterScreen());
                  },
                  child: Text('Register'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
