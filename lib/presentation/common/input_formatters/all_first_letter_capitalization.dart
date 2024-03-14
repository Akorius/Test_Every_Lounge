import 'package:flutter/services.dart';

class AllFirstLettersUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.capitalizeFirstLetters(), selection: newValue.selection);
  }
}

extension StringExtension on String {
  String capitalizeFirstLetters() {
    var words = toLowerCase().split(" ");
    words = words.map((e) => e[0].toUpperCase() + e.substring(1)).toList();
    return words.join(" ");
  }
}
