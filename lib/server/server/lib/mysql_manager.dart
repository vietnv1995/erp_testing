import 'package:mysql1/mysql1.dart';

class MySQLManager {
  // Initialize MySQL connection
  // Private static instance of the class
  static final MySQLManager _instance = MySQLManager._internal();

  // MySQL connection
  MySqlConnection? _connection;

  // Private constructor
  MySQLManager._internal();

  // Factory constructor to return the singleton instance
  factory MySQLManager() {
    return _instance;
  }

  // Method to initialize the connection
  Future<void> initialize() async {
    if (_connection != null) return; // Already initialized

    // Load environment variables
    var env = {
      'DATABASE_HOST': "gw.techarrow.asia",
      'DATABASE_PORT': "30231",
      'DATABASE_USER': "root",
      'DATABASE_PASSWORD': "inv3st@Mysql2025",
      'DATABASE_NAME': "vietnguyen"
    };

    // Create a new connection
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: env['DATABASE_HOST']!,
      port: int.parse(env['DATABASE_PORT'] ?? '3306'),
      user: env['DATABASE_USER'],
      password: env['DATABASE_PASSWORD'],
      db: env['DATABASE_NAME'],
    ));

    print('MySQL connection established.');
  }

  // Getter for the connection
  MySqlConnection get connection {
    if (_connection == null) {
      throw Exception('MySQL connection is not initialized.');
    }
    return _connection!;
  }

  // Method to close the connection
  Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      print('MySQL connection closed.');
    }
  }
}