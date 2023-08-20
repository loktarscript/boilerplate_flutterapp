import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/helpers/global_colors.dart';
import 'package:tareas/models/User.dart';
import 'package:tareas/providers/DatabaseProvider.dart';
import 'package:tareas/providers/UserProvider.dart';

import '../models/Task.dart';

class TaskListPage extends StatefulWidget {

  @override
  _TaskListPageState createState() => _TaskListPageState();

}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> _tasks = [];
  late User _activeUser;
  @override
  void initState() {

    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final dbProvider = DatabaseProvider();
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> tasksMap = await db.query('tasks');
    List<Task> tasks = tasksMap.map((taskMap) => Task(
      id: taskMap['id'],
      content: taskMap['content'],
      icon: taskMap['icon'],
    )).toList();
    print("Task List");
    print(tasks);
    setState(() {
      _tasks = tasks;
    });
  }

  void _logoutUser() async {
    final dbProvider = DatabaseProvider();
    final db = await dbProvider.database;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final activeUser = userProvider.user;

    if (activeUser != null) {
      await db.update(
        'users',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [activeUser.id],
      );

      userProvider.setUser(User(
        id: activeUser.id,
        name: activeUser.name,
        email: activeUser.email,
        colorSettings: activeUser.colorSettings,
        is_active: 0,
      ));

      // Realiza otras acciones necesarias para cerrar la sesión, como limpiar datos, etc.
    }

    // Redirige a la página de inicio de sesión o a donde corresponda
    Navigator.pushReplacementNamed(context, '/landing'); // Cambia '/login' por la ruta adecuada
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final activeUser = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        backgroundColor: GlobalColors.secondColor, // Cambia el color de fondo del AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              _logoutUser(); // Llama a la función que maneja el cierre de sesión
            },
          ),
        ],
        bottom: activeUser != null
            ? PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Container(
            alignment: Alignment.centerLeft, // Alineación a la izquierda
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0), // Agrega padding
            child: Text(
              'Usuario: ${activeUser.name}',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        )
            : null,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.content),
            subtitle: Text(task.icon),
          );
        },
      ),
    );
  }
}
