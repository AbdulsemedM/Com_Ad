import 'package:commercepal_admin_flutter/core/products/domain/models/product.dart';
import 'package:flutter/material.dart';

class NewEditProduct extends StatefulWidget {
  final Product myProduct;
  const NewEditProduct({required this.myProduct, super.key});

  @override
  State<NewEditProduct> createState() => _NewEditProductState();
}

class _NewEditProductState extends State<NewEditProduct> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
