import 'package:kelompok_crud/repositories/database_connection.dart';
import 'package:kelompok_crud/src/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Panggil fungsi setDatabase untuk inisialisasi database
  await DatabaseConnection().setDatabase();

  runApp(App());
}
