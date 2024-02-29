import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal_admin_flutter/app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/app_colors.dart';
import '../products/domain/models/product.dart';

class ProductItemWidget extends StatelessWidget {
  final double? width;
  final Product product;
  final Function? onItemClick;

  const ProductItemWidget(
      {Key? key, required this.product, this.width, this.onItemClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick?.call(product);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            Container(
              width: width,
              decoration: const BoxDecoration(
                color: AppColors.bg1,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        height: 120,
                        placeholder: (_, __) => Container(
                          color: AppColors.bg1,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey,
                        ),
                        imageUrl: product.mobileImage ?? '',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${product.productName}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                  if (product.currency != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (product.offerPrice != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "ETB ${product.offerPrice.toString()}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.colorPrimary),
                          ),
                        ),
                        const Spacer(),
                        if (product.isDiscounted.toString() == "1")
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("ETB ${product.offerPrice}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontSize: 12.sp,
                                        color: AppColors.secondaryTextColor,
                                        decoration:
                                            TextDecoration.lineThrough)),
                          ),
                      ],
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
