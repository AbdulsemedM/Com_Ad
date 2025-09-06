import 'dart:convert';

import 'package:commercepal_admin_flutter/feature/new_messenger/data/data_provider/new_messenger_data_provider.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/model/delivery_items_model.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/model/delivery_details_model.dart';

class NewMessengerRepository {
  final NewMessengerDataProvider _newMessengerDataProvider;

  NewMessengerRepository(this._newMessengerDataProvider);

  Future<List<DeliveryItemsModel>> fetchDeliveryItems() async {
    try {
      final response = await _newMessengerDataProvider.fetchDeliveryItems();
      final data = jsonDecode(response);
      if (data['statusCode'] != "000") {
        throw data['statusMessage'];
      }
      if (data['responseData'] is List) {
        final deliveryItems = (data['responseData'] as List)
            .map((deliveryItem) => DeliveryItemsModel.fromMap(deliveryItem))
            .toList();
        return deliveryItems;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<DeliveryDetailsModel> fetchDeliveryItemDetails(String id) async {
    try {
      final response =
          await _newMessengerDataProvider.fetchDeliveryItemDetails(id);
      final data = jsonDecode(response);
      if (data['statusCode'] != "000") {
        throw data['statusMessage'];
      }
      if (data['responseData'] is Map) {
        final deliveryItems =
            DeliveryDetailsModel.fromMap(data['responseData']);
        return deliveryItems;
      } else {
        throw "Invalid response format: Expected a Map";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
