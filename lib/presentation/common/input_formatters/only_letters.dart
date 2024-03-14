import 'package:flutter/services.dart';

class OnlyLettersTextFormatter extends FilteringTextInputFormatter {
  OnlyLettersTextFormatter() : super.allow(RegExp("[a-zA-Zа-яА-Я]"));
}
