import 'package:flutter/material.dart';

class OpenOrders extends StatefulWidget {
  const OpenOrders({super.key});

  @override
  State<OpenOrders> createState() => _OpenOrdersState();
}

class _OpenOrdersState extends State<OpenOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Open Orders")),
    );
  }
}
