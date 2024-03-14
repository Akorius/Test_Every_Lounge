import 'package:intl/intl.dart';

class MoneyFormatter {
  static final oCcy = NumberFormat("#,###");

  static String getFormattedCost(num cost) {
    var formattedCost = oCcy.format(cost);
    return formattedCost.replaceAll(",", " ");
  }
}
