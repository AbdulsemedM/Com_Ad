import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/utils/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final String? image;
  final String? name;
  final Function? onClick;

  const CategoryItem({
    super.key,
    this.image,
    this.name,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: AppColors.cardBg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            CachedNetworkImage(
              width: 90,
              height: 90,
              fit: BoxFit.contain,
              placeholder: (_, __) => Container(
                color: Colors.grey.shade200,
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey,
              ),
              imageUrl: image ?? "",
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(
                "$name",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
