import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/string_utils.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_info.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_product_info.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/shipment_status.dart';
import 'package:commercepal_admin_flutter/core/orders/presentation/orders_cubit.dart';
import 'package:commercepal_admin_flutter/core/orders/presentation/orders_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_error_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_textfield.dart';
// import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_order_item/widgets/order_item_product_info_bs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/widgets/title_with_description_widget.dart';

class SelectedOrderItemPage extends StatefulWidget {
  static const routeName = '/selected_order_item_page';

  const SelectedOrderItemPage({super.key});

  @override
  State<SelectedOrderItemPage> createState() => _SelectedOrderItemPageState();
}

class _SelectedOrderItemPageState extends State<SelectedOrderItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // order comments
  bool _displayOrderComments = false;
  String? _orderComments;

  String? _pickUpCode;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final OrderItems orderItem = args['order_item'];

    return BlocProvider(
      create: (context) =>
          getIt<OrdersCubit>()..fetchOrderItemInfo(orderItem.itemId!),
      child: BlocBuilder<OrdersCubit, OrderState>(
        builder: (ctx, state) {
          return AppScaffold(
              appBarTitle: '#${orderItem.itemOrderRef}',
              child: state.maybeWhen(
                  orElse: () => const AppLoadingWidget(),
                  loading: () => const AppLoadingWidget(),
                  error: (error) => AppErrorWidget(msg: error),
                  orderItemInfo: (OrderItemInfo orderItemInfo,
                      OrderItemProductInfo orderItemProductInfo) {
                    return Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 3),
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Image",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: orderItemProductInfo.subProductInfo
                                          ?.subProductImages?.isEmpty ==
                                      true
                                  ? [
                                      CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        height: 120,
                                        placeholder: (_, __) => Container(
                                          color: AppColors.bg1,
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          color: Colors.grey,
                                        ),
                                        imageUrl:
                                            orderItemProductInfo.mobileImage ??
                                                '',
                                      )
                                    ]
                                  : orderItemProductInfo
                                      .subProductInfo!.subProductImages!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.contain,
                                              height: 120,
                                              placeholder: (_, __) => Container(
                                                color: AppColors.bg1,
                                              ),
                                              errorWidget: (_, __, ___) =>
                                                  Container(
                                                color: Colors.grey,
                                              ),
                                              imageUrl: e,
                                            ),
                                          ))
                                      .toList(),
                            ),
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Product Name",
                            description: "${orderItemProductInfo.productName}",
                          ),
                          TextButton(
                              onPressed: () {
                                // attach additional info
                                orderItemProductInfo.shippingStatus =
                                    orderItemInfo
                                        .getShipmentStatus()
                                        .description;
                                orderItemProductInfo.quantity =
                                    orderItem.noOfProduct.toString();

                                _displayProductInfo(orderItemProductInfo);
                              },
                              child: Text(
                                'View Product Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.colorPrimary),
                              )),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Price",
                            description:
                                orderItemInfo.unitPrice.formatCurrency('ETB'),
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Total Amount",
                            description:
                                orderItemInfo.totalAmount.formatCurrency('ETB'),
                          ),
                          const Divider(),
                          TitleWithDescriptionWidget(
                            title: "Created Date",
                            description: orderItemInfo.createdDate ?? '',
                          ),
                          const Divider(),
                          Text(
                            "Order Status",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          switch (orderItemInfo.getShipmentStatus()) {
                            ShipmentStatus.newOrder =>
                              _acceptOrderWidgets(orderItem.itemId, () {
                                // refresh order state
                                ctx
                                    .read<OrdersCubit>()
                                    .fetchOrderItemInfo(orderItem.itemId!);
                              }),
                            ShipmentStatus.readyForPickUp => Text(
                                "Messenger is on the way to pick up the order item",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(),
                              ),
                            ShipmentStatus.validateOtp =>
                              _validateOtpWidget(orderItem.itemId, () {
                                // refresh order state
                                ctx
                                    .read<OrdersCubit>()
                                    .fetchOrderItemInfo(orderItem.itemId!);
                              }),
                            _ => Text(
                                'Completed',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(),
                              )
                          },
                        ],
                      ),
                    );
                  }));
        },
      ),
    );
  }

  Widget _validateOtpWidget(num? orderId, Function onCodeValidated) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: BlocConsumer<OrdersCubit, OrderState>(
        listener: (ctx, state) {
          if (state is OrderStateError) {
            ctx.displaySnack(state.msg);
          }

          if (state is OrderStateSuccess) {
            ctx.displaySnack("Code validated successfully");
            // reset visibility
            setState(() {
              _displayOrderComments = false;
            });
            onCodeValidated();
          }
        },
        builder: (ctx, state) {
          return Column(
            children: [
              // use same key as comments field since they need to be shown at the same time
              // TODO: reuse different var
              if (_displayOrderComments)
                AppTextField(
                  title: 'Pick up code',
                  valueChanged: (value) {
                    setState(() {
                      _pickUpCode = value;
                    });
                  },
                  formFieldValidator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Enter pick up code';
                    }
                    return null;
                  },
                ),
              if (_displayOrderComments) _commentsField(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButtonWidget(
                    isLoading: state is OrderStateLoading,
                    text: 'Validate Pick Up Code',
                    onClick: () {
                      if (!_displayOrderComments) {
                        _displayOrderComments = true;
                        setState(() {});
                        return;
                      }

                      if (_formKey.currentState?.validate() == true) {
                        print(orderId!);
                        print(_orderComments!);
                        print(_pickUpCode!);
                        FocusScope.of(context).unfocus();
                        ctx.read<OrdersCubit>().validatePickUpCode(
                            orderId, _orderComments!, _pickUpCode!);
                      }
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _commentsField() => AppTextField(
        title: 'Enter Comments',
        maxLines: 6,
        formFieldValidator: (value) {
          if (value?.isEmpty == true) {
            return 'Enter comments to accept order';
          }
          return null;
        },
        valueChanged: (value) {
          setState(() {
            _orderComments = value;
          });
        },
      );

  Widget _acceptOrderWidgets(num? orderId, Function onAccepted) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: BlocConsumer<OrdersCubit, OrderState>(
        listener: (ctx, state) {
          if (state is OrderStateError) {
            ctx.displaySnack(state.msg);
          }

          if (state is OrderStateSuccess) {
            ctx.displaySnack("Order accepted for pick up successfully");
            // reset visibility
            setState(() {
              _displayOrderComments = false;
            });
            onAccepted();
          }
        },
        builder: (ctx, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_displayOrderComments) _commentsField(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButtonWidget(
                    isLoading: state is OrderStateLoading,
                    text: 'Accept Order For Pick up',
                    onClick: () async {
                      if (!_displayOrderComments) {
                        _displayOrderComments = true;
                        setState(() {});
                        return;
                      }

                      if (_formKey.currentState?.validate() == true) {
                        print(orderId);
                        FocusScope.of(context).unfocus();
                        ctx
                            .read<OrdersCubit>()
                            .acceptOrderForPickUp(orderId!, _orderComments!);
                      }
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  void _displayProductInfo(OrderItemProductInfo orderItemProductInfo) {
    showModalBottomSheet(
        backgroundColor: AppColors.bgCreamWhite,
        context: context,
        builder: (ctx) => OrderItemProductInfoBs(
              orderItemProductInfo: orderItemProductInfo,
            ));
  }
}
