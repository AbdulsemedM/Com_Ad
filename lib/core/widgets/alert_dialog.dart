import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? pText;
  final String? nText;
  final Function? onPositiveClicked;
  final Function? onNegativeClicked;

  const MyDialog(
      {super.key,
      required this.title,
      required this.message,
      this.pText,
      this.nText,
      this.onPositiveClicked,
      this.onNegativeClicked});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
      ),
      actions: [
        TextButton(
          child: Text(nText ?? 'Cancel'),
          onPressed: () {
            // Close the dialog and perform some action
            Navigator.of(context).pop(false);
            onNegativeClicked?.call();
          },
        ),
        TextButton(
          child: Text(pText ?? 'Continue'),
          onPressed: () {
            Navigator.of(context).pop(true);
            onPositiveClicked?.call();
          },
        ),
      ],
    );
  }
}
