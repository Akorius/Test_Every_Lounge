abstract class TextValidators {
  static String? email(String email) {
    if (email.isEmpty) return "Email пуст";
    if (!RegExp(_Reg.email).hasMatch(email)) return "Неправильный email";
    return null;
  }

  static String? name(String email) {
    if (email.length < 2) return "Не менее двух символов";
    return null;
  }

  static String? flyNumber(String flyNumber) {
    if (flyNumber.length < 3) return "Не менее трех символов";
    return null;
  }

  static String? phoneNumber(String phoneNumber) {
    if (phoneNumber.length < 16) return "Не полный номер телеофона";
    return null;
  }
}

abstract class _Reg {
  static const String email =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
}
