import 'package:commercepal_admin_flutter/feature/new_messenger/bloc/new_messenger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/delivery_details_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final String deliveryId;

  const DeliveryDetailsScreen({
    Key? key,
    required this.deliveryId,
  }) : super(key: key);

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NewMessengerBloc>().add(
          FetchDeliveryItemDetailsEvent(id: widget.deliveryId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NewMessengerBloc, NewMessengerState>(
          builder: (context, state) {
            if (state is FetchDeliveryItemDetailsSuccess) {
              return Text(state.deliveryDetails.appName);
            }
            return const Text('Delivery Details');
          },
        ),
        actions: [
          BlocBuilder<NewMessengerBloc, NewMessengerState>(
            builder: (context, state) {
              if (state is FetchDeliveryItemDetailsSuccess) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          state.deliveryDetails.deliveryStatus.toLowerCase() ==
                                  'pending'
                              ? Colors.green
                              : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        state.deliveryDetails.deliveryStatus.toLowerCase() ==
                                'pending'
                            ? () {
                                // context.read<NewMessengerBloc>().add(
                                //       AcceptDeliveryEvent(
                                //           id: state.deliveryDetails.id),
                                //     );
                              }
                            : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.deliveryDetails.deliveryStatus.toLowerCase() ==
                                  'pending'
                              ? Icons.check_circle_outline
                              : Icons.check_circle,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text('Accept'),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<NewMessengerBloc, NewMessengerState>(
        builder: (context, state) {
          if (state is FetchDeliveryItemDetailsLoading) {
            return const DeliveryDetailsShimmer();
          }

          if (state is FetchDeliveryItemDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewMessengerBloc>().add(
                            FetchDeliveryItemDetailsEvent(
                                id: widget.deliveryId),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FetchDeliveryItemDetailsSuccess) {
            final details = state.deliveryDetails;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewMessengerBloc>().add(
                      FetchDeliveryItemDetailsEvent(id: widget.deliveryId),
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Section with Status Badges
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(
                                codeName: "Validation Code",
                                status: details.validationStatus,
                                code: details.validationCode,
                                isValidation: true,
                              ),
                              StatusBadge(
                                codeName: "Delivery Code",
                                status: details.deliveryStatus,
                                code: details.deliveryCode,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery Type',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      details.deliveryType,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                if (details.pickingDate != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Picking Date',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        details.pickingDate!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Item Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ItemDetailsCard(details: details),
                    ),

                    // Address Information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          AddressCard(
                            title: 'Warehouse Address',
                            address: details
                                .warehouseDeliveryAddressModel.physicalAddress,
                            contactPerson: details
                                .warehouseDeliveryAddressModel.wareHouseName,
                            phone: "",
                            icon: Icons.warehouse,
                          ),
                          const SizedBox(height: 16),
                          AddressCard(
                            title: 'Delivery Address',
                            address:
                                details.deliveryAddressModel.physicalAddress,
                            contactPerson: details.deliveryAddressModel.country,
                            phone: details.deliveryAddressModel.cityName,
                            icon: Icons.location_on,
                          ),
                        ],
                      ),
                    ),

                    // Customer Information if available
                    if (details.customerInfoModel != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Customer Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title:
                                      Text(details.customerInfoModel!.fullName),
                                  subtitle: Text(
                                      details.customerInfoModel!.phoneNumber),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      final Uri phoneUri = Uri(
                                        scheme: 'tel',
                                        path: details
                                            .customerInfoModel!.phoneNumber,
                                      );
                                      if (await canLaunchUrl(phoneUri)) {
                                        await launchUrl(phoneUri);
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Could not launch phone dialer'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
