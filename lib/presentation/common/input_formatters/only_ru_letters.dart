import 'package:flutter/services.dart';

class OnlyRuLettersTextFormatter extends FilteringTextInputFormatter {
  OnlyRuLettersTextFormatter() : super.allow(RegExp("[а-яА-Я]"));
}
