// File: models/todo.dart

class Todo {
  int? id;
  String title;
  String description;
  String category;
  String todoDate;
  int? isFinished;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.todoDate,
    this.isFinished,
  });

  Map<String, dynamic> toMapForDb() {
    // Jika id tidak diisi (null), SQLite akan menangani penambahan nilai id yang otomatis
    if (id == null) {
      return {
        'title': title,
        'description': description,
        'category': category,
        'todoDate': todoDate,
        'isFinished': isFinished,
      };
    } else {
      // Jika id diisi, pastikan untuk menyertakannya dalam Map
      return {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'todoDate': todoDate,
        'isFinished': isFinished,
      };
    }
  }
}
