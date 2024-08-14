import 'package:kelompok_crud/models/category.dart';
import 'package:kelompok_crud/repositories/repository.dart';

class CategoryService {
  final Repository _repository;

  CategoryService() : _repository = Repository();

  //create data
  Future<int> saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  //Insert data from table
  Future<List<Map<String, dynamic>>> readCategories() async {
    return await _repository.readData('categories');
  }

  //read data from table by Id
  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  //update data from table
  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }

  //delete data form table
  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}
