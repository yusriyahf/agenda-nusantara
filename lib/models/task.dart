class Task {
  int? id;
  String title;
  String description;
  String date;
  bool isImportant;
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isImportant = false,
    this.isDone = false,
  });

  // convert ke Map (untuk SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isImportant': isImportant ? 1 : 0,
      'isDone': isDone ? 1 : 0,
    };
  }

  // ambil dari Map (dari SQLite)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      isImportant: map['isImportant'] == 1,
      isDone: map['isDone'] == 1,
    );
  }
}
