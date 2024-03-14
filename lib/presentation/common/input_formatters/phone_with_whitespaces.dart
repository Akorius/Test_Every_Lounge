import 'package:flutter/services.dart';

class PhoneWithWhiteSpacesRuTextFormatter extends TextInputFormatter {
  final String pattern = "## ### ### ## ##";

  String oldResult = "";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var localPattern = pattern;
    var whiteSpacesToDelete = " ".allMatches(newValue.text).length;
    var unspacedNewValue = newValue.text.replaceAll(" ", "");
    var unspacedOldValue = oldValue.text.replaceAll(" ", "");

    ///Подставляем каждый символ в паттерн
    for (int i = 0; unspacedNewValue.length > i; i++) {
      localPattern = localPattern.replaceFirst("#", unspacedNewValue[i]);
    }

    ///обрезаем паттерн
    localPattern = localPattern.split(RegExp('[#]'))[0];
    localPattern = localPattern.trimRight();
    var whiteSpacesToAdd = " ".allMatches(localPattern).length;

    ///Обрабатываем случай, когда мы удаляем пробел, но ничего не удаляется
    if (oldResult == localPattern) {
      if (unspacedNewValue.length == unspacedOldValue.length) {
        final part1 = unspacedNewValue.substring(0, newValue.selection.baseOffset - whiteSpacesToAdd);
        final part2 = unspacedNewValue.substring(newValue.selection.baseOffset + 1 - whiteSpacesToAdd);
        final whole = part1 + part2;
        localPattern = pattern;
        for (int i = 0; whole.length > i; i++) {
          localPattern = localPattern.replaceFirst("#", whole[i]);
        }

        ///обрезаем паттерн
        localPattern = localPattern.split(RegExp('[#]'))[0];
        localPattern = localPattern.trimRight();
        whiteSpacesToAdd = " ".allMatches(localPattern).length;
        whiteSpacesToDelete = whiteSpacesToDelete + 2;
      }
    }

    oldResult = localPattern;
    final offset = newValue.selection.baseOffset - whiteSpacesToDelete + whiteSpacesToAdd;
    return newValue.copyWith(
      text: localPattern,
      selection: TextSelection(
        baseOffset: offset > pattern.length ? pattern.length : offset,
        extentOffset: offset > pattern.length ? pattern.length : offset,
      ),
    );
  }
}
