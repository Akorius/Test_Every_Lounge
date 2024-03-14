import 'package:flutter/services.dart';

class OnlyOneWordTextFormatter extends FilteringTextInputFormatter {
  OnlyOneWordTextFormatter() : super.deny(" ");
}
