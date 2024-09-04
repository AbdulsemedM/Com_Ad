import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String msg;
  const AppErrorWidget( {
    super.key, required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
