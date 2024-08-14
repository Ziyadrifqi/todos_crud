import 'package:flutter/material.dart';
import 'package:kelompok_crud/helpers/drawer_navigation.dart';
import 'package:kelompok_crud/models/todo.dart';
import 'package:kelompok_crud/screens/todo_screen.dart';
import 'package:kelompok_crud/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class CardColor {
  final Color backgroundColor;
  final Color textColor;

  CardColor(this.backgroundColor, this.textColor);
}

class _HomeScreenState extends State<HomeScreen> {
  late TodoService _todoService;
  late List<Todo> _todoList;

  @override
  void initState() {
    super.initState();
    _todoService = TodoService();
    _todoList = [];
    getAllTodos();
  }

  getAllTodos() async {
    var todos = await _todoService.readTodos();

    setState(() {
      _todoList = todos
          .map<Todo>((todo) => Todo(
                id: todo['id'],
                title: todo['title'],
                description: todo['description'],
                category: todo['category'],
                todoDate: todo['todoDate'],
                isFinished: todo['isFinished'],
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CATATANKU'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          var cardColor = _getCardColor(index);
          return Padding(
            padding: EdgeInsets.only(top: 10.0, left: 14.0, right: 14.0),
            child: Card(
              elevation: 8,
              color: cardColor.backgroundColor,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _todoList[index].title,
                      style: TextStyle(
                        color: cardColor.textColor, // Warna teks
                      ),
                    ),
                  ],
                ),
                subtitle: Text(_todoList[index].category),
                trailing: Text(_todoList[index].todoDate),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push untuk pindah ke layar TodoScreen
          // dan menunggu hasil dari layar tersebut
          var newTodo = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TodoScreen()),
          );

          // Periksa apakah newTodo memiliki data sebelum menyimpannya
          if (newTodo != null && newTodo.title.isNotEmpty) {
            // Jika ada data, tambahkan todo baru ke dalam daftar
            setState(() {
              _todoList.add(newTodo);
            });
          } else {
            // Jika tidak ada data, berikan pesan atau lakukan tindakan lainnya
            print('Todo tidak disimpan karena tidak ada data yang valid.');
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  CardColor _getCardColor(int index) {
    // Contoh: Warna bergantung pada indeks (genap/ganjil)
    Color backgroundColor = index % 2 == 0 ? Colors.blue : Colors.green;
    Color textColor =
        backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    return CardColor(backgroundColor, textColor);
  }
}
