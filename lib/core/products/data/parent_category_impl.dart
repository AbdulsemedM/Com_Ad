import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:commercepal_admin_flutter/core/products/data/dto/products_response_dto.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/Add_sub_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product.dart';
import 'package:injectable/injectable.dart';

import '../../database/data_helper/data_helper.dart';
import '../../network/api_provider.dart';
import '../../network/end_points.dart';
import '../domain/models/add_product.dart';
import '../domain/models/brand.dart';
import '../domain/models/category.dart';
import '../domain/models/parent_category_with_categories.dart';
import '../domain/models/unit_of_measure.dart';
import '../domain/models/variant.dart';
import '../domain/product_repo.dart';
import 'dto/Parent_cat_response_dto.dart';
import 'dto/brands_response_dto.dart';
import 'dto/category_response_dto.dart';
import 'dto/uom_response_dto.dart';
import 'dto/variants_response_dto.dart';

@Injectable(as: ProductRepo)
class ParentCategoryImpl implements ProductRepo {
  final ApiProvider apiProvider;
  final DataHelper dataHelper;

  ParentCategoryImpl(this.apiProvider, this.dataHelper);

  @override
  Future<List<ParentCategoryWithCategories>>
      fetchMerchantParentCategories() async {
    try {
      final parentCat =
          await apiProvider.get(EndPoints.parentMerchantCategories.url);
      final obj = ParentCatResponseDto.fromJson(parentCat);
      final parentWithCategories = <ParentCategoryWithCategories>[];

      // fetch categories
      for (var parentCategory in obj.parentCategories!) {
        final categories = await _fetchCategories(parentCategory.id!);
        parentWithCategories.add(ParentCategoryWithCategories(
            parentCategory.name, parentCategory.id, categories!));
      }

      if (parentWithCategories.isEmpty) throw 'Parent categories not found';
      return parentWithCategories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Category>?> _fetchCategories(num parentId) async {
    try {
      final parentCat = await apiProvider
          .get("${EndPoints.category.url}?parentCat=$parentId");
      final parentCatObj = CategoryResponseDto.fromJson(parentCat);
      if (parentCatObj.data?.isEmpty == true) throw 'Categories not found';
      return parentCatObj.data;
    } catch (e) {
      log("Exception fetching category for parent id: $parentId : ${e.toString()}");
    }
    return null;
  }

  @override
  Future<List<Category>> fetchParentCategories() async {
    try {
      final response = await apiProvider.get(EndPoints.parentCategories.url);
      if (response['statusCode'] == '000') {
        final responseObj = CategoryResponseDto.fromJson(response);
        if (responseObj.data?.isEmpty == true) {
          throw 'Parent categories not found';
        }
        return responseObj.data!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> fetchCategories(
      num parentCat, String parentCatName) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.categories.url}?parentCat=$parentCat");
      if (response['statusCode'] == '000') {
        final responseObj = CategoryResponseDto.fromJson(response);
        if (responseObj.data?.isEmpty == true) {
          throw 'Categories under $parentCatName not found';
        }
        return responseObj.data!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> fetchSubCategories(num catId, String catName) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.subCategories.url}?category=$catId");
      if (response['statusCode'] == '000') {
        final responseObj = CategoryResponseDto.fromJson(response);
        if (responseObj.data?.isEmpty == true) {
          throw 'Categories under $catName not found';
        }
        return responseObj.data!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Uom>> fetchUom() async {
    try {
      final response = await apiProvider.get(EndPoints.uom.url);
      if (response['statusCode'] == '000') {
        final responseObj = UomResponseDto.fromJson(response);
        if (responseObj.details?.isEmpty == true) {
          throw 'Unit of measures list not found';
        }
        return responseObj.details!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Brand>> fetchBrand(int parentCatId, String parentCatName) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.brands.url}?parentCat=$parentCatId");
      if (response['statusCode'] == '000') {
        final responseObj = BrandsResponseDto.fromJson(response);
        if (responseObj.details?.isEmpty == true) {
          throw 'Unable to get brands for $parentCatName at the moment';
        }
        return responseObj.details!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductVariant>> fetchProductVariants(int subCatId) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.variants.url}?sub-category=$subCatId");
      if (response['statusCode'] == '000') {
        final responseObj = VariantsResponseDto.fromJson(response);
        if (responseObj.details?.isEmpty == true) {
          throw 'Unable to get variants at the moment';
        }
        return responseObj.details!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map> addProduct(AddProduct addProduct) async {
    try {
      final user = await dataHelper.getUser();
      addProduct.createdBy = user.merchantInfo?.phoneNumber;

      final res =
          await apiProvider.post(addProduct.toJson(), EndPoints.addProduct.url);
      final response = jsonDecode(res);

      if (response['statusCode'] == '000') {
        return {
          'product_id': response['productId'],
          'sub_product_id': response['subProductId']
        };
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> addSubProduct(AddSubProduct addSubProduct) async {
    try {
      final user = await dataHelper.getUser();
      addSubProduct.createdBy = user.merchantInfo?.userId.toString();

      final res = await apiProvider.post(
          addSubProduct.toJson(), EndPoints.addSubProduct.url);
      final response = jsonDecode(res);

      if (response['statusCode'] == '000') {
        return "Sub product added successfully";
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> fetchMerchantSubCategories(
      num catId, String catName) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.merchantSubCategory.url}?category=$catId");
      if (response['statusCode'] == '000') {
        final responseObj = CategoryResponseDto.fromJson(response);
        if (responseObj.data?.isEmpty == true) {
          throw 'Categories under $catName not found';
        }
        return responseObj.data!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> fetchProducts(num catId, num subCatId) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.product.url}?category=$catId&subCat=$subCatId");
      if (response['statusCode'] == '000') {
        final responseObj = ProductsResponseDto.fromJson(response);
        if (responseObj.details?.isEmpty == true) {
          throw 'Products not found';
        }
        return responseObj.details!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map> uploadProductImages(
      List<File> images, num prodId, ImageTypes imageTypes) async {
    try {
      List<String> imageUploadErrors = [];
      List<String> imageUrls = [];
      for (File file in images) {
        // try catch for specific image upload errors
        try {
          final response = await apiProvider.uploadFile(
              EndPoints.productImage.url,
              file,
              {"platform": "Mobile", "type": imageTypes.name, 'id': prodId});
          final objResponse = jsonDecode(response);
          if (objResponse['statusCode'] == '000') {
            imageUrls.add(objResponse['imageUrl']);
          } else {
            throw objResponse['statusMessage'];
          }
        } catch (e) {
          log(e.toString());
          imageUploadErrors
              .add('Unable to upload image ${images.indexOf(file)}');
        }
      }
      return {"image_errors": imageUploadErrors, 'image_urls': imageUrls};
    } catch (e) {
      rethrow;
    }
  }
}
