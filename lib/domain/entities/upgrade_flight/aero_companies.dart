import 'package:everylounge/presentation/common/assets/assets.dart';

enum AeroCompany { s7, aeroflot }

extension AeroCompanyExt on AeroCompany {
  String get name {
    switch (this) {
      case AeroCompany.s7:
        return "S7 Airlines";
      case AeroCompany.aeroflot:
        return "Aeroflot";
    }
  }

  String get circleImage {
    switch (this) {
      case AeroCompany.s7:
        return AppImages.s7Circle;
      case AeroCompany.aeroflot:
        return AppImages.aeroflotCircle;
    }
  }
}
