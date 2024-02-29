import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_product/selected_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/upload_product_image/upload_product_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String? myProductSpecialInstructions;
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
  @override
  void initState() {
    super.initState();
    fetchParentCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
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
                      maxLines: 6,
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
                                      bool done = await verifyForm();
                                      // bool done2 = await verifyForm2();
                                      print(done);
                                      // print(done2);
                                      if (done) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          UploadProductImage.routeName,
                                          arguments: {
                                            'image_type':
                                                ImageTypes.productImages,
                                            'name': productName.text,
                                            'prod_id': int.parse(pId!),
                                          },
                                        );
                                      }
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
                                child: const Text("Add Product")),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
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
                      child: Text("Add Variant")),
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
        "specialInstruction": _formatDescription(myProductSpecialInstructions!),
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
          setState(() {
            pId = data['productId'].toString();
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
