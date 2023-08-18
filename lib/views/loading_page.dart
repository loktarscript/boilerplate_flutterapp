import 'package:flutter/material.dart';
import 'package:tareas/providers/DatabaseProvider.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkActiveUser();
  }

  Future<void> _checkActiveUser() async {
    final dbProvider = DatabaseProvider();
    final db = await dbProvider.database;

    final users = await db.query('users', where: 'is_active = ?', whereArgs: [1]);

    if (users.isNotEmpty) {
      // Redirigir a la página TaskListPage si hay un usuario activo
      Navigator.pushReplacementNamed(context, '/task_list');
    } else {
      // Redirigir a la página LandingPage si no hay un usuario activo
      Navigator.pushReplacementNamed(context, '/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
