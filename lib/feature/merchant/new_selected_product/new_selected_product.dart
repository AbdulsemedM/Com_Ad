import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product.dart';
import 'package:commercepal_admin_flutter/core/widgets/title_with_description_widget.dart';
import 'package:commercepal_admin_flutter/feature/merchant/add_sub_product/add_sub_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_product/selected_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/sub_category/sub_categories_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/upload_product_image/upload_product_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewSelectedProduct extends StatefulWidget {
  final Product myProduct;
  const NewSelectedProduct({required this.myProduct, super.key});

  @override
  State<NewSelectedProduct> createState() => _NewSelectedProductState();
}

class _NewSelectedProductState extends State<NewSelectedProduct> {
  void fetchInvetoryData() async {
    setState(() {
      loading = true;
    });
    print("here discount");
    print(widget.myProduct.discountType);
    myProductUoM = widget.myProduct.unitOfMeasure;
    myProductDiscount = widget.myProduct.discountType == "NotDiscounted"
        ? "FIXED"
        : "PERCENTAGE";
    myProductUnitPrice.text = widget.myProduct.unitPrice.toString();
    myProductDiscountPercentage.text =
        widget.myProduct.discountValue.toString();
    myProductMaxOrder.text = widget.myProduct.maxOrder.toString();
    myProductMinOrder.text = widget.myProduct.minOrder.toString();
    myProductQuantity.text = widget.myProduct.quantity.toString();
    // myProductTax.text ;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.myProduct.specialInstruction);
    fetchUoM(widget.myProduct.productCategoryId.toString());
    fetchParentCategory();
    fetchProductCategory(widget.myProduct.productParentCategoryId.toString());
    fetchSubCategory(widget.myProduct.productCategoryId.toString());
    myParentCategory = widget.myProduct.productParentCategoryId.toString();
    myProductCategory = widget.myProduct.productCategoryId.toString();
    myProductSubCategory = widget.myProduct.productSubCategoryId.toString();
    productName.text = widget.myProduct.productName.toString();
    myProductType = widget.myProduct.productType.toString() == "Retail"
        ? "RETAIL"
        : widget.myProduct.productType.toString();
    myProductDisc.text =
        extractInstructions(widget.myProduct.productDescription.toString());
    myProductSpecialInstructions.text =
        extractInstructions(widget.myProduct.specialInstruction.toString());
  }

  var editting = false;
  var loading = false;
  List<UoMData> uom = [];
  String? myProductUoM;
  String? myProductDiscount;
  TextEditingController myProductUnitPrice = TextEditingController();
  TextEditingController myProductDiscountPercentage = TextEditingController();
  TextEditingController myProductMaxOrder = TextEditingController();
  TextEditingController myProductMinOrder = TextEditingController();
  TextEditingController myProductQuantity = TextEditingController();
  TextEditingController myProductTax = TextEditingController();
  final GlobalKey<FormState> myKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? myParentCategory;
  String? myProductCategory;
  String? myProductSubCategory;
  final TextEditingController productName = TextEditingController();
  String? myProductType;
  final TextEditingController myProductDisc = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController myProductSpecialInstructions =
      TextEditingController();
  // String? myProductSpecialInstructions;
  List<SubCategoryData> subCat = [];
  List<ProductCategory> proCat = [];
  List<ParentCategoryData> parCat = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          widget.myProduct.unitPrice.toString() != "0" && editting == false
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() async {
                      fetchInvetoryData();
                      editting = true;
                    });
                  },
                  child: Icon(Icons.edit),
                )
              : null,
      appBar: AppBar(
          title: widget.myProduct.unitPrice.toString() == "0" && !editting
              ? Text("Add Inventory data to ${widget.myProduct.productName}")
              : widget.myProduct.unitPrice.toString() != "0" && !editting
                  ? Text("Inventory data of ${widget.myProduct.productName}")
                  : widget.myProduct.unitPrice.toString() != "0" && editting
                      ? Text("Edit ${widget.myProduct.productName}")
                      : null),
      body: widget.myProduct.unitPrice.toString() == '0'
          ? SingleChildScrollView(
              child: Form(
                key: myKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Unit Price"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductUnitPrice,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,
                        // onChanged: (value) {
                        //   setState(() {
                        //     myProductUnitPrice = value;
                        //   });
                        // },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product unit price is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Unit of Measure"),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        items: uom.map((UoMData m) {
                          return DropdownMenuItem<String>(
                            value: m.Id,
                            child: Text(
                              m.UoM,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            myProductUoM = value;
                          });
                        },
                        // value: product.unitOfMeasure != null
                        //     ? uom.any((par) =>
                        //             par.Id.toString() ==
                        //             product.unitOfMeasure.toString())
                        //         ? product.unitOfMeasure.toString()
                        //         : null
                        //     : null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product unit of measure field is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Is Discounted"),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.greyColor,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'PERCENTAGE',
                            child: Text(
                              'Discounted',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Fixed',
                            child: Text(
                              'Not discounted',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            myProductDiscount = value;
                            if (myProductDiscount == "Fixed") {
                              myProductDiscountPercentage.text = "0";
                            } else {
                              myProductDiscountPercentage.clear();
                            }
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product discount field is required';
                          }
                          return null;
                        },
                      ),
                      if (myProductDiscount != null &&
                          myProductDiscount != "Fixed")
                        Column(
                          children: [
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Discount Percentage"),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: myProductDiscountPercentage,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,

                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Product discount percentage is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Quantity"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductQuantity,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product quantity is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Min Order"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductMinOrder,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product min order is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Max Order"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductMaxOrder,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product max order is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Tax"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductTax,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product tax is required';
                          }
                          return null;
                        },
                      ),
                      loading
                          ? const CircularProgressIndicator(
                              color: AppColors.colorPrimaryDark,
                            )
                          : SizedBox(
                              width: 350,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.colorPrimaryDark),
                                  onPressed: () async {
                                    print(myKey.currentState!.validate());
                                    if (myKey.currentState!.validate()) {
                                      bool done = await verifyForm();
                                      print(done);
                                      if (done) {
                                        // ignore: use_build_context_synchronously
                                        displaySnack(context,
                                            "Product inventory data filled successfully.");
                                        // ignore: use_build_context_synchronously
                                        Navigator.popUntil(
                                            context,
                                            (route) =>
                                                route.settings.name ==
                                                SubCategoriesPage.routeName);
                                      }
                                    } else {
                                      displaySnack(context,
                                          "Please fill all the fields.");
                                    }
                                  },
                                  child: const Text("Add Product")),
                            )
                    ],
                  ),
                ),
              ),
            )
          : widget.myProduct.unitPrice.toString() != "0" && editting == false
              ? Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView(
                        children: [
                          TitleWithDescriptionWidget(
                            title: "Name",
                            description: "${widget.myProduct.productName}",
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Price",
                            description:
                                "ETB ${widget.myProduct.unitPrice ?? ""}",
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Ratings",
                            description:
                                "${widget.myProduct.productRating ?? ""}",
                          ),
                          const Divider(),
                          Text(
                            "Images",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children:
                                    // (product.productImages?.isEmpty ?? true) ||
                                    //         product.productImages == null
                                    //     ?
                                    [
                              (widget.myProduct.productImages?.isEmpty ?? true)
                                  ? CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      height: 120,
                                      placeholder: (_, __) => Container(
                                        color: AppColors.bg1,
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        color: Colors.grey,
                                      ),
                                      imageUrl:
                                          widget.myProduct.mobileImage ?? '',
                                    )
                                  : Container()
                            ]
                                // : product.productImages!
                                //     .where((e) => e != null)
                                //     .map((e) => Padding(
                                //           padding: const EdgeInsets.all(8.0),
                                //           child: CachedNetworkImage(
                                //             fit: BoxFit.contain,
                                //             height: 120,
                                //             placeholder: (_, __) => Container(
                                //               color: AppColors.bg1,
                                //             ),
                                //             errorWidget: (_, __, ___) => Container(
                                //               color: Colors.grey,
                                //             ),
                                //             imageUrl: e ?? '',
                                //           ),
                                //         ))
                                //     .toList(),
                                ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            onPressed: () async {
                              // await image urls
                              final result = await Navigator.pushNamed(
                                  context, UploadProductImage.routeName,
                                  arguments: {
                                    'name': widget.myProduct.productName,
                                    'prod_id': widget.myProduct.productId,
                                    'image_type': ImageTypes.productImages
                                  });

                              // update images
                              widget.myProduct.productImages =
                                  (result as List<String>);
                              setState(() {});
                            },
                            child: const Text("Add image"),
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Short Description",
                            description: "${widget.myProduct.shortDescription}",
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Description",
                            description: extractInstructions(
                                widget.myProduct.productDescription!),
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                              title: "Special Instructions",
                              description:
                                  widget.myProduct.specialInstruction != null
                                      ? extractInstructions(
                                          widget.myProduct.specialInstruction!)
                                      : ''),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Discount Type",
                            description: "${widget.myProduct.discountType}",
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Discount Amount",
                            description: "${widget.myProduct.discountAmount}",
                          ),
                          const Divider(),
                          if (widget.myProduct.subProducts?.isNotEmpty == true)
                            Text(
                              "Sub Products",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(),
                            ),
                          if (widget.myProduct.subProducts?.isNotEmpty == true)
                            const SizedBox(
                              height: 10,
                            ),
                          if (widget.myProduct.subProducts?.isNotEmpty == true)
                            ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final subProduct =
                                    widget.myProduct.subProducts?[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, UploadProductImage.routeName,
                                        arguments: {
                                          'name': subProduct?.shortDescription,
                                          'prod_id': subProduct?.subProductId,
                                          'image_type':
                                              ImageTypes.subProductImages
                                        });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.colorPrimary
                                                  .withOpacity(0.2),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            height: 50,
                                            width: 50,
                                            placeholder: (_, __) => Container(
                                              color: AppColors.bg1,
                                            ),
                                            errorWidget: (_, __, ___) =>
                                                Container(
                                              color: Colors.grey,
                                            ),
                                            imageUrl: widget
                                                    .myProduct
                                                    .subProducts![index]
                                                    .mobileImage ??
                                                '',
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.myProduct.subProducts![index]
                                                    .shortDescription ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.add_a_photo_outlined)
                                        ],
                                      )),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(
                                height: 5,
                              ),
                              itemCount: widget.myProduct.subProducts!.length,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, AddSubProductPage.routeName,
                                  arguments: {
                                    "product_id": widget.myProduct.productId,
                                    "sub_cat_id":
                                        widget.myProduct.productSubCategoryId,
                                    "name": widget.myProduct.productName,
                                  });
                            },
                            child: const Text("Add Sub product"),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : widget.myProduct.unitPrice.toString() != "0" && editting == true
                  ? Scaffold(
                      body: _buildEditProductForm(),
                    )
                  : null,
    );
  }

  Widget _buildEditProductForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Parent Category"),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: widget.myProduct.productParentCategoryId.toString(),
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  items: parCat.map((ParentCategoryData par) {
                    return DropdownMenuItem<String>(
                      value: par.id.toString(),
                      child: Text(
                        par.name,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      myProductCategory = null;
                      myProductSubCategory = null;
                      myParentCategory = value;
                      fetchProductCategory(myParentCategory!);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Parent category field is required';
                    }
                    return null;
                  },
                ),
                if (myParentCategory != null ||
                    widget.myProduct.productParentCategoryId != null)
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Product Category"),
                      ),
                    ],
                  ),
                if ((myParentCategory != null && !loading) ||
                    widget.myProduct.productParentCategoryId != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    items: proCat.map((ProductCategory pro) {
                      // print(pro.name);
                      return DropdownMenuItem<String>(
                        value: pro.id.toString(),
                        child: Text(
                          pro.name,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    value: myProductCategory,
                    onChanged: (value) {
                      setState(() {
                        myProductSubCategory = null;
                        myProductCategory = value;
                        fetchSubCategory(myProductCategory!);
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Product category field is required';
                      }
                      return null;
                    },
                  ),
                if ((myProductCategory != null && !loading) ||
                    widget.myProduct.productCategoryId != null)
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Sub-Category"),
                      ),
                    ],
                  ),
                if ((myProductCategory != null && !loading) ||
                    widget.myProduct.productCategoryId != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    items: subCat.map((SubCategoryData sub) {
                      return DropdownMenuItem<String>(
                        value: sub.id,
                        child: Text(
                          sub.unique_name,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    value: myProductSubCategory,
                    onChanged: (value) {
                      setState(() {
                        myProductSubCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Product sub category field is required';
                      }
                      return null;
                    },
                  ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Product Name"),
                    ),
                  ],
                ),
                TextFormField(
                  // initialValue: "",
                  controller: productName,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.text,
                  // onChanged: (value) {
                  //   setState(() {
                  //     productName = value;
                  //   });
                  // },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Product Type"),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: myProductType,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyColor,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'RETAIL',
                      child: Text(
                        'Retail',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'WHOLESALE',
                      child: Text(
                        'Wholesale',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      myProductType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Product type field is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          "Product Description (Use '-' to separate points)"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductDisc,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.text,
                  // onChanged: (value) {
                  //   setState(() {
                  //     myProductDisc = value;
                  //   });
                  // },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product description is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          "Special Instructions (Use '-' to separate points)"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductSpecialInstructions,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.text,
                  // onChanged: (value) {
                  //   setState(() {
                  //     myProductSpecialInstructions = value;
                  //   });
                  // },
                  validator: (value) {
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Unit Price"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductUnitPrice,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.number,
                  // onChanged: (value) {
                  //   setState(() {
                  //     myProductUnitPrice = value;
                  //   });
                  // },
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Product unit price is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Unit of Measure"),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  items: uom.map((UoMData m) {
                    return DropdownMenuItem<String>(
                      value: m.Id,
                      child: Text(
                        m.UoM,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      myProductUoM = value;
                    });
                  },
                  value: myProductUoM,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product unit of measure field is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Is Discounted"),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: myProductDiscount,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyColor,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'PERCENTAGE',
                      child: Text(
                        'Discounted',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'FIXED',
                      child: Text(
                        'Not discounted',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      myProductDiscount = value;
                      if (myProductDiscount == "Fixed") {
                        myProductDiscountPercentage.text = "0";
                      } else {
                        myProductDiscountPercentage.clear();
                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product discount field is required';
                    }
                    return null;
                  },
                ),
                if (myProductDiscount != null && myProductDiscount != "Fixed")
                  Column(
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Discount Percentage"),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: myProductDiscountPercentage,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.number,

                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product discount percentage is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Quantity"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductQuantity,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Product quantity is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Min Order"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductMinOrder,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Product min order is required';
                    }
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Max Order"),
                    ),
                  ],
                ),
                TextFormField(
                  controller: myProductMaxOrder,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  // : 'Full Name',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Product max order is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                loading
                    ? const CircularProgressIndicator(
                        color: AppColors.colorPrimaryDark,
                      )
                    : SizedBox(
                        width: 350,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimaryDark),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool done = await verifyForm2(
                                    widget.myProduct.productId.toString());
                                // bool done2 = await verifyForm2();
                                print(done);
                                // print(done2);
                                if (done) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.popUntil(
                                      context,
                                      (route) =>
                                          route.settings.name ==
                                          SubCategoriesPage.routeName);
                                }
                              } else {
                                displaySnack(context,
                                    "Please fill all the necessary fields.");
                              }
                            },
                            child: const Text("Edit Product")),
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> fetchSubCategory(String id) async {
    try {
      setState(() {
        loading = true;
      });
      print("subcat");
      print(id);
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/category/GetSubCategories",
        {'category': id},
      ));
      var data = jsonDecode(response.body);
      subCat.clear();
      for (var b in data['details']) {
        subCat.add(
            SubCategoryData(unique_name: b['name'], id: b['id'].toString()));
      }
      print(subCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = subCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> fetchProductCategory(String id) async {
    try {
      setState(() {
        loading = true;
      });
      print("product category");
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/category/GetCategories",
        {'parentCat': id},
      ));
      var data = jsonDecode(response.body);
      proCat.clear();
      for (var b in data['details']) {
        proCat.add(ProductCategory(name: b['name'], id: b['id'].toString()));
      }
      print(proCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = proCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> fetchParentCategory() async {
    try {
      setState(() {
        loading = true;
      });
      print("parent category");
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "prime/api/v1/portal/category/GetParentCategories",
      ));
      var data = jsonDecode(response.body);
      parCat.clear();
      for (var b in data['details']) {
        parCat.add(ParentCategoryData(name: b['name'], id: b['id'].toString()));
      }
      print(parCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = parCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String extractInstructions(String instruction) {
    try {
      instruction = instruction.replaceAll(r'\"', '"');

      print("here instruction");
      print(instruction);
      String instructions = "";
      jsonDecode(instruction).forEach((element) {
        final data = element['data'];
        instructions = "$instructions- $data\n";
      });

      return instructions;
    } catch (e) {
      return '';
    }
    // instruction = instruction.replaceAll(r'\"', '"');

    // print("here instruction");
    // print(instruction);
    // String instructions = "";
    // jsonDecode(instruction).forEach((element) {
    //   final data = element['data'];
    //   instructions = "$instructions- $data\n";
    // });

    // return instructions;
  }

  String _formatDescription(String description) {
    final descriptions = <Map>[];
    description.split("-").forEach((element) {
      if (element.isNotEmpty) {
        final data = {"data": element.trim()};
        descriptions.add(data);
      }
    });
    final jsonString = jsonEncode(descriptions);
    return jsonString.replaceAll('"', r'\"');
  }

  Future<bool> fetchUoM(String id) async {
    try {
      setState(() {
        loading = true;
      });
      print("unit of measure");
      // print(id);
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/product/features/get-uom",
      ));
      var data = jsonDecode(response.body);
      uom.clear();
      for (var b in data['details']) {
        uom.add(UoMData(UoM: b['UoM'], Id: b['Id'].toString()));
      }
      print(uom.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      // bool success = uom.length > 0;
      return true;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> verifyForm2(String id) async {
    try {
      setState(() {
        loading = true;
      });
      // List<String> dataItems = myProductDisc!.split('-');
      // List<Map<String, dynamic>> dataList =
      //     dataItems.map((item) => {'data': item.trim()}).toList();
      // myProductDisc = jsonEncode(dataList);
      // List<String> dataItems2 = myProductSpecialInstructions!.split('-');
      // List<Map<String, dynamic>> dataList2 =
      //     dataItems2.map((item) => {'data': item.trim()}).toList();
      // myProductSpecialInstructions = jsonEncode(dataList2);
      print("hereeeewego");
      Map<String, dynamic> payload = {
        "productId": id,
        "productCategoryId": myProductCategory,
        "productDescription": _formatDescription(myProductDisc.text),
        "productName": productName.text,
        "productParentCateoryId": myParentCategory,
        "productSubCategoryId": myProductSubCategory,
        "productType": myProductType,
        "specialInstruction":
            _formatDescription(myProductSpecialInstructions.text),
        // "manufucturer": myProductManufacturer,
        "discountType": myProductDiscount,
        "discountValue": myProductDiscountPercentage.text,
        "isDiscounted": myProductDiscount == "FIXED" ? "0" : "1",
        "maxOrder": myProductMaxOrder.text,
        "minOrder": myProductMinOrder.text,
        "quantity": myProductQuantity.text,
        "unitOfMeasure": myProductUoM,
        "unitPrice": myProductUnitPrice.text,
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/merchant/product/update-product"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
        } else {
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "productId": int.parse(widget.myProduct.productId.toString()),
        "currency": "ETB",
        "discountType": myProductDiscount,
        "discountValue": myProductDiscountPercentage.text,
        "isDiscounted": myProductDiscount == "FIXED" ? "0" : "1",
        "maxOrder": myProductMaxOrder.text,
        "minOrder": myProductMinOrder.text,
        "quantity": myProductQuantity.text,
        "soldQuantity": "0",
        "tax": myProductTax.text,
        "unitOfMeasure": myProductUoM,
        "unitPrice": myProductUnitPrice.text
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/merchant/products/inventory-order-details"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
        } else {
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }
}
