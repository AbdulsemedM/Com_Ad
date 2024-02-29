class DiscountType {
  final String name;

  DiscountType(this.name);

  static List<DiscountType> getDiscountTypes() =>
      [DiscountType("Discounted"), DiscountType("Not discounted")];
}
