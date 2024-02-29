import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../core/products/domain/models/Add_sub_product.dart';
import '../../../core/products/domain/models/discount_type.dart';
import '../../../core/products/presentation/widgets/select_discount_type_widget.dart';
import '../../../core/widgets/app_textfield.dart';
import '../add_product_variant/add_product_variant_page.dart';

class AddSubProductPage extends StatefulWidget {
  static const routeName = "/add_sub_product";

  const AddSubProductPage({super.key});

  @override
  State<AddSubProductPage> createState() => _AddSubProductPageState();
}

class _AddSubProductPageState extends State<AddSubProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _unitPrice;
  String? _discountAmount;
  String? _shortDescription;
  DiscountType? _discountType;
  String? _name;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final catId = args['product_id'];
    final subCatId = args['sub_cat_id'];

    if (args['name'] != null) {
      _name = args['name'];
    }

    return AppScaffold(
      appBarTitle: "Add Sub Product",
      subTitle: _name,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppTextField(
                title: "Unit price",
                hint: 'Enter unit price',
                textInputType: TextInputType.number,
                formFieldValidator: (value) {
                  if (value?.isEmpty == true) {
                    return "Unit price is required";
                  }
                  return null;
                },
                valueChanged: (value) {
                  _unitPrice = value;
                  setState(() {});
                },
              ),
              SelectDiscountTypeWidget(
                onDiscountTypeSelected: (DiscountType discountType) {
                  _discountType = discountType;
                  setState(() {});
                },
              ),
              AppTextField(
                title: "Discount Amount",
                formFieldValidator: (value) {
                  if (value?.isEmpty == true) {
                    return "Discount amount is required";
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                valueChanged: (value) {
                  _discountAmount = value;
                  setState(() {});
                },
              ),
              AppTextField(
                title: "Short Description",
                hint: '',
                maxLines: 4,
                formFieldValidator: (value) {
                  if (value?.isEmpty == true) {
                    return "Short description is required";
                  }
                  return null;
                },
                valueChanged: (value) {
                  _shortDescription = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 14),
              AppButtonWidget(
                onClick: () {
                  if (_formKey.currentState?.validate() == true) {
                    final addSubProduct = AddSubProduct(
                        discountType: _discountType?.name,
                        discountValue: _discountAmount,
                        isDiscounted:
                            _discountType?.name != "Discounted" ? "0" : "1",
                        productId: catId.toString(),
                        shortDescription: _shortDescription,
                        unitPrice: _unitPrice);

                    Navigator.pushNamed(
                        context, AddProductVariantPage.routeName, arguments: {
                      "sub_cat_id": subCatId,
                      "add_sub_product": addSubProduct
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
