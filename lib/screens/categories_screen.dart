import 'package:kelompok_crud/screens/home_screen.dart';
import 'package:kelompok_crud/models/category.dart';
import 'package:kelompok_crud/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class CardColor {
  final Color backgroundColor;
  final Color textColor;

  CardColor(this.backgroundColor, this.textColor);
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category(name: '', description: '');
  var _categoryService = CategoryService();

  List<Category> _categoryList = [];

  var category;

  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = [];
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category(
          id: category['id'],
          name: category['name'],
          description: category['description'],
        );
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editcategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('BATAL'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;

                var result = await _categoryService.saveCategory(_category);
                if (result > 0) {
                  print(result);
                  Navigator.pop(context);
                  getAllCategories();
                }
              },
              child: Text('SIMPAN'),
            ),
          ],
          title: Text('Kategori'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Buat Kategori',
                    labelText: 'Kategori',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Buat Deskripsi',
                    labelText: 'Deskripsi',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('BATAL'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                _category.id = category[0]['id'];
                _category.name = _editcategoryNameController.text;
                _category.description = _editcategoryDescriptionController.text;

                var result = await _categoryService.updateCategory(_category);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories();
                  _showSuccessSnackBar(Text('Berhasil Diperbarui'));
                }
              },
              child: Text('PERBARUI'),
            ),
          ],
          title: Text('Edit Kategori'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editcategoryNameController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Buat Kategori',
                    labelText: 'Kategori',
                  ),
                ),
                TextField(
                  controller: _editcategoryDescriptionController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Buat Deskripsi',
                    labelText: 'Deskripsi',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('BATAL'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                var result = await _categoryService.deleteCategory(categoryId);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories();
                  _showSuccessSnackBar(Text('Berhasil Dihapus'));
                }
              },
              child: Text('HAPUS'),
            ),
          ],
          title: Text('Apa kamu yakin ingin menghapus ini?'),
        );
      },
    );
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            elevation: 0.0,
          ),
          child: Icon(Icons.arrow_back),
        ),
        title: Text('Kategori'),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          var cardColor = _getCardColor(index);
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              color: cardColor.backgroundColor,
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _categoryList[index].name,
                      style: TextStyle(
                        color: cardColor.textColor, // Warna teks
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _deleteFormDialog(context, _categoryList[index].id);
                      },
                    )
                  ],
                ),
                subtitle: Text(
                  _categoryList[index].description,
                  style: TextStyle(
                    color: cardColor.textColor, // Warna teks
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

CardColor _getCardColor(int index) {
  // Contoh: Warna bergantung pada indeks (genap/ganjil)
  Color backgroundColor = index % 2 == 0 ? Colors.blue : Colors.green;
  Color textColor =
      backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

  return CardColor(backgroundColor, textColor);
}
