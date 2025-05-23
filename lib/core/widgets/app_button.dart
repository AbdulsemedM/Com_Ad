import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

class AppButtonWidget extends StatelessWidget {
  final Function onClick;
  final bool? isLoading;
  final String text;
  final Color bgColor;

  const AppButtonWidget(
      {Key? key,
      required this.onClick,
      this.isLoading = false,
      this.text = "Submit",
      this.bgColor = AppColors.colorPrimary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading != true
            ? () {
                onClick.call();
              }
            : null,
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.disabled)
                    ? Colors.grey
                    : bgColor)),
        child: isLoading == true
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                text,
                style: const TextStyle(color: AppColors.bgCreamWhite),
              ),
      ),
    );
  }
}
