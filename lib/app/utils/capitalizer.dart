import 'package:flutter/services.dart';

class CapitalizeEachWordInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}

class CapitalizeFirstLetterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    String newText =
        newValue.text[0].toUpperCase() + newValue.text.substring(1);
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
