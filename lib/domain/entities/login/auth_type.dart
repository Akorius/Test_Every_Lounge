import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';

///Описывает через что зарегистрировался пользователь
enum AuthType {
  anon, //0
  email, //1
  google, //2
  apple, //3
  tinkoff, //4
  tinkoffWebToWeb, //5
  alfa, //6
}

extension AuthTypeExt on AuthType {
  static AuthType fromInt(int? index) {
    switch (index) {
      case 0:
        return AuthType.anon;
      case 1:
        return AuthType.email;
      case 2:
        return AuthType.google;
      case 3:
        return AuthType.apple;
      case 4:
      case 5:
        return AuthType.tinkoff;
      case 6:
        return AuthType.alfa;
      default:
        Log.exception('Необработанный тип авторизации $index');
        return AuthType.anon;
    }
  }

  static String logos(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return '';
      case 2:
        return AppImages.google;
      case 3:
        return AppImages.apple;
      case 4:
      case 5:
        return AppImages.tinkoff;
      case 6:
        return AppImages.alfaIdLogo;
      default:
        return '';
    }
  }
}
