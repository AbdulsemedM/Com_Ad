import 'package:commercepal_admin_flutter/feature/new_messenger/presentation/screen/delivery_items_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/delivery_items_widget.dart';
import '../../model/delivery_items_model.dart';
import '../../bloc/new_messenger_bloc.dart';

class DeliveryItemsScreen extends StatefulWidget {
  const DeliveryItemsScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryItemsScreen> createState() => _DeliveryItemsScreenState();
}

class _DeliveryItemsScreenState extends State<DeliveryItemsScreen> {
  String? selectedType;
  String? selectedStatus;

  final List<String> deliveryTypes = [
    'Newly Assigned',
    'Processing',
    'Confirmed'
  ];
  final List<String> deliveryStatuses = ['Newly Assigned', 'Accepted'];

  @override
  void initState() {
    super.initState();
    context.read<NewMessengerBloc>().add(FetchDeliveryItemsEvent());
  }

  List<DeliveryItemsModel> _filterDeliveries(
      List<DeliveryItemsModel> deliveries) {
    return deliveries.where((delivery) {
      bool matchesType = selectedType == null ||
          delivery.deliveryType.toLowerCase() == selectedType!.toLowerCase();
      bool matchesStatus = selectedStatus == null ||
          delivery.deliveryStatus.toLowerCase() ==
              selectedStatus!.toLowerCase();
      return matchesType && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
      ),
      body: Column(
        children: [
          // Filters section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Delivery Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ...deliveryTypes.map(
                      (type) => DeliveryFilterChip(
                        label: type,
                        isSelected: selectedType == type,
                        onSelected: () {
                          setState(() {
                            selectedType = selectedType == type ? null : type;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Delivery Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ...deliveryStatuses.map(
                      (status) => DeliveryFilterChip(
                        label: status,
                        isSelected: selectedStatus == status,
                        onSelected: () {
                          setState(() {
                            selectedStatus =
                                selectedStatus == status ? null : status;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Deliveries list
          Expanded(
            child: BlocBuilder<NewMessengerBloc, NewMessengerState>(
              builder: (context, state) {
                if (state is FetchDeliveryItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FetchDeliveryItemsSuccess) {
                  final filteredDeliveries =
                      _filterDeliveries(state.deliveryItems);

                  if (filteredDeliveries.isEmpty) {
                    return const Center(
                      child: Text('No deliveries match the selected filters'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<NewMessengerBloc>()
                          .add(FetchDeliveryItemsEvent());
                    },
                    child: ListView.builder(
                      itemCount: filteredDeliveries.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryDetailsScreen(
                                  deliveryId:
                                      filteredDeliveries[index].id.toString(),
                                ),
                              ),
                            ).whenComplete(() {
                              if (context.mounted) {
                                context
                                    .read<NewMessengerBloc>()
                                    .add(FetchDeliveryItemsEvent());
                              }
                            });
                          },
                          child: DeliveryItemCard(
                            delivery: filteredDeliveries[index],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is FetchDeliveryItemsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<NewMessengerBloc>()
                                .add(FetchDeliveryItemsEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
