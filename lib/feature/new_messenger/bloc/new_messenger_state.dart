part of 'new_messenger_bloc.dart';

@immutable
abstract class NewMessengerState {}

class NewMessengerInitial extends NewMessengerState {}

class FetchDeliveryItemsLoading extends NewMessengerState {}

class FetchDeliveryItemsSuccess extends NewMessengerState {
  final List<DeliveryItemsModel> deliveryItems;
  FetchDeliveryItemsSuccess({required this.deliveryItems});
}

class FetchDeliveryItemsError extends NewMessengerState {
  final String error;
  FetchDeliveryItemsError({required this.error});
}

class FetchDeliveryItemDetailsLoading extends NewMessengerState {}

class FetchDeliveryItemDetailsSuccess extends NewMessengerState {
  final DeliveryDetailsModel deliveryDetails;
  FetchDeliveryItemDetailsSuccess({required this.deliveryDetails});
}

class FetchDeliveryItemDetailsError extends NewMessengerState {
  final String error;
  FetchDeliveryItemDetailsError({required this.error});
}
