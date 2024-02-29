enum ShipmentStatus {
  newOrder(101, 'New Order'),
  readyForPickUp(102, 'Ready for pick up'),
  validateOtp(103, 'Messenger on the way'),
  done(104, 'Completed');

  const ShipmentStatus(this.id, this.description);

  final int id;
  final String description;
}
