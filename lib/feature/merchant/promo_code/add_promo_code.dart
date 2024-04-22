import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/add_dialog.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_product/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class AddPromoCode extends StatefulWidget {
  const AddPromoCode({super.key});

  @override
  State<AddPromoCode> createState() => _AddPromoCodeState();
}

class NewProducts {
  final String ProductId;
  final String productName;
  final String mobileThumbnail;
  final String actualPrice;
  final String subProductId;
  NewProducts(
      {required this.ProductId,
      required this.productName,
      required this.mobileThumbnail,
      required this.subProductId,
      required this.actualPrice});
}

class _AddPromoCodeState extends State<AddPromoCode> {
  var loading = false;
  var loading1 = false;
  List<NewProducts> myProducts = [];
  String? myParentCategory;
  String? myProductCategory;
  String? myProductSubCategory;
  List<SubCategoryData> subCat = [];
  List<ProductCategory> proCat = [];
  List<ParentCategoryData> parCat = [];
  @override
  void initState() {
    super.initState();
    fetchMyProducts(null, null, null);
    fetchParentCategory();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Promo-Code"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Choose a product to add a promo-code"),
              ],
            ),
            Text("Filter out your products by"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: DropdownButtonFormField<String>(
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
                            // _addedProductVariants.clear();
                            myProducts.clear();
                            myProductCategory = null;
                            myProductSubCategory = null;
                            // featureId = null;
                            myParentCategory = value;
                            fetchMyProducts(myParentCategory, null, null);
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: DropdownButtonFormField<String>(
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
                            // _addedProductVariants.clear();
                            // featureId = null;
                            myProducts.clear();
                            myProductSubCategory = null;
                            myProductCategory = value;
                            fetchSubCategory(myProductCategory!);
                            fetchMyProducts(
                                myParentCategory, myProductCategory, null);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Product category field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: DropdownButtonFormField<String>(
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
                            // _addedProductVariants.clear();
                            // featureId = null;
                            myProducts.clear();
                            myProductSubCategory = value;
                          });
                          fetchMyProducts(myParentCategory, myProductCategory,
                              myProductSubCategory);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Product sub category field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            !loading && myProducts.isEmpty
                ? SizedBox(
                    height: sHeight * 0.9,
                    child: const Column(
                      children: [
                        Center(
                          child: Center(child: Text('No products found.')),
                        ),
                      ],
                    ),
                  )
                : loading && myProducts.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.colorPrimaryDark,
                        ),
                      )
                    : LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          height: sHeight * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: sHeight > 896 ? 2 : 0.9,
                                crossAxisCount:
                                    2, // Number of columns in the grid
                                crossAxisSpacing:
                                    2.0, // Spacing between columns
                                mainAxisSpacing: 0, // Spacing between rows
                              ),
                              itemCount: myProducts
                                  .length, // Number of items in the grid
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var result = showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddPromoCodeDialog(
                                            productId:
                                                myProducts[index].ProductId,
                                            productName:
                                                myProducts[index].productName,
                                            subProductId:
                                                myProducts[index].subProductId,
                                          );
                                        });
                                    print(result);
                                  },
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: sWidth * 0.5,
                                          decoration: const BoxDecoration(
                                            color: AppColors.bg1,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          topRight:
                                                              Radius.circular(
                                                                  12)),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    height: 120,
                                                    placeholder: (_, __) =>
                                                        Container(
                                                      color: AppColors.bg1,
                                                    ),
                                                    errorWidget: (_, __, ___) =>
                                                        Container(
                                                      color: Colors.grey,
                                                    ),
                                                    imageUrl: myProducts[index]
                                                        .mobileThumbnail,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Text(
                                                  "${myProducts[index].productName}",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: Text(
                                                        "ETB ${myProducts[index].actualPrice}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontSize: 14.sp,
                                                                color: AppColors
                                                                    .colorPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      })
          ],
        ),
      ),
    );
  }

  Future<void> fetchMyProducts(
      String? parent, String? category, String? subCategory) async {
    print(parent);
    print(category);
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      var response;
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        if (parent != null && subCategory != null && category != null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'parent': parent, "subCat": subCategory, "category": category},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent != null && subCategory != null && category == null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'parent': parent, "subCat": subCategory},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent != null && subCategory == null && category == null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {
                'parent': parent,
              },
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent == null && subCategory == null && category == null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent == null && subCategory == null && category != null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'category': category},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent == null && subCategory != null && category != null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'subCat': subCategory, "category": category},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent != null && subCategory == null && category != null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'parent': parent, "category": category},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        } else if (parent != null && subCategory != null && category == null) {
          response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/merchant/product/get-products",
              {'parent': parent, "subCat": subCategory},
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
        }

        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        myProducts.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['details']) {
            var id = i['ProductId'].toString();
            var name = i['productName'].toString();
            for (var j in i['subProducts']) {
              var mobileThumbnail = j['mobileImage'].toString();
              var subProductId = j['SubProductId'].toString();
              var actualPrice = j['UnitPrice'].toString();
              myProducts.add(NewProducts(
                  ProductId: id,
                  productName: name,
                  mobileThumbnail: mobileThumbnail,
                  subProductId: subProductId,
                  actualPrice: actualPrice));
            }
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myProducts.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching Promo-Codes';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> fetchSubCategory(String id) async {
    try {
      setState(() {
        loading1 = true;
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
        loading1 = false;
      });

      // Check the condition for success
      bool success = subCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading1 = false;
      });
    }
  }

  Future<bool> fetchProductCategory(String id) async {
    try {
      setState(() {
        loading1 = true;
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
        loading1 = false;
      });

      // Check the condition for success
      bool success = proCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading1 = false;
      });
    }
  }

  Future<bool> fetchParentCategory() async {
    try {
      setState(() {
        loading1 = true;
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
        loading1 = false;
      });

      // Check the condition for success
      bool success = parCat.length > 0;
      return success;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading1 = false;
      });
    }
  }
}
