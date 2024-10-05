import 'package:flutter/material.dart';

showPopDialog(BuildContext context, String title, String desc, String? left,
    String? right, Function func) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(desc),
          actions: [
            TextButton(
              child: Text(left ?? ''),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                right ?? '',
              ),
              onPressed: () async {
                func();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
