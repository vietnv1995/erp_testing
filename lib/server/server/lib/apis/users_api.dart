import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../mysql_manager.dart';

class UserApi {
  final MySQLManager mysqlManager;

  UserApi(this.mysqlManager);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Chuyển đổi mật khẩu thành bytes
    final digest = md5.convert(bytes); // Băm bằng MD5
    return digest.toString(); // Trả về chuỗi hex
  }

  Router get router {
    final router = Router();

    // API to create a new user
    router.post('/register', (Request request) async {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body);

      final username = jsonBody['username'];
      final email = jsonBody['email'];
      final password = jsonBody['password'];

      final hashedPassword = _hashPassword(password);

      await mysqlManager.connection.query(
        'INSERT INTO user (user_name, email, password) VALUES (?, ?, ?)',
        [username, email, hashedPassword],
      );

      return Response.ok('User created successfully');
    });

    router.post('/login', (Request request) async {
      final body = await request.readAsString();
      final jsonBody = jsonDecode(body);

      final username = jsonBody['username'];
      final password = jsonBody['password'];

      // Băm mật khẩu nhập vào
      final hashedPassword = _hashPassword(password);

      // Tìm user trong database
      final result = await mysqlManager.connection.query(
        'SELECT * FROM user WHERE user_name = ? AND password = ?',
        [username, hashedPassword],
      );

      // Kiểm tra kết quả
      if (result.isEmpty) {
        return Response.unauthorized('Invalid username or password');
      }

      // Trả về thông tin user nếu đăng nhập thành công
      final user = result.first;
      return Response.ok(jsonEncode({
        'id': user['id'],
        'user_name': user['user_name'],
        'email': user['email'],
        'password': ''
      }));
    });

    // API to get all users
    router.get('/users', (Request request) async {
      final results = await mysqlManager.connection.query('SELECT * FROM user');
      final users = results.map((row) => row.fields).toList();
      return Response.ok(jsonEncode(users));
    });

    return router;
  }
}