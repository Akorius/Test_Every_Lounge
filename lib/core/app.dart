import 'package:debug_overlay/debug_overlay.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/presentation/common/router/router.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/main_theme.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/history/cubit.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class EveryLoungeApp extends StatelessWidget {
  const EveryLoungeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppTheme>(create: (context) => MainAppTheme()),
        Provider<AppTextStyleTheme>(create: (context) => AppTextStyleTheme(context)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBottomNavigationCubit>(create: (context) => HomeBottomNavigationCubit()),
          BlocProvider<LoginBottomNavigationCubit>(create: (context) => LoginBottomNavigationCubit()),
          BlocProvider<HistoryCubit>(create: (context) => HistoryCubit()),
        ],
        child: MaterialApp.router(
          builder: DebugOverlay.builder(showOnShake: false, enableOnlyInDebugMode: production ? true : false),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          title: 'EveryLoungeApp',
          theme: ThemeData(useMaterial3: false),
          locale: const Locale("ru", "RU"),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('en'), Locale('ru')],
        ),
      ),
    );
  }
}
