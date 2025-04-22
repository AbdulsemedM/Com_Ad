import 'package:commercepal_admin_flutter/feature/new_messenger/data/repository/new_messenger_repository.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/model/delivery_details_model.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/model/delivery_items_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'new_messenger_event.dart';
part 'new_messenger_state.dart';

class NewMessengerBloc extends Bloc<NewMessengerEvent, NewMessengerState> {
  final NewMessengerRepository newMessengerRepository;
  NewMessengerBloc(this.newMessengerRepository) : super(NewMessengerInitial()) {
    on<FetchDeliveryItemsEvent>(_fetchDeliveryItems);
    on<FetchDeliveryItemDetailsEvent>(_fetchDeliveryItemDetails);
    // on<AddAgentEvent>(_addAgent);
    // on<UpdateAgentEvent>(_updateAgent);
  }

  void _fetchDeliveryItems(
      FetchDeliveryItemsEvent event, Emitter<NewMessengerState> emit) async {
    emit(FetchDeliveryItemsLoading());
    try {
      final deliveryItems = await newMessengerRepository.fetchDeliveryItems();
      emit(FetchDeliveryItemsSuccess(deliveryItems: deliveryItems));
    } catch (e) {
      emit(FetchDeliveryItemsError(error: e.toString()));
    }
  }

  void _fetchDeliveryItemDetails(FetchDeliveryItemDetailsEvent event,
      Emitter<NewMessengerState> emit) async {
    emit(FetchDeliveryItemDetailsLoading());
    try {
      final deliveryDetails =
          await newMessengerRepository.fetchDeliveryItemDetails(event.id);
      emit(FetchDeliveryItemDetailsSuccess(deliveryDetails: deliveryDetails));
    } catch (e) {
      emit(FetchDeliveryItemDetailsError(error: e.toString()));
    }
  }

  // void _addAgent(AddAgentEvent event, Emitter<ManageAgentState> emit) async {
  //   emit(AddAgentLoading());
  //   try {
  //     final message = await manageAgentRepository.addAgent(event.agent);
  //     emit(AddAgentSuccess(message: message));
  //   } catch (e) {
  //     emit(AddAgentError(error: e.toString()));
  //   }
  // }

  // void _updateAgent(
  //     UpdateAgentEvent event, Emitter<ManageAgentState> emit) async {
  //   emit(UpdateAgentLoading());
  //   try {
  //     final message =
  //         await manageAgentRepository.updateAgent(event.agent, event.agentId);
  //     emit(UpdateAgentSuccess(message: message));
  //   } catch (e) {
  //     emit(UpdateAgentError(error: e.toString()));
  //   }
  // }
}
