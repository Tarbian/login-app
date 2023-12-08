import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required String labelText,
  required IconData iconData,
  IconData? suffixIconData,
  bool obscureText = false,
  VoidCallback? onSuffixIconPressed,
}) {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelText: labelText,
    icon: Icon(
      iconData,
      color: Colors.deepPurple[900],
    ),
    errorMaxLines: 2,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      borderSide: BorderSide(
        color: Colors.deepPurple,
        width: 2,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      borderSide: BorderSide(
        color: Colors.red, 
        width: 2,
      ),
    ),
    suffixIcon: suffixIconData != null
        ? IconButton(
            icon: Icon(suffixIconData),
            onPressed: onSuffixIconPressed,
          )
        : null,
  );
}
