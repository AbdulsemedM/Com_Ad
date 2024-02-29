enum OrderStatus {
  all(status: 10),
  newOrders(status: 10),
  delivered(status: 10);

  const OrderStatus({this.status});

  final num? status;
}
