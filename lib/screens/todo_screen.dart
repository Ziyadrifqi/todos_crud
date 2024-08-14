import 'package:kelompok_crud/models/todo.dart';
import 'package:kelompok_crud/services/category_service.dart';
import 'package:kelompok_crud/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionTitleController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _selectedValue;
  var _categories = <DropdownMenuItem<String>>[];
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
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
        title: Text('Buat Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                hintText: 'Isi Judul',
              ),
            ),
            TextField(
              controller: _todoDescriptionTitleController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Isi Deskripsi',
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                labelText: 'Tanggal',
                hintText: 'Pilih Tanggal',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: Text('Kategori'),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var todoObject = Todo(
                  id: 0,
                  title: _todoTitleController.text,
                  description: _todoDescriptionTitleController.text,
                  category: _selectedValue.toString(),
                  todoDate: _todoDateController.text,
                  isFinished: 0,
                );

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);

                if (result > 0) {
                  _showSuccessSnackBar(Text('Berhasil Disimpan'));
                  // Kembali ke HomeScreen setelah menyimpan data
                  Navigator.of(context).pop(todoObject);
                }

                print(result);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }
}
