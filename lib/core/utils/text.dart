import 'package:intl/intl.dart';

class TextUtils {
  static String availableText(int count) {
    return Intl.plural(
      count,
      zero: 'Доступно',
      one: 'Доступен',
      two: 'Доступно',
      few: 'Доступно',
      many: 'Доступно',
      other: 'Доступно',
      locale: 'ru',
    );
  }

  static String passesText(int count) {
    return "$count ${Intl.plural(
      count,
      zero: 'проходов',
      one: 'проход',
      two: 'прохода',
      few: 'прохода',
      many: 'проходов',
      other: 'проходов',
      locale: 'ru',
    )}";
  }

  static String guestsText(int count) {
    return "$count ${Intl.plural(
      count,
      zero: 'гостей',
      one: 'гость',
      two: 'гостя',
      few: 'гостя',
      many: 'гостей',
      other: 'гости',
      locale: 'ru',
    )}";
  }

  static String getAdultAge(int minAdultAge) {
    if (minAdultAge == 1) {
      return "$minAdultAge года";
    } else {
      return "$minAdultAge лет";
    }
  }
}
