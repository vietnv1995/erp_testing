import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../mysql_manager.dart';

class InventoryApi {
  final MySQLManager mysqlManager;

  InventoryApi(this.mysqlManager);


  Router get router {
    final router = Router();

    // API to get all users
    router.get('/get', (Request request) async {
      final results = await mysqlManager.connection.query('SELECT * FROM inventory');
      final users = results.map((row) {
        var fields = Map<String, dynamic>.from(row.fields);
        if (fields['created_at'] is DateTime) {
          fields['created_at'] = (fields['created_at'] as DateTime).toIso8601String();
        }
        if (fields['updated_at'] is DateTime) {
          fields['updated_at'] = (fields['updated_at'] as DateTime).toIso8601String();
        }

        return fields;
      }).toList();
      return Response.ok(jsonEncode(users));
    });

    return router;
  }
}