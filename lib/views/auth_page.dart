import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/components/custom_text_field.dart';
import 'package:tareas/providers/DatabaseProvider.dart';
import 'package:tareas/providers/UserProvider.dart';
import '../models/User.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Color _selectedColor = Colors.blue; // Color inicial
  DateTime _selectedDate = DateTime.now(); // Fecha inicial
  bool _hasAccount = false;
  //creation user
  void _handleUserCreation( user) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    print('Usuario creado: ${user.name}, ${user.email}, ${user.colorSettings}');
    // Después de almacenar el usuario, redirige a la página TaskListPage o realiza otras acciones necesarias
    Navigator.pushReplacementNamed(context, '/home');
  }


  void _selectColor(BuildContext context) {
    Color selectedColor = _selectedColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Color'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Selected Color: '),
                    Container(
                      width: 30,
                      height: 30,
                      color: selectedColor,
                    ),
                  ],
                ),
                ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                  pickerAreaHeightPercent: 0.8,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    ).then((color) {
      if (color != null) {
        setState(() {
          _selectedColor = color;
        });
      }
    });
  }

  void _handleRegister() async {
    final dbProvider = DatabaseProvider();
    final db = await dbProvider.database;

    final String name = _nameController.text;
    final String email = _emailController.text;
    final String colorSettings = _selectedColor.value.toString();

    if (name.isNotEmpty && email.isNotEmpty) {
      final List<Map<String, dynamic>> existingUsersMap =
      await db.query('users', where: 'email = ?', whereArgs: [email]);

      if (existingUsersMap.isNotEmpty) {
        final userMap = existingUsersMap.first;
        final user = User.fromMap(userMap);
        _handleUserCreation(user);
      } else {
        final newUser = User(
          name: name,
          email: email,
          colorSettings: colorSettings,
          is_active: 1,
        );

        await db.insert('users', newUser.toMap());
        _handleUserCreation(newUser);
      }
    } else {
      setState(() {
        _hasAccount = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Establece el fondo transparente para que la imagen sea visible
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/landing_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Ajusta el valor según tu preferencia
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _hasAccount ? _buildLoginForm() : _buildRegistrationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLoginForm() {
    return Opacity(
      opacity: 0.9,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey,
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            Row(
              children: [
                Text('Color de Fondo: '),
                Container(
                  width: 40,
                  height: 40,
                  color: _selectedColor,
                ),
                IconButton(
                  onPressed: () => _selectColor(context),
                  icon: Icon(Icons.color_lens),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _handleRegister,
              child: Text('Crear cuenta'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _hasAccount = false;
                });
              },
              child: Text('Ya poseo una cuenta'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRegistrationForm() {
    return Opacity(
      opacity: 0.9,
      child: Container(

        padding: EdgeInsets.all(20),
        color: Colors.grey,
        child: Column(
          children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.person,
                suffixIcon: Icons.delete_outline,
                hintText: 'ejemplo@email.com',
                onChanged: (value) {
                  // Lógica de cambio
                },
              ),
              // Otros widgets...
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim(); // Elimina espacios en blanco al inicio y al final

                if (email.isNotEmpty) { // Valida que el campo no esté vacío
                  final dbProvider = DatabaseProvider();
                  final db = await dbProvider.database;

                  final List<Map<String, dynamic>> usersMap =
                  await db.query('users', where: 'email = ?', whereArgs: [email]);
                  if (usersMap.isNotEmpty) {
                    final userMap = usersMap.first;
                    final user = User.fromMap(userMap);
                    final userId = userMap['id'] as int; // Obtén el ID del usuario
                    await db.update(
                      'users',
                      {'is_active': 1},
                      where: 'id = ?',
                      whereArgs: [userId],
                    );
                    _handleUserCreation(user);
                  } else {
                    setState(() {
                      _hasAccount = true;
                    });
                  }
                } else {
                  // Muestra una alerta o mensaje al usuario indicando que debe ingresar un correo válido
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Ingrese un correo válido.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }


}