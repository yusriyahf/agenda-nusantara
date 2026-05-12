class User {
  int? id;
  String username;
  String password;
  String name;
  String nim;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.nim,
  });

  // convert ke Map (untuk SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'nim': nim,
    };
  }

  // ambil dari Map (dari SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
      nim: map['nim'],
    );
  }
}
