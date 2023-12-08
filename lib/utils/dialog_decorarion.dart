import 'package:flutter/material.dart';

AlertDialog buildAlertDialog({
  required String title,
  required String content,
  required BuildContext context,
}) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
