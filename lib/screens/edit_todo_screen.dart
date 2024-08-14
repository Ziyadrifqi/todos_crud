import 'package:flutter/material.dart';
import 'package:kelompok_crud/models/todo.dart';
import 'package:kelompok_crud/services/todo_service.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TodoService _todoService = TodoService();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description;
  }

  void _saveChanges() async {
    String updatedTitle = _titleController.text;
    String updatedDescription = _descriptionController.text;

    Todo updatedTodo = Todo(
      id: widget.todo.id,
      title: updatedTitle,
      description: updatedDescription,
      category: widget.todo.category,
      todoDate: widget.todo.todoDate,
      isFinished: widget.todo.isFinished,
    );

    int result = await _todoService.updateTodo(updatedTodo);

    if (result > 0) {
      print('Perubahan berhasil disimpan!');
      Navigator.pop(context, updatedTodo);
    } else {
      print('Gagal menyimpan perubahan.');
      _showErrorSnackBar(Text('Gagal menyimpan perubahan.'));
    }
  }

  void _deleteTodo() async {
    int result = await _todoService.deleteTodo(widget.todo.id!);

    if (result > 0) {
      print('Todo berhasil dihapus!');
      Navigator.pop(context, null); // Kembali tanpa mengirimkan objek Todo
    } else {
      print('Gagal menghapus todo.');
      _showErrorSnackBar(Text('Gagal menghapus todo.'));
    }
  }

  void _showErrorSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus todo ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteTodo(); // Hapus todo jika dikonfirmasi
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Tidak lakukan apa-apa jika tombol tidak di-klik
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          'Edit Catatan',
          style: TextStyle(
            fontFamily:
                'sans-serif', // Ganti dengan jenis huruf sans-serif yang diinginkan
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red, // Warna ikon
            ),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(
                  fontFamily:
                      'sans-serif', // Ganti dengan jenis huruf sans-serif yang diinginkan
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(
                  fontFamily:
                      'sans-serif', // Ganti dengan jenis huruf sans-serif yang diinginkan
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Warna latar belakang tombol
                onPrimary: Colors.white, // Warna teks tombol
              ),
              child: Text(
                'SIMPAN',
                style: TextStyle(
                  color: Colors.white, // Warna teks tombol
                  fontFamily: 'sans-serif',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
