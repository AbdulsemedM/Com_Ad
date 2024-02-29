import 'package:flutter/material.dart';

import '../../../../app/utils/app_colors.dart';

class OrderActionButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onClick;

  const OrderActionButton(
      {Key? key,
        required this.isSelected,
        required this.text,
        required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? AppColors.colorPrimary : Colors.black54),
            borderRadius: BorderRadius.circular(6)),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppColors.colorPrimaryDark : Colors.black54),
        ),
      ),
    );
  }
}
