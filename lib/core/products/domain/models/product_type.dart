class ProductType {
  final String? name;

  ProductType(this.name);

  static List<ProductType> productTypes() => [ProductType("Wholesale"), ProductType("Retail")];
}
