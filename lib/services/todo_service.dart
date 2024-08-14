// File: services/todo_service.dart

import 'package:kelompok_crud/models/todo.dart';
import 'package:kelompok_crud/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService() : _repository = Repository();

  Future<int> saveTodo(Todo todo) async {
    try {
      // Jangan memberikan nilai untuk kolom id saat menyimpan todo baru
      Map<String, dynamic> todoMap = todo.toMapForDb();
      todoMap.remove('id');
      return await _repository.insertData('todos', todoMap);
    } catch (e) {
      print("Error saving todo: $e");
      return -1; // Menandakan kesalahan
    }
  }

  Future<int> updateTodo(Todo todo) async {
    try {
      return await _repository.updateData('todos', todo.toMapForDb());
    } catch (e) {
      print("Error updating todo: $e");
      return -1; // Menandakan kesalahan
    }
  }

  Future<int> deleteTodo(int todoId) async {
    try {
      return await _repository.deleteData('todos', todoId);
    } catch (e) {
      print("Error deleting todo: $e");
      return -1; // Menandakan kesalahan
    }
  }

  Future<int> deleteTodosByCategory(String category) async {
    try {
      return await _repository.deleteDataByColumnName(
          'todos', 'category', category);
    } catch (e) {
      print("Error deleting todos by category: $e");
      return -1; // Menandakan kesalahan
    }
  }

  // read todos
  Future<List<Map<String, dynamic>>> readTodos() async {
    return await _repository.readData('todos');
  }

  // read todos by category
  Future<List<Map<String, dynamic>>> readTodosByCategory(
      String category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }
}
