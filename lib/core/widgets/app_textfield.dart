import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextInputType? textInputType;
  final String? title;
  final String? hint;
  final bool? obscureText;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged? valueChanged;
  final FormFieldValidator? formFieldValidator;

  const AppTextField({Key? key,
    this.valueChanged,
    this.formFieldValidator,
    this.textInputType,
    this.obscureText,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(left: 8.0, top: 8, right: 8, bottom: 6),
          child: Text(
            "$title",
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                color: Colors.black87
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
          child: TextFormField(
            maxLines: maxLines,
            maxLength: maxLength,
            obscureText: obscureText ?? false,
            keyboardType: textInputType,
            validator: formFieldValidator,
            style: const TextStyle(color: AppColors.secondaryColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: valueChanged,
            decoration: buildInputDecoration(hint ?? ''),
          ),
        ),
      ],
    );
  }
}

InputDecoration buildInputDecoration(String hint) =>
    InputDecoration(
        hintText: hint,
        fillColor: AppColors.cardBg,
        filled: true,
        focusedBorder: buildInputBorder(),
        errorBorder: buildInputBorder(),
        errorMaxLines: 2,
        focusedErrorBorder: buildInputBorder(),
        disabledBorder: buildInputBorder(),
        enabledBorder: buildInputBorder());

OutlineInputBorder buildInputBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.transparent, width: 0));
}
