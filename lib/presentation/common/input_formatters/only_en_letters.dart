import 'package:flutter/services.dart';

class OnlyEnLettersTextFormatter extends FilteringTextInputFormatter {
  OnlyEnLettersTextFormatter() : super.allow(RegExp("[a-zA-Z]"));
}
