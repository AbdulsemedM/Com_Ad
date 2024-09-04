import 'category.dart';

class ParentCategoryWithCategories {
  final String? parentCategoryName;
  final num? parentCategoryId;
  final List<Category> categories;

  ParentCategoryWithCategories(
      this.parentCategoryName, this.parentCategoryId, this.categories);
}
