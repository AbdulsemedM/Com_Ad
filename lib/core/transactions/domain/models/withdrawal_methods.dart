class WithdrawalMethod {
  final String? name;

  const WithdrawalMethod(this.name);

  static List<WithdrawalMethod> fetchWithdrawalMethods() =>
      [const WithdrawalMethod("Sahay"), const WithdrawalMethod('Bank')];
}
