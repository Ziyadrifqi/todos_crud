import 'package:flutter/material.dart';
import 'package:kelompok_crud/models/todo.dart';
import 'package:kelompok_crud/screens/edit_todo_screen.dart';
import 'package:kelompok_crud/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({required this.category});

  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class CardColor {
  final Color backgroundColor;
  final Color textColor;

  CardColor(this.backgroundColor, this.textColor);
}

class _TodosByCategoryState extends State<TodosByCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Todo> _todoList = [];
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    _getTodosByCategories();
  }

  Future<void> _getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(widget.category);
    setState(() {
      _todoList = todos
          .map((todo) => Todo(
                id: todo['id'],
                title: todo['title'],
                description: todo['description'],
                category: todo['category'],
                todoDate: todo['todoDate'],
                isFinished: todo['isFinished'] ?? 0,
              ))
          .toList();
    });
  }

  CardColor _getCardColor(int index) {
    Color backgroundColor = index % 2 == 0 ? Colors.blue : Colors.green;
    Color textColor =
        backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    return CardColor(backgroundColor, textColor);
  }

  void _deleteTodoConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus note ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTodo(index);
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTodo(int index) async {
    await _todoService.deleteTodo(_todoList[index].id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan dihapus')),
    );

    setState(() {
      _todoList.removeAt(index);
    });

    await _getTodosByCategories();
  }

  void _editTodo(int index) async {
    var updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoScreen(todo: _todoList[index]),
      ),
    );

    if (updatedTodo != null) {
      setState(() {
        _todoList[index] = updatedTodo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Catatan Berdasarkan Kategori'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                var cardColor = _getCardColor(index);
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _deleteTodoConfirmation(context, index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 8.0,
                    color: cardColor.backgroundColor,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _todoList[index].title,
                            style: TextStyle(color: cardColor.textColor),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        _todoList[index].description,
                        style: TextStyle(color: cardColor.textColor),
                      ),
                      trailing: Text(
                        _todoList[index].todoDate,
                        style: TextStyle(color: cardColor.textColor),
                      ),
                      onTap: () {
                        _editTodo(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
