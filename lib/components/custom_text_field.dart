import 'package:flutter/material.dart';
import 'package:tareas/helpers/global_colors.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final String hintText;
  final Function(String) onChanged;
  final bool obscureText;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: GlobalColors.firstColor),
        prefixIcon: Icon(Icons.email, color: GlobalColors.firstColor),
        suffixIcon: Icon(Icons.access_alarm, color: GlobalColors.firstColor),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: GlobalColors.secondColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: GlobalColors.secondColor, width: 2.0),
        ),
      ),
    );
  }
}
