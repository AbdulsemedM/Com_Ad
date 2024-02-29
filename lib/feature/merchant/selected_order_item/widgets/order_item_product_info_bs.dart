import 'package:commercepal_admin_flutter/app/utils/string_utils.dart';
import 'package:flutter/material.dart';

import '../../../../core/orders/domain/model/order_item_product_info.dart';
import '../../../../core/widgets/title_with_description_widget.dart';

class OrderItemProductInfoBs extends StatelessWidget {
  final OrderItemProductInfo orderItemProductInfo;

  const OrderItemProductInfoBs({super.key, required this.orderItemProductInfo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Product Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleWithDescriptionWidget(
                        title: 'Shipping Status',
                        description: '${orderItemProductInfo.shippingStatus}'),
                    const Divider(),
                    TitleWithDescriptionWidget(
                        title: 'Short Description',
                        description:
                            '${orderItemProductInfo.shortDescription}'),
                    const Divider(),
                    TitleWithDescriptionWidget(
                        title: 'Quantity',
                        description: '${orderItemProductInfo.quantity}'),
                    const Divider(),
                    TitleWithDescriptionWidget(
                        title: 'Actual Price',
                        description:
                            '${orderItemProductInfo.subProductInfo?.unitPrice.formatCurrency('ETB')}'),
                    const Divider(),
                    TitleWithDescriptionWidget(
                        title: 'Discount',
                        description:
                            '${orderItemProductInfo.subProductInfo?.discountAmount.formatCurrency('ETB')}'),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (orderItemProductInfo
                            .subProductInfo?.features?.isNotEmpty ==
                        true)
                      Text(
                        'Features',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    if (orderItemProductInfo
                            .subProductInfo?.features?.isNotEmpty ==
                        true)
                      const SizedBox(
                        height: 10,
                      ),
                    if (orderItemProductInfo
                            .subProductInfo?.features?.isNotEmpty ==
                        true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: orderItemProductInfo.subProductInfo!.features!
                            .map((e) => TitleWithDescriptionWidget(
                                title: '${e.featureName}',
                                description: '${e.featureValue}'))
                            .toList(),
                      )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
