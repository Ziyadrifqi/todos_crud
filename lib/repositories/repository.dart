// File: repositories/repository.dart

import 'package:kelompok_crud/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() : _databaseConnection = DatabaseConnection();

  static Database? _database;

  // check if database is exist or not
  Future<Database?> get database async {
    if (_database != null) return _database;

    try {
      _database = await _databaseConnection.setDatabase();
    } catch (e) {
      print("Error initializing database: $e");
    }

    return _database;
  }

  // Inserting data to Table
  Future<int> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(table, data) ?? -1;
  }

  // Read data from table
  Future<List<Map<String, dynamic>>> readData(String table) async {
    var connection = await database;
    return await connection?.query(table) ?? [];
  }

  // Read data from table by Id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  // Update data from table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  // Delete data from table
  deleteData(table, itemId) async {
    var connection = await _database;
    return await connection?.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  // Read data from table by column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection
        ?.query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }

  // delete data from table by column name
  Future<int> deleteDataByColumnName(
      String table, String columnName, dynamic columnValue) async {
    var connection = await database;
    return await connection?.delete(
          table,
          where: '$columnName = ?',
          whereArgs: [columnValue],
        ) ??
        -1;
  }
}
