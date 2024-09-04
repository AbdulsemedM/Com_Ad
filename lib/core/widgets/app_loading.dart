import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? message;

  const AppLoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Column(
            children: [
              const CircularProgressIndicator(
                strokeWidth: 1,
                color: AppColors.colorPrimaryDark,
              ),
              if (message != null)
                const SizedBox(
                  height: 10,
                ),
              if (message != null)
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
            ],
          )
        ],
      ),
    );
  }
}

class AppPro extends StatelessWidget {
  const AppPro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
