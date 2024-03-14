import 'package:flutter/services.dart';

class StartPhoneWithRuCodeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    ///Если пользователь вводит второй плюс, не позволяем
    if ("+".allMatches(newValue.text).length > 1) {
      return newValue.copyWith(
          text: newValue.text.replaceFirst("+", "", 1),
          selection: TextSelection(
            baseOffset: newValue.selection.baseOffset - 1,
            extentOffset: newValue.selection.extentOffset - 1,
          ));
    }

    ///Если  новое значение начинается с +7, то позволяем писать
    if (newValue.text.startsWith("+7")) {
      return newValue;
    }

    ///Если новое значение это попытка написать что-то перед +7 или удалить 7 и +, то мы не позволяем
    if (!newValue.text.startsWith("+7")) {
      ///Если пользователь хочет что-то написать перед +7
      if (newValue.text.substring(1).startsWith("+7")) {
        return newValue.copyWith(
            text: newValue.text.substring(1),
            selection: TextSelection(
              baseOffset: newValue.selection.baseOffset - 1,
              extentOffset: newValue.selection.extentOffset - 1,
            ));

        ///Если пользователь хочет удалить плюс
      } else if (newValue.text.startsWith("7")) {
        return newValue.copyWith(
            text: "+${newValue.text}",
            selection: TextSelection(
              baseOffset: newValue.selection.baseOffset + 1,
              extentOffset: newValue.selection.extentOffset + 1,
            ));
      } else if (newValue.text.startsWith("+")) {
        ///Если пользователь хочет написать что-то между + и 7
        if (newValue.text.length > 2 && newValue.text[2] == "7") {
          return newValue.copyWith(
              text: "+7${newValue.text.substring(3)}",
              selection: TextSelection(
                baseOffset: newValue.selection.baseOffset - 1,
                extentOffset: newValue.selection.extentOffset - 1,
              ));
        }

        ///Если пользователь хочет удалить 7ку
        return newValue.copyWith(
            text: "+7${newValue.text.substring(1)}",
            selection: TextSelection(
              baseOffset: newValue.selection.baseOffset + 1,
              extentOffset: newValue.selection.extentOffset + 1,
            ));
      }
    }
    return newValue;
  }
}
