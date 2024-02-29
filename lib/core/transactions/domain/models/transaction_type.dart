enum TransactionType {
  payment("FLOAT"),
  commission("COMMISSION");

  const TransactionType(this.name);

  final String name;
}
