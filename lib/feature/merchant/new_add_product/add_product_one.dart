import 'dart:convert';
import 'dart:io';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/network/api_provider.dart';
import 'package:commercepal_admin_flutter/core/network/end_points.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_cubit.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_product/selected_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/sub_category/sub_categories_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/upload_product_image/upload_product_image.dart';
import 'package:commercepal_admin_flutter/feature/merchant/upload_product_image/widgets/image_chooser_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductOne extends StatefulWidget {
  static const routeName = "/add_product_one";

  const AddProductOne({super.key});

  @override
  State<AddProductOne> createState() => _AddProductOneState();
}

class ProductVariantData {
  final String unitOfMeasure;
  final String featureName;
  final String featureId;
  ProductVariantData(
      {required this.unitOfMeasure,
      required this.featureName,
      required this.featureId});
}

class Feature {
  final String FeatureValue;
  final String UnitOfMeasure;
  final int FeatureId;
  Feature(
      {required this.FeatureValue,
      required this.UnitOfMeasure,
      required this.FeatureId});
  Map<String, dynamic> toJson() {
    return {
      'FeatureValue': FeatureValue,
      'UnitOfMeasure': UnitOfMeasure,
      'FeatureId': FeatureId
    };
  }
}

// class SubCategoryData {
//   final String id;
//   final String unique_name;
//   SubCategoryData({required this.id, required this.unique_name});
// }

// class ProductCategory {
//   final String id;
//   final String name;
//   ProductCategory({required this.id, required this.name});
// }

// class ParentCategoryData {
//   final String id;
//   final String name;
//   ParentCategoryData({required this.id, required this.name});
// }

class _AddProductOneState extends State<AddProductOne> {
  String? myParentCategory;
  String? myProductCategory;
  String? myProductSubCategory;
  final TextEditingController productName = TextEditingController();
  String? myProductType;
  final TextEditingController myProductDisc = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  // String? myProductSpecialInstructions;
  String? unitOfMeasure;
  String? featureId;
  String? pId;
  final TextEditingController _uom = TextEditingController();
  // ProductVariant? _productVariant;
  List<Feature> _addedProductVariants = [];
  List<SubCategoryData> subCat = [];
  List<ProductCategory> proCat = [];
  List<ParentCategoryData> parCat = [];
  List<ProductVariantData> variants = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey();
  var loading = false;
  var step1 = 0;
  var step2 = 0;
  var step3 = 0;
  List<UoMData> uom = [];
  String? myProductUoM;
  String? myProductDiscount;
  var apiProvider;
  TextEditingController myProductUnitPrice = TextEditingController();
  TextEditingController myProductDiscountPercentage = TextEditingController();
  TextEditingController myProductMaxOrder = TextEditingController();
  TextEditingController myProductMinOrder = TextEditingController();
  TextEditingController myProductQuantity = TextEditingController();
  final GlobalKey<FormState> myKey = GlobalKey();
  File? img1;
  File? img2;
  File? img3;
  File? img4;
  @override
  void initState() {
    super.initState();
    fetchParentCategory();
    fetchUoM();
  }

  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width;
    var sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: sWidth * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: sWidth * 0.06,
                      width: sWidth * 0.06,
                      decoration: BoxDecoration(
                          color: AppColors.colorAccent,
                          borderRadius: BorderRadius.circular(sWidth * 0.06)),
                      child: Center(
                        child: step1 == 0
                            ? Text("1")
                            : Icon(
                                Icons.done,
                                color: AppColors.bgCreamWhite,
                              ),
                      ),
                    ),
                    Container(
                      color: step1 == 0
                          ? AppColors.secondaryColor
                          : AppColors.colorAccent,
                      height: sHeight * 0.004,
                      width: sWidth * 0.15,
                    ),
                    Container(
                      height: sWidth * 0.06,
                      width: sWidth * 0.06,
                      decoration: BoxDecoration(
                          color: step1 == 0
                              ? AppColors.secondaryColor
                              : AppColors.colorAccent,
                          borderRadius: BorderRadius.circular(sWidth * 0.06)),
                      child: Center(
                        child: step1 == 1 && step2 == 1
                            ? const Icon(
                                Icons.done,
                                color: AppColors.bgCreamWhite,
                              )
                            : Text(
                                "2",
                                style: TextStyle(
                                    color: step1 == 1 && step2 == 0
                                        ? AppColors.secondaryColor
                                        : AppColors.colorAccent),
                              ),
                      ),
                    ),
                    Container(
                      color: step1 == 1 && step2 == 1
                          ? AppColors.colorAccent
                          : AppColors.secondaryColor,
                      height: sHeight * 0.004,
                      width: sWidth * 0.15,
                    ),
                    Container(
                      height: sWidth * 0.06,
                      width: sWidth * 0.06,
                      decoration: BoxDecoration(
                          color: step1 == 1 && step2 == 1 && step3 == 1
                              ? AppColors.colorAccent
                              : AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(sWidth * 0.06)),
                      child: Center(
                        child: step1 == 1 && step2 == 1 && step3 == 1
                            ? const Icon(
                                Icons.done,
                                color: AppColors.bgCreamWhite,
                              )
                            : Text(
                                "3",
                                style: TextStyle(
                                    color:
                                        step1 == 1 && step2 == 1 && step3 == 1
                                            ? AppColors.bgCreamWhite
                                            : AppColors.colorAccent),
                              ),
                      ),
                    ),
                    // Container(
                    //   color: step1 == 1 && step2 == 1 && step3 == 1
                    //       ? AppColors.colorAccent
                    //       : AppColors.secondaryColor,
                    //   height: sHeight * 0.004,
                    //   width: sWidth * 0.15,
                    // ),
                    // Container(
                    //   height: sWidth * 0.06,
                    //   width: sWidth * 0.06,
                    //   decoration: BoxDecoration(
                    //       color: step1 == 1 && step2 == 1 && step3 == 1
                    //           ? AppColors.colorAccent
                    //           : AppColors.secondaryColor,
                    //       borderRadius: BorderRadius.circular(sWidth * 0.06)),
                    //   child: Center(
                    //     child: Text(
                    //       "4",
                    //       style: TextStyle(
                    //           color: step1 == 1 && step2 == 1 && step3 == 1
                    //               ? AppColors.bgCreamWhite
                    //               : AppColors.colorAccent),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: SizedBox(
                  width: sWidth * 0.9,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Main"),
                        SizedBox(
                          width: sWidth * 0.1,
                        ),
                        Text("Inventory"),
                        SizedBox(
                          width: sWidth * 0.1,
                        ),
                        Text("Images"),
                        // SizedBox(
                        //   width: sWidth * 0.1,
                        // ),
                        // Text("Image"),
                      ]),
                ),
              ),
              if (step1 == 0)
                Form(
                  key: _formKey,
                  child: Padding(
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
                          value: myParentCategory,
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
                              _addedProductVariants.clear();
                              myProductCategory = null;
                              myProductSubCategory = null;
                              featureId = null;
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
                        if (myParentCategory != null)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Product Category"),
                              ),
                            ],
                          ),
                        if (myParentCategory != null && !loading)
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
                                _addedProductVariants.clear();
                                featureId = null;
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
                        if (myProductCategory != null && !loading)
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Sub-Category"),
                              ),
                            ],
                          ),
                        if (myProductCategory != null && !loading)
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
                                _addedProductVariants.clear();
                                featureId = null;
                                myProductSubCategory = value;
                              });
                              fetchProductVariant(myProductSubCategory!);
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
                          controller: productName,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
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
                        // const Row(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(vertical: 8.0),
                        //       child: Text("Product Unit price"),
                        //     ),
                        //   ],
                        // ),
                        // TextFormField(
                        //   controller: unitPriceController,
                        //   // initialValue:
                        //   //     hereData!.isNotEmpty ? hereData![0] : null,
                        //   decoration: const InputDecoration(
                        //       filled: true,
                        //       fillColor: AppColors.greyColor,
                        //       focusedBorder: InputBorder.none,
                        //       focusedErrorBorder: InputBorder.none,
                        //       enabledBorder: InputBorder.none),
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return 'Product Unit price is required';
                        //     }
                        //     return null;
                        //   },
                        // ),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'WHOLESALE',
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
                        // const Row(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(vertical: 8.0),
                        //       child: Text(
                        //           "Special Instructions (Use '-' to separate points)"),
                        //     ),
                        //   ],
                        // ),
                        // TextFormField(
                        //   maxLines: 6,
                        //   decoration: const InputDecoration(
                        //       filled: true,
                        //       fillColor: AppColors.greyColor,
                        //       focusedBorder: InputBorder.none,
                        //       focusedErrorBorder: InputBorder.none,
                        //       enabledBorder: InputBorder.none),
                        //   // : 'Full Name',
                        //   keyboardType: TextInputType.text,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       myProductSpecialInstructions = value;
                        //     });
                        //   },
                        //   validator: (value) {
                        //     return null;
                        //   },
                        // ),
                        if (myProductSubCategory != null)
                          _buildProductVariantForm(),
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
                                        backgroundColor:
                                            AppColors.colorPrimaryDark),
                                    onPressed: () async {
                                      print(_formKey.currentState!.validate());
                                      if (_formKey.currentState!.validate()) {
                                        if (_addedProductVariants.isNotEmpty) {
                                          setState(() {
                                            step1 = 1;
                                          });
                                          // bool done = await verifyForm();
                                          // // bool done2 = await verifyForm2();
                                          // print(done);
                                          // // print(done2);
                                          // if (done) {
                                          //   Navigator.pushReplacementNamed(
                                          //     context,
                                          //     UploadProductImage.routeName,
                                          //     arguments: {
                                          //       'image_type':
                                          //           ImageTypes.productImages,
                                          //       'name': productName.text,
                                          //       'prod_id': int.parse(pId!),
                                          //     },
                                          //   );
                                          // }
                                        } else {
                                          displaySnack(context,
                                              "Please fill atleast one product variant.");
                                        }

                                        print(_addedProductVariants.length);
                                      } else {
                                        displaySnack(context,
                                            "Please fill all the necessary fields.");
                                      }
                                    },
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(color: AppColors.bg1),
                                    )),
                              )
                      ],
                    ),
                  ),
                ),
              if (step1 == 1 && step2 == 0) inventoryForm(),
              if (step1 == 1 && step2 == 1 && step3 == 0)
                Container(child: uploadImage()),
              if (step1 == 1 && step2 == 1 && step3 == 0)
                loading
                    ? CircularProgressIndicator(
                        color: AppColors.colorPrimaryDark,
                      )
                    : SizedBox(
                        width: 350,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimaryDark),
                            onPressed: () async {
                              if (img1 != null &&
                                  img2 != null &&
                                  img3 != null &&
                                  img4 != null) {
                                bool done = await verifyForm();

                                if (done) {
                                  print("uploading successfull");
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                } else {
                                  displaySnack(context,
                                      "Error uploading!!! Please try again.");
                                }

                                print(_addedProductVariants.length);
                              } else {
                                displaySnack(
                                    context, "Please select product images.");
                              }
                            },
                            child: const Text(
                              "Add Product",
                              style: TextStyle(color: AppColors.bgCreamWhite),
                            )),
                      )
            ],
          ),
        ),
      )),
      floatingActionButton: !loading && step1 == 1 && step2 == 0 && step3 == 0
          ? Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            if (step1 == 1) {
                              step1 = 0;
                              step2 = 0;
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.navigate_before_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : !loading && step1 == 1 && step2 == 1 && step3 == 0
              ? Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                if (step2 == 1) {
                                  step2 = 0;
                                }
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.navigate_before_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
    );
  }

  Widget uploadImage() {
    var sHeight = MediaQuery.of(context).size.height * 1;
    // var sWidth = MediaQuery.of(context).size.width * 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8),
      child: Column(
        children: [
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: sHeight * 0.15,
              crossAxisSpacing: 16,
              children: [
                Column(
                  children: [
                    Text("Image 1"),
                    img1 == null
                        ? SizedBox(child: Text('JPG/PNG images'))
                        : SizedBox(
                            height: sHeight * 0.15, child: Image.file(img1!)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            onPressed: () => _getImage1(ImageSource.gallery),
                            tooltip: 'Pick Image from Gallery',
                            child: Icon(Icons.photo),
                          ),
                          SizedBox(width: 16),
                          FloatingActionButton(
                            onPressed: () => _getImage1(ImageSource.camera),
                            tooltip: 'Take a Photo',
                            child: Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Image 2"),
                    img4 == null
                        ? SizedBox(child: Text('JPG/PNG images'))
                        : SizedBox(
                            height: sHeight * 0.15, child: Image.file(img4!)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            onPressed: () => _getImage(ImageSource.gallery),
                            tooltip: 'Pick Image from Gallery',
                            child: Icon(Icons.photo),
                          ),
                          SizedBox(width: 16),
                          FloatingActionButton(
                            onPressed: () => _getImage(ImageSource.camera),
                            tooltip: 'Take a Photo',
                            child: Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Image 3"),
                    img3 == null
                        ? SizedBox(child: Text('JPG/PNG images'))
                        : SizedBox(
                            height: sHeight * 0.15, child: Image.file(img3!)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            onPressed: () => _getImage3(ImageSource.gallery),
                            tooltip: 'Pick Image from Gallery',
                            child: Icon(Icons.photo),
                          ),
                          SizedBox(width: 16),
                          FloatingActionButton(
                            onPressed: () => _getImage3(ImageSource.camera),
                            tooltip: 'Take a Photo',
                            child: Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Image 4"),
                    img2 == null
                        ? SizedBox(child: Text('JPG/PNG images'))
                        : SizedBox(
                            height: sHeight * 0.15, child: Image.file(img2!)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FloatingActionButton(
                            onPressed: () => _getImage2(ImageSource.gallery),
                            tooltip: 'Pick Image from Gallery',
                            child: Icon(Icons.photo),
                          ),
                          SizedBox(width: 16),
                          FloatingActionButton(
                            onPressed: () => _getImage2(ImageSource.camera),
                            tooltip: 'Take a Photo',
                            child: Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ])
        ],
      ),
    );
  }

  Future _getImage1(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          img1 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(img1!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(img1);
          });
        } else {
          img1 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(img1);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImage2(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          img2 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(img2!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(img2);
          });
        } else {
          img2 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(img2);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImage3(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          img3 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(img3!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(img3);
          });
        } else {
          img3 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(img3);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          img4 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(img4!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(img4);
          });
        } else {
          img4 = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(img4);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Widget inventoryForm() {
    return Form(
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
                    style: const TextStyle(fontSize: 14, color: Colors.black),
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
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Fixed',
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
            // const Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.symmetric(vertical: 8.0),
            //       child: Text("Tax"),
            //     ),
            //   ],
            // ),
            // TextFormField(
            //   controller: myProductTax,
            //   decoration: const InputDecoration(
            //       filled: true,
            //       fillColor: AppColors.greyColor,
            //       focusedBorder: InputBorder.none,
            //       focusedErrorBorder: InputBorder.none,
            //       enabledBorder: InputBorder.none),
            //   // : 'Full Name',
            //   keyboardType: TextInputType.number,
            //   validator: (value) {
            //     if (value?.isEmpty == true) {
            //       return 'Product tax is required';
            //     }
            //     return null;
            //   },
            // ),
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
                          print(myKey.currentState!.validate());
                          if (myKey.currentState!.validate()) {
                            setState(() {
                              step2 = 1;
                            });
                            // bool done = await verifyForm();
                            // print(done);
                            // if (done) {
                            //   // ignore: use_build_context_synchronously
                            //   displaySnack(context,
                            //       "Product inventory data filled successfully.");
                            //   // ignore: use_build_context_synchronously
                            //   Navigator.popUntil(
                            //       context,
                            //       (route) =>
                            //           route.settings.name ==
                            //           SubCategoriesPage.routeName);
                            // }
                          } else {
                            displaySnack(
                                context, "Please fill all the fields.");
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: AppColors.bg1),
                        )),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildProductVariantForm() {
    return Form(
        key: _formKey2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: _addedProductVariants.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Value",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  "Unit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  "Remove",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (ctx, index) {
                              final variant =
                                  _addedProductVariants[index].UnitOfMeasure;
                              final variantValue =
                                  _addedProductVariants[index].FeatureValue;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //     child: Text(
                                  //   variant!,
                                  //   textAlign: TextAlign.center,
                                  // )),
                                  Expanded(
                                      child: Text(
                                    variantValue,
                                    textAlign: TextAlign.center,
                                  )),
                                  Expanded(
                                      child: Text(
                                    variant,
                                    textAlign: TextAlign.center,
                                  )),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _addedProductVariants
                                                  .removeAt(index);
                                            });
                                            // ctx
                                            //     .read<ProductsCubit>()
                                            //     .removeAddedProductVariant(
                                            //         variant);
                                          },
                                          child: const Icon(Icons.delete))),
                                ],
                              );
                            },
                            itemCount: _addedProductVariants.length,
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Product variants will appear here once added",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Product Variants"),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Feature Name"),
                  ),
                ],
              ),
              if (myProductSubCategory != null && !loading)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  items: variants.map((ProductVariantData vari) {
                    return DropdownMenuItem<String>(
                      value: vari.featureId,
                      child: Text(
                        vari.featureName,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  value: featureId,
                  onChanged: (value) {
                    setState(() {
                      _uom.clear();
                      featureId = value;
                      unitOfMeasure = _getSelectedVariant()!.unitOfMeasure;
                      print(_getSelectedVariant()!.unitOfMeasure);
                      print(unitOfMeasure);
                    });
                    // fetchProductVariant(myProductSubCategory!);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Product variant field is required';
                    }
                    return null;
                  },
                ),
              if (featureId != null && !loading)
                Column(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Unit of Measure"),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _uom,
                      // initialValue:
                      //     hereData!.isNotEmpty ? hereData![0] : null,
                      decoration: InputDecoration(
                          hintText: unitOfMeasure!,
                          filled: true,
                          fillColor: AppColors.greyColor,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                      // : 'Full Name',
                      keyboardType: TextInputType.text,
                      // onChanged: (value) {
                      //   setState(() {
                      //     _uom = value;
                      //   });
                      // },
                      validator: (value) {
                        if (value == null) {
                          return 'Product Unit of measure is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              if (featureId != null)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimaryDark),
                      onPressed: () {
                        if (_formKey2.currentState!.validate()) {
                          setState(() {
                            _addedProductVariants.add(Feature(
                                FeatureValue: _uom.text,
                                UnitOfMeasure: unitOfMeasure!,
                                FeatureId: int.parse(featureId!)));
                            featureId = null;
                            _uom.clear();
                            unitOfMeasure = null;
                          });
                          print(_addedProductVariants.length);
                        }
                      },
                      child: Text(
                        "Add Variant",
                        style: TextStyle(color: AppColors.bgCreamWhite),
                      )),
                )
            ],
          ),
        ));
  }

  ProductVariantData? _getSelectedVariant() {
    return variants.where((element) => element.featureId == featureId).first;
  }

  // String _formatDescription(String description) {
  //   final descriptions = <Map>[];
  //   description.split("-").forEach((element) {
  //     if (element.isNotEmpty) {
  //       final data = {"data": element.trim()};
  //       descriptions.add(data);
  //     }
  //   });
  //   return jsonEncode(descriptions);
  // }
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

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "countryOfOrigin": 'Ethiopia',
        "manufucturer": '2',
        "productCategoryId": myProductCategory,
        "productDescription": _formatDescription(myProductDisc.text),
        "productName": productName.text,
        "productParentCateoryId": myParentCategory,
        "productSubCategoryId": myProductSubCategory,
        "productType": myProductType,
        "specialInstruction": _formatDescription(""),
        "shortDescription": "shortDescription",
        "productFeature":
            _addedProductVariants.map((feature) => feature.toJson()).toList(),
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/merchant/products/main-details"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          pId = data['productId'].toString();
          bool done = await verifyForm2();
          if (done) {
            print("uploadingheere");
            await uploadProductImages(
                img1!.path, num.parse(pId!), ImageTypes.productImages);
            await uploadProductImages(
                img2!.path, num.parse(pId!), ImageTypes.productImages);
            await uploadProductImages(
                img3!.path, num.parse(pId!), ImageTypes.productImages);
            await uploadProductImages(
                img4!.path, num.parse(pId!), ImageTypes.productImages);
          }
          setState(() {
            loading = false;
          });

          return true;

          // List<File> myImage = [
          //   img1!,
          //   img2!,
          //   img3!,
          //   img4!,
          // ];
          // if (done) {
          //   await uploadProductImages(
          //       myImage, num.parse(pId!), ImageTypes.productImages);
          // }
          // print("the product done status $done");
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

  Future<bool> verifyForm2() async {
    try {
      setState(() {
        loading = true;
      });

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "productId": int.parse(pId.toString()),
        "currency": "ETB",
        "discountType": myProductDiscount,
        "discountValue": myProductDiscountPercentage.text,
        "isDiscounted": myProductDiscount == "FIXED" ? "0" : "1",
        "maxOrder": myProductMaxOrder.text,
        "minOrder": myProductMinOrder.text,
        "quantity": myProductQuantity.text,
        "soldQuantity": "0",
        "tax": "15",
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

  Future<bool> uploadProductImages(
      String image, num prodId, ImageTypes imageTypes) async {
    debugPrint("Uploading product images");
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);

    try {
      setState(() {
        loading = true;
      });
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        try {
          // final response = await apiProvider.uploadFile(
          //     EndPoints.productImage.url,
          //     file,
          //     {"platform": "Mobile", "type": imageTypes.name, 'id': prodId});

          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.commercepal.com:2096/prime/api/v1/upload/image',
            ),
          );
          request.headers['Authorization'] = 'Bearer $token';
          request.fields['platform'] = "Mobile";
          request.fields['type'] = imageTypes.name;
          request.fields['id'] = prodId.toString();
          var myImage = await http.MultipartFile.fromPath('file', image);
          request.files.add(myImage);
          var response = await request.send();

          var responseBody = await response.stream.bytesToString();

          print(responseBody);

          // if (responseBody == '000') {
          //   print('Image uploaded successfully');
          // } else {
          //   print(
          //       'Failed to upload image. Status code: ${response.statusCode}');
          //   print('Error message: $responseBody');
          // }
        } catch (e) {
          print('Error uploading image: $e');
        }

        setState(() {
          loading = false;
        });
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<void> sendImage({
    required String imageFile,
    required String fileType,
    required String userType,
    required String userId,
  }) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.commercepal.com:2096/prime/api/v1/distributor/upload-docs',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['fileType'] = fileType;
      request.fields['userType'] = userType;
      request.fields['userId'] = userId;

      // Add the image file
      var image = await http.MultipartFile.fromPath('file', imageFile);
      request.files.add(image);
      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print(response);

        if (responseBody == '000') {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
          print('Error message: $responseBody');
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    // Add other fields
  }

  Future<bool> fetchUoM() async {
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

  Future<bool> fetchProductVariant(String id) async {
    try {
      setState(() {
        loading = true;
      });
      print("subcat");
      print(id);
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/app/get-sub-category-features",
        {'sub-category': id},
      ));
      var data = jsonDecode(response.body);
      variants.clear();
      for (var b in data['details']) {
        variants.add(ProductVariantData(
            featureId: b['featureId'].toString(),
            featureName: b['featureName'],
            unitOfMeasure: b['unitOfMeasure']));
      }
      print(variants.length);
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
}
