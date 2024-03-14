import 'package:duration/duration.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_anon.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_old_token.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/settings/settings.dart';
import 'package:everylounge/domain/usecases/user/update_tinkoff_user.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/router.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const path = "splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      afterRendering();
    });
    super.initState();
  }

  afterRendering() {
    if (PlatformWrap.isWeb) {
      webWasInitialized = true;
      if (commonBuild) {
        context.go(AppRoutes.homeBottomNavigation);
      } else {
        context.go(AppRoutes.loginBottomNavigation);
      }
    } else {
      Future.delayed(PlatformWrap.isWeb ? ms(100) : seconds(3)).then((value) {
        getIt<MetricsUseCase>().init(production ? metricsKey : metricsDebugKey);
        return getIt<SignInWithOldTokenUseCase>().signIn();
      }).then((result) {
        if (!result.isSuccess) {
          Log.message(result.message, sender: "SplashScreen", skipInProduction: true);
        }
        return getIt<SignInWithAnonUseCase>().signIn();
      }).then((result) {
        if (!result.isSuccess) {
          Log.message(result.message, sender: "SplashScreen", skipInProduction: true);
        }
        return getIt<UpdateTinkoffUserUseCase>().update();
      }).then((result) {
        if (!result.isSuccess) {
          Log.message(result.message, sender: "SplashScreen", skipInProduction: true);
        }
        return getIt<SettingsUseCase>().getSettings(isInit: true);
      }).then((result) {
        if (!result.isSuccess) {
          Log.message(result.message, sender: "SplashScreen", skipInProduction: true);
        }
        context.go(AppRoutes.loginBottomNavigation);
      }).catchError((e, s) {
        Log.exception(e, s, "SplashScreen");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const EveryloungeSplash();
  }
}

class EveryloungeSplash extends StatelessWidget {
  const EveryloungeSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(AppImages.splashBackground, fit: BoxFit.fitWidth),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EveryAppLoader(
                size: 62,
                forSplash: true,
              ),
              const SizedBox(height: 28),
              SvgPicture.asset(AppImages.splashLogo),
            ],
          ),
        ),
      ],
    );
  }
}
