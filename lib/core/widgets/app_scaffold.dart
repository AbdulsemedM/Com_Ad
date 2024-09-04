import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final String appBarTitle;
  final String? subTitle;
  final Widget child;

  const AppScaffold(
      {super.key,
      required this.child,
      required this.appBarTitle,
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCreamWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subTitle != null)
              Text(
                subTitle!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.secondaryTextColor
                ),
              ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
