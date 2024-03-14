import 'package:flutter/services.dart';

class OnlyPhoneLettersTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final buffer = StringBuffer("");
    var selectionOffset = 0;
    for (var i = 0; newValue.text.length > i; i++) {
      if (newValue.text[i].contains(RegExp('[0-9+]'))) {
        buffer.write(newValue.text[i]);
      } else {
        selectionOffset -= 1;
      }
    }
    return newValue.copyWith(
        text: buffer.toString(),
        selection: TextSelection(
          baseOffset: newValue.selection.baseOffset + selectionOffset,
          extentOffset: newValue.selection.extentOffset + selectionOffset,
        ));
  }
}
