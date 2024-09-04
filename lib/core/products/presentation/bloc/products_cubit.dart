import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/Add_sub_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/add_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/discount_type.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product_type.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/variant.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/category_type.dart';
import '../../domain/models/country.dart';
import '../../domain/models/product_feature.dart';
import '../../domain/product_repo.dart';

@injectable
class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepo productsRepo;
  final List<Map<ProductVariant, String>> _addedProductVariants = [];
  List<File> _prodImages = [];

  ProductsCubit(this.productsRepo) : super(const ProductsState.init());

  void fetchParentWithCategories() async {
    try {
      emit(const ProductsState.loading());
      final cats = await productsRepo.fetchMerchantParentCategories();
      emit(ProductsState.parentCategoryWithCategories(cats));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchParentCategories() async {
    try {
      emit(const ProductsState.loading());
      final cats = await productsRepo.fetchParentCategories();
      emit(ProductsState.parentCategories(cats));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchCategories(num parentCatId, String parentCatName) async {
    try {
      emit(const ProductsState.loading());
      final cats =
          await productsRepo.fetchCategories(parentCatId, parentCatName);
      emit(ProductsState.categories(cats));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchCategoryBasedOnType(
      CategoryType categoryType, num? id, String? name) async {
    switch (categoryType) {
      case CategoryType.category:
        fetchCategories(id!, name!);
        break;
      case CategoryType.subCategory:
        fetchSubCategories(id!, name!);
        break;
      case CategoryType.parentCategory:
        break;
    }
  }

  void fetchSubCategories(num catId, String catName) async {
    try {
      emit(const ProductsState.loading());
      final cats = await productsRepo.fetchSubCategories(catId, catName);
      emit(ProductsState.categories(cats));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchMerchantSubCategories(num catId, String catName) async {
    try {
      emit(const ProductsState.loading());
      final cats =
          await productsRepo.fetchMerchantSubCategories(catId, catName);
      emit(ProductsState.categories(cats));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchUom() async {
    try {
      emit(const ProductsState.loading());
      final uom = await productsRepo.fetchUom();
      emit(ProductsState.uom(uom));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchBrands(int parentCatId, String parentCatName) async {
    try {
      emit(const ProductsState.loading());
      final brands = await productsRepo.fetchBrand(parentCatId, parentCatName);
      emit(ProductsState.brands(brands));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchCountries() async {
    try {
      emit(const ProductsState.loading());
      await Future.delayed(const Duration(milliseconds: 20));
      final countries = Country.getCountries();
      emit(ProductsState.countries(countries));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchProductTypes() async {
    try {
      emit(const ProductsState.loading());
      await Future.delayed(const Duration(milliseconds: 20));
      final productTypes = ProductType.productTypes();
      emit(ProductsState.productTypes(productTypes));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchDiscountTypes() async {
    try {
      emit(const ProductsState.loading());
      await Future.delayed(const Duration(milliseconds: 20));
      final discountTypes = DiscountType.getDiscountTypes();
      emit(ProductsState.discountType(discountTypes));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchProductVariants(int subCatId) async {
    try {
      emit(const ProductsState.loading());
      final variants = await productsRepo.fetchProductVariants(subCatId);
      emit(ProductsState.variants(variants));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void addProductVariantToList(ProductVariant productVariant, String uom) {
    // if value is already added
    final exists = _addedProductVariants
        .where((e) => e.containsKey(productVariant))
        .firstOrNull;
    if (exists == null) {
      _addedProductVariants.add({productVariant: uom});
    } else {
      // remove and add updated instead of updating
      _addedProductVariants.remove(exists);
      _addedProductVariants.add({productVariant: uom});
    }
    if (_addedProductVariants.isNotEmpty) {
      // emit new state to reset the current state so as the ui to be updated
      emit(const ProductsState.loading());
      emit(ProductsState.locallyAddedVariants(_addedProductVariants));
    }
  }

  void removeAddedProductVariant(ProductVariant productVariant) async {
    emit(const ProductsState.loading());
    final exists = _addedProductVariants
        .where((e) => e.containsKey(productVariant))
        .firstOrNull;
    if (exists != null) {
      _addedProductVariants.remove(exists);

      emit(ProductsState.locallyAddedVariants(_addedProductVariants));
    }
  }

  void addProduct(AddProduct addProduct) async {
    try {
      emit(const ProductsState.loading());
      // attach product features
      final features = <ProductFeature>[];
      _addedProductVariants.map((element) {
        final variant = element.keys.first;
        final value = element.values.first;
        return ProductFeature(
            featureId: variant.featureId,
            featureValue: value,
            unitOfMeasure: variant.unitOfMeasure);
      }).forEach((element) {
        features.add(element);
      });

      addProduct.productFeature = features;

      final response = await productsRepo.addProduct(addProduct);

      emit(ProductsState.productAdded(response));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void addSubProduct(AddSubProduct addSubProduct) async {
    try {
      emit(const ProductsState.loading());
      // attach product features
      final features = <ProductFeature>[];
      _addedProductVariants.map((element) {
        final variant = element.keys.first;
        final value = element.values.first;
        return ProductFeature(
            featureId: variant.featureId,
            featureValue: value,
            unitOfMeasure: variant.unitOfMeasure);
      }).forEach((element) {
        features.add(element);
      });

      addSubProduct.productFeature = (features);

      final response = await productsRepo.addSubProduct(addSubProduct);

      emit(ProductsState.subProductAdded(response));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void fetchProducts(num catId, num subCatId) async {
    try {
      emit(const ProductsState.loading());
      final prods = await productsRepo.fetchProducts(catId, subCatId);
      emit(ProductsState.products(prods));
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void uploadImages(num prodId, ImageTypes imageTypes) async {
    try {
      if (_prodImages.isEmpty) {
        throw 'Pick image(s) to upload';
      }

      if (_prodImages.length < 4 && imageTypes == ImageTypes.productImages) {
        throw '4 images are needed';
      }
      if (_prodImages.length < 2 && imageTypes == ImageTypes.subProductImages) {
        throw '2 images are needed';
      }

      emit(const ProductsState.loading());
      final prods = await productsRepo.uploadProductImages(
          _prodImages, prodId, imageTypes);
      if (prods['image_errors'] != null && prods['image_errors'].length > 0) {
        // display error in case some image upload failed
        String? error = '';
        prods['image_errors'].forEach((element) {
          error = "$error -$element\n";
        });
        emit(ProductsState.error(error!));
      } else {
        emit(ProductsState.productImages(prods['image_urls']));
      }
    } catch (e) {
      emit(ProductsState.error(e.toString()));
    }
  }

  void addProductImage(File file) {
    // check if image already exists
    final existsIndex = _prodImages.indexWhere((element) => element == file);
    if (existsIndex == -1) {
      _prodImages.add(file);
    } else {
      _prodImages.removeAt(existsIndex);
      _prodImages.add(file);
    }
  }
}
