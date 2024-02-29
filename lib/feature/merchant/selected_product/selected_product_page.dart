import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal_admin_flutter/app/di/injector.dart';
// import 'package:commercepal_admin_flutter/app/utils/string_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_registration_step2.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:flutter/material.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/products/domain/models/product.dart';
import '../../../core/widgets/title_with_description_widget.dart';
import '../add_sub_product/add_sub_product_page.dart';
import '../upload_product_image/upload_product_image.dart';
import 'package:http/http.dart' as http;

class SelectedProductPage extends StatefulWidget {
  static const routeName = "/selected_product";

  const SelectedProductPage({super.key});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class ManufacturerData {
  final String id;
  final String name;
  ManufacturerData({required this.id, required this.name});
}

class SubCategoryData {
  final String id;
  final String unique_name;
  SubCategoryData({required this.id, required this.unique_name});
}

class ProductCategory {
  final String id;
  final String name;
  ProductCategory({required this.id, required this.name});
}

class ParentCategoryData {
  final String id;
  final String name;
  ParentCategoryData({required this.id, required this.name});
}

class UoMData {
  final String Id;
  final String UoM;
  UoMData({required this.Id, required this.UoM});
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  var editting = false;
  var loading = false;
  var canEdit = true;
  List<CountryData> countries = [];
  List<ManufacturerData> manufacturer = [];
  List<UoMData> uom = [];
  List<SubCategoryData> subCat = [];
  List<ProductCategory> proCat = [];
  List<ParentCategoryData> parCat = [];
  String? myParentCategory;
  String? myProductCategory;
  String? myProductSubCategory;
  String? myProductName;
  String? myProductQuantity;
  String? myProductUoM;
  String? myProductUnitPrice;
  String? myProductMinOrder;
  String? myProductMaxOrder;
  String? myProductManufacturer;
  String? myProductCountry;
  String? myProductType;
  String? myProductDiscount;
  String? myProductDiscountPercentage;
  String? myProductShortDisc;
  String? myProductDisc;
  String? myProductSpecialInstructions;
  // late Product product;
  @override
  void initState() {
    super.initState();
    fetchCountry();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    final Product product = args['product'];
    printAll(product);
    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
        jsonDecode(product.productDescription!));
    List<Map<String, dynamic>> dataList2 = List<Map<String, dynamic>>.from(
        jsonDecode(product.specialInstruction!));
    String formattedData = dataList.map((item) => item['data']).join('-');
    String formattedData2 = dataList2.map((item) => item['data']).join('-');
    /////////////
    ///myProductCountry
    myProductDiscountPercentage =
        myProductDiscountPercentage ?? product.discountAmount.toString();
    myProductManufacturer =
        myProductManufacturer ?? product.manufacturer.toString();
    myProductMaxOrder = myProductMaxOrder ?? product.maxOrder.toString();
    myProductMinOrder = myProductMinOrder ?? product.minOrder.toString();
    myProductCategory =
        myProductCategory ?? product.productCategoryId.toString();
    myProductDisc = myProductDisc ?? formattedData;
    myProductName = myProductName ?? product.productName.toString();
    myParentCategory =
        myParentCategory ?? product.productParentCategoryId.toString();
    myProductSubCategory =
        myProductSubCategory ?? product.productSubCategoryId.toString();
    myProductType = myProductType ?? product.productType.toString();
    myProductQuantity = myProductQuantity ?? product.quantity.toString();
    myProductShortDisc =
        myProductQuantity ?? product.shortDescription.toString();
    myProductSpecialInstructions =
        myProductSpecialInstructions ?? formattedData2;
    myProductUoM = myProductUoM ?? product.unitOfMeasure.toString();
    myProductUnitPrice = myProductUnitPrice ?? product.unitPrice.toString();
    myProductCountry = myProductCountry ?? 'ET';
    // pro = product;
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      floatingActionButton: !editting
          ? FloatingActionButton(
              onPressed: () async {
                bool done = await fetchAll(product.productCategoryId.toString(),
                    product.productParentCategoryId.toString());
                if (done) {
                  setState(() {
                    editting = true;
                    canEdit = true;
                    // fetchManufacturer(product.productCategoryId.toString());
                    // fetchUoM(product.productCategoryId.toString());
                    // fetchSubCategory(product.productCategoryId.toString());
                    // fetchProductCategory(product.productCategoryId.toString());
                    // fetchParentCategory(product.productCategoryId.toString());
                  });
                }
              },
              child: loading ? CircularProgressIndicator() : Icon(Icons.edit),
            )
          : null,
      body: editting
          ? Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    setState(() {
                      editting = false;
                      canEdit = false;
                    });
                  },
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
                title: const Text(
                  'Edit Product',
                  style: TextStyle(
                      color: AppColors.colorPrimaryDark, fontSize: 16),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: !canEdit
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Form(
                          child: Column(children: [
                            if (product.productParentCategoryId != null)
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text("Parent Category"),
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
                              items: parCat.map((ParentCategoryData par) {
                                return DropdownMenuItem<String>(
                                  value: par.id.toString(),
                                  child: Text(
                                    par.name,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  myParentCategory = value;
                                });
                              },
                              value: product.productParentCategoryId != null
                                  ? parCat.any((par) =>
                                          par.id.toString() ==
                                          product.productParentCategoryId
                                              .toString())
                                      ? product.productParentCategoryId
                                          .toString()
                                      : null
                                  : null,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Parent category field is required';
                                }
                                return null;
                              },
                            ),
                            if (product.productParentCategoryId != null)
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text("Product Category"),
                                  ),
                                ],
                              ),
                            if (product.productCategoryId != null)
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
                                onChanged: (value) {
                                  setState(() {
                                    myProductCategory = value;
                                  });
                                },
                                value: product.productCategoryId != null
                                    ? proCat.any((par) =>
                                            par.id.toString() ==
                                            product.productCategoryId
                                                .toString())
                                        ? product.productCategoryId.toString()
                                        : null
                                    : null,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Product category field is required';
                                  }
                                  return null;
                                },
                              ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Sub-Category"),
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
                              onChanged: (value) {
                                setState(() {
                                  myProductSubCategory = value;
                                });
                              },
                              value: product.productSubCategoryId != null
                                  ? subCat.any((par) =>
                                          par.id.toString() ==
                                          product.productSubCategoryId
                                              .toString())
                                      ? product.productSubCategoryId.toString()
                                      : null
                                  : null,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Product sub category field is required';
                                }
                                return null;
                              },
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Name"),
                                ),
                              ],
                            ),
                            TextFormField(
                              initialValue: product.productName,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                setState(() {
                                  myProductName = value;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Product name is required';
                                }
                                return null;
                              },
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
                              initialValue: product.quantity.toString(),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductQuantity = value;
                                });
                              },
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
                              value: product.unitOfMeasure != null
                                  ? uom.any((par) =>
                                          par.Id.toString() ==
                                          product.unitOfMeasure.toString())
                                      ? product.unitOfMeasure.toString()
                                      : null
                                  : null,
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
                                  child: Text("Unit Price"),
                                ),
                              ],
                            ),
                            TextFormField(
                              initialValue:
                                  product.unitPrice.toString() ?? null,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductUnitPrice = value;
                                });
                              },
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
                                  child: Text("Min Order"),
                                ),
                              ],
                            ),
                            TextFormField(
                              initialValue: product.minOrder.toString() ?? null,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductMinOrder = value;
                                });
                              },
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
                              initialValue: product.maxOrder.toString() ?? null,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductMaxOrder = value;
                                });
                              },
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
                                  child: Text("Manufacturer"),
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
                              items: manufacturer.map((ManufacturerData man) {
                                return DropdownMenuItem<String>(
                                  value: man.id,
                                  child: Text(
                                    man.name,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  myProductManufacturer = value;
                                });
                              },
                              value: product.manufacturer != null
                                  ? manufacturer.any((par) =>
                                          par.id.toString() ==
                                          product.manufacturer.toString())
                                      ? product.manufacturer.toString()
                                      : null
                                  : null,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Product manufacturer field is required';
                                }
                                return null;
                              },
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Country of Origin"),
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
                              items: countries.map((CountryData con) {
                                return DropdownMenuItem<String>(
                                  value: con.countryCode,
                                  child: Text(
                                    con.country,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  myProductCountry = value;
                                });
                              },
                              value: 'ET',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Product origin country field is required';
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
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.greyColor,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'Retail',
                                  child: Text(
                                    'Retail',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Wholesale',
                                  child: Text(
                                    'Wholesale',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  myProductType = value;
                                });
                              },
                              value: product.productType
                                          .toString()[0]
                                          .toUpperCase() +
                                      product.productType
                                          .toString()
                                          .toLowerCase()
                                          .substring(1),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Product type field is required';
                                }
                                return null;
                              },
                            ),
                            // const Row(
                            //   children: [
                            //     Padding(
                            //       padding: EdgeInsets.symmetric(vertical: 8.0),
                            //       child: Text("Is Discounted"),
                            //     ),
                            //   ],
                            // ),
                            // DropdownButtonFormField<String>(
                            //   decoration: const InputDecoration(
                            //     filled: true,
                            //     fillColor: AppColors.greyColor,
                            //     focusedBorder: InputBorder.none,
                            //     focusedErrorBorder: InputBorder.none,
                            //     enabledBorder: InputBorder.none,
                            //   ),
                            //   items: const [
                            //     DropdownMenuItem<String>(
                            //       value: 'PERCENTAGE',
                            //       child: Text(
                            //         'Discounted',
                            //         style: TextStyle(
                            //             fontSize: 14, color: Colors.black),
                            //       ),
                            //     ),
                            //     DropdownMenuItem<String>(
                            //       value: 'Fixed',
                            //       child: Text(
                            //         'Not discounted',
                            //         style: TextStyle(
                            //             fontSize: 14, color: Colors.black),
                            //       ),
                            //     ),
                            //   ],
                            //   onChanged: (value) {
                            //     setState(() {
                            //       myProductDiscount = value;
                            //     });
                            //   },
                            //   value: product.discountType.toString() ?? null,
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'Product discount field is required';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Discount Percentage"),
                                ),
                              ],
                            ),
                            TextFormField(
                              initialValue:
                                  product.discountValue.toString(),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductDiscountPercentage = value;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Product discount percentage is required';
                                }
                                return null;
                              },
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Short Description"),
                                ),
                              ],
                            ),
                            TextFormField(
                              maxLines: 3,
                              initialValue:
                                  product.shortDescription.toString(),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  myProductShortDisc = value;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Product short description is required';
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
                              maxLines: 6,
                              initialValue: formattedData,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  myProductDisc = value;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty == true) {
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
                              maxLines: 6,
                              initialValue: formattedData2,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.greyColor,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                              // : 'Full Name',
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  myProductSpecialInstructions = value;
                                });
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 0.1,
                            ),
                            SizedBox(
                              width: sWidth * 0.9,
                              height: sHeight * 0.06,
                              child: ElevatedButton(
                                  onPressed: loading
                                      ? () {}
                                      : () async {
                                          bool done = await verifyForm(
                                              product.productId.toString());
                                          if (done) {
                                            context.displaySnack(
                                                "Edited Successfully");
                                            Navigator.popAndPushNamed(
                                                context,
                                                MerchantDashboardPage
                                                    .routeName);
                                          }
                                        },
                                  child: const Text("Submit")),
                            ),
                            SizedBox(
                              height: 0.1,
                            ),
                          ]),
                        ),
                )),
              ),
            )
          : AppScaffold(
              appBarTitle: '${product.productName}',
              subTitle:
                  "${product.productCategoryIdName} - ${product.productSubCategoryIdName}",
              child: ListView(
                children: [
                  TitleWithDescriptionWidget(
                    title: "Name",
                    description: "${product.productName}",
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Price",
                    description: "ETB ${product.unitPrice ?? ""}",
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Ratings",
                    description: "${product.productRating ?? ""}",
                  ),
                  const Divider(),
                  Text(
                    "Images",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: product.productImages?.isEmpty == true
                          ? [
                              CachedNetworkImage(
                                fit: BoxFit.contain,
                                height: 120,
                                placeholder: (_, __) => Container(
                                  color: AppColors.bg1,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: Colors.grey,
                                ),
                                imageUrl: product.mobileImage ?? '',
                              )
                            ]
                          : product.productImages!
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      height: 120,
                                      placeholder: (_, __) => Container(
                                        color: AppColors.bg1,
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        color: Colors.grey,
                                      ),
                                      imageUrl: e,
                                    ),
                                  ))
                              .toList(),
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
                            'name': product.productName,
                            'prod_id': product.productId,
                            'image_type': ImageTypes.productImages
                          });

                      // update images
                      product.productImages = (result as List<String>);
                      setState(() {});
                    },
                    child: const Text("Add image"),
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Short Description",
                    description: "${product.shortDescription}",
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Description",
                    description:
                        extractInstructions(product.productDescription!),
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                      title: "Special Instructions",
                      description: product.specialInstruction != null
                          ? extractInstructions(product.specialInstruction!)
                          : ''),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Discount Type",
                    description: "${product.discountType}",
                  ),
                  const Divider(),
                  TitleWithDescriptionWidget(
                    title: "Discount Amount",
                    description: "${product.discountAmount}",
                  ),
                  const Divider(),
                  if (product.subProducts?.isNotEmpty == true)
                    Text(
                      "Sub Products",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                    ),
                  if (product.subProducts?.isNotEmpty == true)
                    const SizedBox(
                      height: 10,
                    ),
                  if (product.subProducts?.isNotEmpty == true)
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final subProduct = product.subProducts?[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, UploadProductImage.routeName,
                                arguments: {
                                  'name': subProduct?.shortDescription,
                                  'prod_id': subProduct?.subProductId,
                                  'image_type': ImageTypes.subProductImages
                                });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorPrimary
                                          .withOpacity(0.2),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    height: 50,
                                    width: 50,
                                    placeholder: (_, __) => Container(
                                      color: AppColors.bg1,
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: Colors.grey,
                                    ),
                                    imageUrl: product
                                            .subProducts![index].mobileImage ??
                                        '',
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.subProducts![index]
                                            .shortDescription ??
                                        '',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.add_a_photo_outlined)
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 5,
                      ),
                      itemCount: product.subProducts!.length,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, AddSubProductPage.routeName,
                          arguments: {
                            "product_id": product.productId,
                            "sub_cat_id": product.productSubCategoryId,
                            "name": product.productName,
                          });
                    },
                    child: const Text("Add Sub product"),
                  ),
                ],
              ),
            ),
    );
  }

  String extractInstructions(String instruction) {
    String instructions = "";
    jsonDecode(instruction).forEach((element) {
      final data = element['data'];
      instructions = "$instructions- $data\n";
    });

    return instructions;
  }

  Future<bool> verifyForm(String id) async {
    try {
      setState(() {
        loading = true;
      });
      List<String> dataItems = myProductDisc!.split('-');
      List<Map<String, dynamic>> dataList =
          dataItems.map((item) => {'data': item.trim()}).toList();
      myProductDisc = jsonEncode(dataList);
      List<String> dataItems2 = myProductSpecialInstructions!.split('-');
      List<Map<String, dynamic>> dataList2 =
          dataItems2.map((item) => {'data': item.trim()}).toList();
      myProductSpecialInstructions = jsonEncode(dataList2);
      // List<Map<String, dynamic>> dataList =
      //     dataItems.map((item) => {'data': item}).toList();
      // List<String> dataItems2 = myProductSpecialInstructions!.split('-');
      // List<Map<String, dynamic>> dataList2 =
      //     dataItems2.map((item) => {'data': item}).toList();
      // myProductSpecialInstructions = jsonEncode(dataList2);

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "productId": id,
        "countryOfOrigin": myProductCountry,
        "discountValue": myProductDiscountPercentage,
        "manufucturer": myProductManufacturer,
        "maxOrder": myProductMaxOrder,
        "minOrder": myProductMinOrder,
        "productCategoryId": myProductCategory,
        "productDescription": myProductDisc,
        "productName": myProductName,
        "productParentCateoryId": myParentCategory,
        "productSubCategoryId": myProductSubCategory,
        "productType": myProductType,
        "quantity": myProductQuantity,
        "shortDescription": myProductShortDisc,
        "specialInstruction": myProductSpecialInstructions,
        "unitOfMeasure": myProductUoM,
        "unitPrice": myProductUnitPrice
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

  Future<void> fetchCountry() async {
    try {
      setState(() {
        loading = true;
      });
      print("country");
      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/countries"));
      // print(response.body);
      var data = jsonDecode(response.body);
      countries.clear();
      for (var b in data['data']) {
        countries.add(
            CountryData(countryCode: b['countryCode'], country: b['country']));
      }
      print(countries.length);
      setState(() {
        loading = false;
      });
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<bool> fetchManufacturer(String id) async {
    try {
      setState(() {
        loading = true;
      });
      print("manu");
      print(id);
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/category/GetBrands",
        {'parentCat': id},
      ));
      var data = jsonDecode(response.body);
      manufacturer.clear();
      for (var b in data['details']) {
        manufacturer
            .add(ManufacturerData(name: b['name'], id: b['id'].toString()));
      }
      print(manufacturer.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = manufacturer.length > 0;
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
      bool success = uom.length > 0;
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

  Future<bool> fetchAll(String id, String id2) async {
    try {
      await fetchCountry();
      await fetchManufacturer(id2);
      await fetchParentCategory();
      await fetchSubCategory(id);
      await fetchProductCategory(id2);
      await fetchUoM(id);
      return true;
    } catch (e) {
      setState(() {
        loading = true;
      });
      return false;
    }
  }

  void printAll(Product pro) async {
    print("start");
    print(pro.manufacturer);
    print(pro.unitOfMeasure);
    print(pro.productSubCategoryId);
    print(pro.productParentCategoryId);
    print(pro.productCategoryId);
    print("end");
  }
}
