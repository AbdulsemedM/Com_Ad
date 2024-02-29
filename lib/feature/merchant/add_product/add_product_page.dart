import 'dart:convert';

import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/products/domain/models/add_product.dart';
import '../../../core/products/domain/models/brand.dart';
import '../../../core/products/domain/models/category.dart';
import '../../../core/products/domain/models/category_type.dart';
import '../../../core/products/domain/models/country.dart';
import '../../../core/products/domain/models/discount_type.dart';
import '../../../core/products/domain/models/product_type.dart';
import '../../../core/products/domain/models/unit_of_measure.dart';
import '../../../core/products/presentation/widgets/select_brand_widget.dart';
import '../../../core/products/presentation/widgets/select_category_widget.dart';
import '../../../core/products/presentation/widgets/select_country_widget.dart';
import '../../../core/products/presentation/widgets/select_discount_type_widget.dart';
import '../../../core/products/presentation/widgets/select_parent_category_widget.dart';
import '../../../core/products/presentation/widgets/select_product_type.dart';
import '../../../core/products/presentation/widgets/select_uom_widget.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../add_product_variant/add_product_variant_page.dart';

class AddProductPage extends StatelessWidget {
  static const routeName = "/add_product";

  const AddProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCreamWhite,
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: const AddProductForm(),
        ),
      ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Category? _parentCategory;
  Category? _category;
  Category? _subCategory;
  Uom? _uom;
  Brand? _brand;
  ProductType? _productType;
  DiscountType? _discountType;
  Country? _country;
  String? _name;
  String? _quantity;
  String? _unitPrice;
  String? _minimumOrder;
  String? _maximumOrder;
  String? _shortDescription;
  String? _productDescription;
  String? _discountValue;
  String? _specialInstruction;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SelectParentCategoryWidget(
                onParentCategorySelected: (Category parentCategory) {
              _parentCategory = parentCategory;
              setState(() {});
            }),
            if (_parentCategory != null)
              SelectCategoryWidget(
                  key: ValueKey(_parentCategory?.name),
                  categoryType: CategoryType.category,
                  onCategorySelected: (Category cat) {
                    _category = cat;
                    setState(() {});
                  },
                  parentCatName: _parentCategory!.name!,
                  parentCatId: _parentCategory!.id!),
            if (_category != null)
              SelectCategoryWidget(
                  key: ValueKey(_category?.name),
                  categoryType: CategoryType.subCategory,
                  onCategorySelected: (Category cat) {
                    _subCategory = cat;
                    setState(() {});
                  },
                  parentCatName: _category!.name!,
                  parentCatId: _category!.id!),
            AppTextField(
              title: "Name",
              hint: 'Enter product name',
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Product name is required";
                }
                return null;
              },
              valueChanged: (value) {
                _name = value;
                setState(() {});
              },
            ),
            AppTextField(
              title: "Quantity",
              hint: 'Enter product quantity',
              textInputType: TextInputType.number,
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Quantity is required";
                }
                return null;
              },
              valueChanged: (value) {
                _quantity = value;
                setState(() {});
              },
            ),
            SelectUomWidget(
              onUomSelected: (Uom uom) {
                _uom = uom;
                setState(() {});
              },
            ),
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
            AppTextField(
              title: "Minimum order",
              hint: 'Enter minimum order',
              textInputType: TextInputType.number,
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Minimum order is required";
                }
                return null;
              },
              valueChanged: (value) {
                _minimumOrder = value;
                setState(() {});
              },
            ),
            AppTextField(
              title: "Maximum order",
              hint: 'Enter maximum order',
              textInputType: TextInputType.number,
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Maximum order is required";
                }
                return null;
              },
              valueChanged: (value) {
                _maximumOrder = value;
                setState(() {});
              },
            ),
            if (_parentCategory != null)
              SelectBrandWidget(
                key: ValueKey(_parentCategory),
                onBrandSelected: (Brand brand) {
                  _brand = brand;
                  setState(() {});
                },
                parentCatId: _parentCategory!.id!.toInt(),
                parentCatName: _parentCategory!.name!,
              ),
            SelectCountryWidget(
              onCountrySelected: (Country country) {
                _country = country;
                setState(() {});
              },
            ),
            SelectProductTypeWidget(
              onProductTypeSelected: (ProductType productType) {
                _productType = productType;
                setState(() {});
              },
            ),
            SelectDiscountTypeWidget(
              onDiscountTypeSelected: (DiscountType discountType) {
                _discountType = discountType;
                setState(() {});
              },
            ),
            if (_discountType?.name == 'Discounted')
              AppTextField(
                title: "Discount Percentage",
                hint: '%',
                maxLength: 3,
                formFieldValidator: (value) {
                  if (value?.isEmpty == true) {
                    return "Discount percentage is required";
                  }
                  return null;
                },
                textInputType: TextInputType.number,
                valueChanged: (value) {
                  _discountValue = value;
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
            AppTextField(
              title: "Product Description (use '-' to separate points) ",
              hint: '',
              maxLines: 8,
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Product description is required";
                }
                return null;
              },
              valueChanged: (value) {
                _productDescription = value;
                setState(() {});
              },
            ),
            AppTextField(
              title: "Special Instructions (use '-' to separate points) ",
              hint: '',
              maxLines: 8,
              formFieldValidator: (value) {
                if (value?.isEmpty == true) {
                  return "Special instructions is required";
                }
                return null;
              },
              valueChanged: (value) {
                _specialInstruction = value;
                setState(() {});
              },
            ),
            const SizedBox(height: 14),
            AppButtonWidget(
              text: "Proceed",
              onClick: () {
                if (_parentCategory == null) {
                  context.displaySnack("Parent category is required");
                  return;
                }

                if (_category == null) {
                  context.displaySnack("Category is required");
                  return;
                }

                if (_subCategory == null) {
                  context.displaySnack("Sub category is required");
                  return;
                }

                if (_uom == null) {
                  context.displaySnack("Unit of measure is required");
                  return;
                }

                if (_country == null) {
                  context.displaySnack("Country of origin is required");
                  return;
                }

                if (_productType == null) {
                  context.displaySnack("Product type is required");
                  return;
                }

                if (_discountType == null) {
                  context.displaySnack("Discount type is required");
                  return;
                }

                if (_formKey.currentState?.validate() == true) {
                  final addProduct = AddProduct(
                      countryOfOrigin: _country?.name,
                      createdBy: "null",
                      currency: "ETB",
                      isDiscounted: (_discountType == null ? 0 : 1).toString(),
                      manufucturer: _brand?.id.toString(),
                      maxOrder: _maximumOrder,
                      minOrder: _minimumOrder,
                      productCategoryId: _category?.id.toString(),
                      productDescription:
                          _formatDescription(_productDescription!),
                      productName: _name,
                      productParentCateoryId: _parentCategory?.id.toString(),
                      productSubCategoryId: _subCategory?.id.toString(),
                      quantity: _quantity,
                      soldQuantity: "1",
                      specialInstruction:
                          _formatDescription(_specialInstruction!),
                      tax: "0",
                      unitOfMeasure: _uom?.id.toString(),
                      unitPrice: _unitPrice,
                      shortDescription: _shortDescription,
                      discountType: _discountType?.name == "Discounted"
                          ? "FIXED"
                          : "PERCENTAGE",
                      productType: _productType?.name,
                      discountValue: _discountValue.toString());

                  Navigator.pushNamed(context, AddProductVariantPage.routeName,
                      arguments: {
                        "sub_cat_id": _subCategory?.id,
                        "add_product": addProduct
                      });
                }
              },
            ),
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }

  String _formatDescription(String description) {
    final descriptions = <Map>[];
    description.split("-").forEach((element) {
      if (element.isNotEmpty) {
        final data = {"data": element.trim()};
        descriptions.add(data);
      }
    });
    return jsonEncode(descriptions);
  }
}
