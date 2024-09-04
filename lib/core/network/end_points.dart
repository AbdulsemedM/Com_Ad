enum EndPoints {
  baseUrl(url: EndPoints._baseUrl),
  login(url: '${EndPoints._baseUrl}/authenticate'),
  userDetails(url: '${EndPoints._baseUrl}/get-details'),
  parentMerchantCategories(
      url: "${EndPoints._baseUrl}/merchant/category/get-parent-category"),
  category(url: '${EndPoints._baseUrl}/merchant/category/get-category'),
  merchantSubCategory(
      url: '${EndPoints._baseUrl}/merchant/category/get-sub-category'),
  orderSummary(url: '${EndPoints._baseUrl2}/merchant/order/order-summary'),
  transactions(url: '${EndPoints._baseUrl2}/merchant/transaction/transactions'),
  accBalance(url: '${EndPoints._baseUrl}/merchant/transaction/account-balance'),
  parentCategories(url: '${EndPoints._baseUrl}/app/get-parent-categories'),
  categories(url: '${EndPoints._baseUrl}/app/get-categories'),
  subCategories(url: '${EndPoints._baseUrl}/app/get-sub-categories'),
  uom(url: '${EndPoints._baseUrl}/portal/product/features/get-uom'),
  brands(url: '${EndPoints._baseUrl}/portal/category/GetBrands'),
  variants(url: '${EndPoints._baseUrl}/portal/product/features/get-features'),
  addProduct(url: '${EndPoints._baseUrl}/merchant/product/add-product'),
  addSubProduct(url: '${EndPoints._baseUrl}/portal/product/add-sub-product'),
  product(url: '${EndPoints._baseUrl}/merchant/product/get-products'),
  productImage(url: '${EndPoints._baseUrl}/upload/image'),
  orderItem(url: '${EndPoints._baseUrl2}/merchant/order/order-item'),
  orderItemProductInfo(
      url: '${EndPoints._baseUrl2}/merchant/order/product-info'),
  acceptOrderItem(url: '${EndPoints._baseUrl2}/merchant/shipping/accept-item-pickup'),
  validatePickUpOtp(url: '${EndPoints._baseUrl2}/merchant/shipping/validate-pick-up-code'),
  validateSahay(url: _paymentRequest);

  const EndPoints({required this.url});

  final String url;
  static const _baseUrl = "https://api.commercepal.com:2096/prime/api/v1";
  static const _baseUrl2 = "https://api.commercepal.com:2095/prime/api/v1";
  static const _paymentRequest = "https://api.commercepal.com:2095/payment/v1/request";
}
