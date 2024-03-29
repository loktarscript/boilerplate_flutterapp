import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/providers/DatabaseProvider.dart';
import 'package:tareas/providers/UserProvider.dart';
import 'package:tareas/views/auth_page.dart';
import 'package:tareas/views/loading_page.dart';
import 'package:tareas/views/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización de Flutter
  final dbProvider = DatabaseProvider();
  await dbProvider.initDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Asegúrate de proporcionar UserProvider aquí
        // Otros providers si los tienes
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingPage(),
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(), // Ajusta la ruta de TaskListPage
      },
    );
  }
}
