part of 'new_messenger_bloc.dart';

@immutable
sealed class NewMessengerEvent {}

class FetchDeliveryItemsEvent extends NewMessengerEvent {}

class RefreshDeliveryItemsEvent extends NewMessengerEvent {}

class FetchDeliveryItemDetailsEvent extends NewMessengerEvent {
  final String id;
  FetchDeliveryItemDetailsEvent({required this.id});
}
