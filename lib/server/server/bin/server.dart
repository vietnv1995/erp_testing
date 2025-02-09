import 'dart:io';

import 'package:server/apis/inventory.dart';
import 'package:server/apis/sales_order.dart';
import 'package:server/apis/users_api.dart';
import 'package:server/mysql_manager.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main(List<String> arguments) async{
  // final router = Router();
  // router.get('/users', getUsers);
  // Initialize MySQL connection
  final mysqlManager = MySQLManager();
  await mysqlManager.initialize();

  // Create instances of API classes
  final userApi = UserApi(mysqlManager);
  final inventoryApi = InventoryApi(mysqlManager);
  final saleOrderApi = SalesOrderApi(mysqlManager);

  final router = Router()
  // Mount user API under /user prefix
    ..mount('/users', userApi.router)
  ..mount('/inventory', inventoryApi.router)
  ..mount("/sale-orders", saleOrderApi.router)
  ;
  // Mount product API under /product prefix
  //   ..mount('/product', productApi.router);


  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('Server running on http://${server.address.host}:${server.port}');
}
