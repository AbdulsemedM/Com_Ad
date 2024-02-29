import 'package:flutter/material.dart';

class TitleWithDescriptionWidget extends StatelessWidget {
  final String title;
  final String description;

  const TitleWithDescriptionWidget(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        )
      ],
    );
  }
}
