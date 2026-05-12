import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/databases/db_helper.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  final users = await DBHelper.instance.getAllUsers();

  if (users.isEmpty) {
    await DBHelper.instance.insertUser({
      'username': 'admin',
      'password': '12345',
      'name': 'Yusriyah Firjatullah',
      'nim': '2241720178',
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
