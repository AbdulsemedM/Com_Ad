import 'package:flutter/material.dart';

import '../widgets/alert_dialog.dart';

extension BuildCtxExtensions on BuildContext {
  void displaySnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: Text(
          message,
          style: Theme.of(this)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        )));
  }

  void displayDialog(
      {required String title,
      required String message,
      String? pText,
      String? nText,
      Function? onPClicked,
      Function? onNegativeClicked}) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return MyDialog(
          title: title,
          message: message,
          pText: pText,
          nText: nText,
          onPositiveClicked: onPClicked,
          onNegativeClicked: onNegativeClicked,
        );
      },
    );
  }
}
