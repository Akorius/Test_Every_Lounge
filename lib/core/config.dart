import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:rate_my_app/rate_my_app.dart';

const production = false;

const metricsKey = '63485d30-5442-44f9-b28c-78f7709f366b';
const metricsDebugKey = '4ab70217-1ce0-41b9-ba8f-8b49431e1d8d';

const currentBuild = Builds.common;

final alfaBuild = alfaBuilds.contains(currentBuild);
const aClubBuild = currentBuild == Builds.alfaClub;
const commonBuild = currentBuild == Builds.common;

const iosStoreLink = 'https://apps.apple.com/us/app/every-lounge/id1634765737';
const androidStoreLink = 'https://play.google.com/store/apps/details?id=com.everylounge';

const successUrl = "everylounge://paysuccess";
const tinkoffSuccessUrl = "everylounge.app/tinkoff/success";
const tinkoffFailUrl = "everylounge.app/tinkoff/fail";
const apiTinkoffSuccessUrl = "everylounge.app/api/tinkoff/success";
const apiTinkoffFailUrl = "everylounge.app/api/tinkoff/fail";
const failUrl = "everylounge://payfail";
const transactionParam = "transaction";
final RateMyApp rateMyApp = RateMyApp(
  googlePlayIdentifier: 'com.everylounge',
  appStoreIdentifier: 'id1634765737',
);

enum Builds {
  alfaPremium5000,
  alfaPremium10000,
  alfaPremium15000,
  alfaClub,
  common,
}

const alfaBuilds = [
  Builds.alfaPremium5000,
  Builds.alfaPremium10000,
  Builds.alfaPremium15000,
  Builds.alfaClub,
];

extension BuildsExt on Builds {
  String get cashBackText {
    switch (this) {
      case Builds.alfaPremium5000:
      case Builds.alfaPremium10000:
      case Builds.alfaPremium15000:
      case Builds.common:
        return "Повышайте класс перелёта\nс кэшбэком до ${currentBuild.cashBackAlfaSize}\nот Альфа-Премиум*";
      case Builds.alfaClub:
        return "Повышайте класс перелёта с кэшбэком до 30 000 ₽ от А-Клуба*";
      default:
        return "";
    }
  }

  String get cashBackAlfaSize {
    switch (this) {
      case Builds.alfaPremium5000:
        return "5 000 ₽";
      case Builds.alfaPremium10000:
        return "10 000 ₽";
      case Builds.alfaPremium15000:
        return "15 000 ₽";
      default:
        return "";
    }
  }

  String get bg {
    switch (this) {
      case Builds.alfaPremium5000:
      case Builds.alfaPremium10000:
      case Builds.alfaPremium15000:
      case Builds.common:
        return AppImages.alfaUpgradeBg;
      case Builds.alfaClub:
        return AppImages.alfaUpgradeClubBg;
    }
  }

  int get header {
    switch (this) {
      case Builds.common:
        if (PlatformWrap.isAndroidOrIOS) {
          return 1;
        } else if (PlatformWrap.isWeb) {
          return 7;
        } else {
          return 0;
        }
      case Builds.alfaPremium5000:
        return 3;
      case Builds.alfaPremium10000:
        return 4;
      case Builds.alfaPremium15000:
        return 5;
      case Builds.alfaClub:
        return 6;
    }
  }
}
