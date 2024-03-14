import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/data/constants/screen_description_map.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/check_rate.dart';
import 'package:everylounge/presentation/common/router/extra.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/screen.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/success_add_card_modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/success_remove_card_modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/try_remove_card_modal.dart';
import 'package:everylounge/presentation/screens/feedback/cubit.dart';
import 'package:everylounge/presentation/screens/feedback/feedback.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/success_send_feedback_modal.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/screen.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/update_app_screen.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/enter_code/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/enter_code/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/need_set_email/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/need_set_email/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/alfa_id_web_screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/tinkoff_id_web_callback/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/tinkoff_id_web_view/tinkoff_id_web_view.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_list/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_list/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/extra.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/screen.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/screen.dart';
import 'package:everylounge/presentation/screens/order_detail/upgrade_widget/info_screen.dart';
import 'package:everylounge/presentation/screens/photo_viewer/cubit.dart';
import 'package:everylounge/presentation/screens/photo_viewer/screen.dart';
import 'package:everylounge/presentation/screens/profile/cubit.dart';
import 'package:everylounge/presentation/screens/profile/screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/pdf_view.dart';
import 'package:everylounge/presentation/screens/setting_profile/screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/confirmation_screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/delete_account_screen.dart';
import 'package:everylounge/presentation/screens/splash/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

bool webWasInitialized = false;

final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _metricsUseCase.sendEvent(event: eventName[backButtonClick]!, type: MetricsEventType.click);
  }
}

final appRouter = GoRouter(
  navigatorKey: _navigatorKey,
  observers: [GoRouterObserver()],
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    if (state.uri.toString().contains(TinkoffIdWebCallbackScreen.path)) return state.path;
    if (state.uri.toString().contains("airport/")) return state.path;
    if (PlatformWrap.isWeb && !webWasInitialized) return AppRoutes.splash;
    if (state.uri.path.toString().contains("airport/") && state.uri.queryParameters.isNotEmpty) {
      getIt<MetricsUseCase>().sendScreenName(routes[AppRoutes.searchAirport]);
    } else {
      getIt<MetricsUseCase>().sendScreenName(routes[state.uri.path]);
    }
    return state.path;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    ///login related
    GoRoute(
        parentNavigatorKey: _navigatorKey,
        path: AppRoutes.loginBottomNavigation,
        builder: (context, state) => const LoginBottomNavigationScreen(),
        redirect: (context, state) {
          try {
            if (getIt<TokensStorage>().accessToken != null && getIt<UserStorage>().authType != AuthType.anon) {
              return AppRoutes.homeBottomNavigation;
            }
          } catch (e, s) {
            Log.exception(e, s, "GoRouter");
          }
          return state.path;
        }),
    GoRoute(
      path: AppRoutes.loginTinkoffWeb,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => TinkoffIdWebViewScreen(
        storage: getIt(),
      ),
    ),

    GoRoute(
      path: AppRoutes.loginAlfaWeb,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => AlfaIdWebScreen(link: state.extra as String),
    ),

    GoRoute(
      path: AppRoutes.loginOther,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<OtherLoginCubit>(
        create: (context) => getIt(),
        child: const OtherLoginScreen(),
      ),
      redirect: (context, state) {
        try {
          if (getIt<TokensStorage>().accessToken != null && getIt<UserStorage>().authType != AuthType.anon) {
            return AppRoutes.homeBottomNavigation;
          }
        } catch (e, s) {
          Log.exception(e, s, "GoRouter");
        }
        return state.path;
      },
    ),
    GoRoute(
      path: AppRoutes.loginEnterCode,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<EnterCodeCubit>(
        create: (context) => getIt(param1: state.extra as bool),
        child: const EnterCodeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginNeedSetEmail,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<NeedSetEmailCubit>(
        create: (context) => getIt(),
        child: const NeedSetEmailScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.tinkoffIdWebCallback,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) {
        return TinkoffIdWebCallbackScreen(
          code: state.uri.queryParameters["code"],
        );
      },
    ),

    ///home
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.homeBottomNavigation,
      builder: (context, state) => const HomeBottomNavigationScreen(),
    ),

    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.updateAppScreen,
      builder: (context, state) => BlocProvider<HomeCubit>(create: (context) => getIt(), child: const UpdateAppScreen()),
    ),

    ///profile related
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<ProfileCubit>(
        create: (context) => getIt(),
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settingProfileScreen,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<ProfileSettingsCubit>(
        create: (context) => getIt(),
        child: const SettingProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.deleteProfileScreen,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<ProfileSettingsCubit>(
        create: (context) => getIt(),
        child: const DeleteProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.confirmationDeleteScreen,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<ProfileSettingsCubit>(
        create: (context) => getIt(),
        child: const ConfirmationDeleteScreen(),
      ),
    ),

    ///bank programs related
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.selectPaymentMethodModal,
      pageBuilder: (context, state) => ModalPage(
        child: BlocProvider<SelectPaymentMethodCubit>(
          create: (context) => getIt(),
          child: const SelectPaymentMethodModal(),
        ),
      ),
    ),

    GoRoute(
      path: AppRoutes.addByPhoneNumberModal,
      parentNavigatorKey: _navigatorKey,
      pageBuilder: (context, state) => ModalPage(
        child: BlocProvider<AddBankByPhoneNumberCubit>(
          create: (context) => getIt(param1: state.extra as BankCardType),
          child: const AddBankByPhoneNumberModal(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.bankProgramDetailed,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<BankProgramDetailedCubit>(
        create: (context) => getIt.call(param1: state.extra as BankCard),
        child: BankProgramDetailedScreen(bankCard: state.extra as BankCard),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.successAddCardModal,
      pageBuilder: (context, state) => ModalPage(
        child: SuccessAddCardModal(cardType: state.extra as BankCardType?),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.successRemoveCardModal,
      pageBuilder: (context, state) => ModalPage(
        child: SuccessRemoveCardModal(card: state.extra as BankCard),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.tryRemoveCardModal,
      pageBuilder: (context, state) => ModalPage(
        child: TryRemoveCardModal(
          card: (state.extra as Map)["card"] as BankCard,
          callback: (state.extra as Map)["callback"] as Function,
        ),
      ),
    ),

    ///upgradeFlight
    GoRoute(
      path: AppRoutes.upgradeFlight,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<SearchUpgradeFlightCubit>(
        create: (context) => getIt(),
        child: const SearchUpgradeBookingScreen(),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.completeUpgradeInfoScreen,
      builder: (context, state) => const CompleteUpgradeInfoScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.flightOrder,
      builder: (context, state) => BlocProvider<CreateUpgradeOrderCubit>(
        create: (context) => getIt(param1: state.extra as SearchedBooking),
        child: const CreateUpgradeOrderScreen(),
      ),
    ),

    ///business_lounges related
    GoRoute(
      path: AppRoutes.searchAirport,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<SearchAirportCubit>(
        create: (context) => getIt.call(param1: state.extra as ServiceSearchType),
        child: const SearchAirportScreen(),
      ),
    ),
    GoRoute(
      path: "${AppRoutes.businessLoungeList}/:airportCode",
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<LoungeListCubit>(
        create: (context) => getIt.call(
          param1: (state.extra as Map?)?["airport"],
          param2: state.pathParameters["airportCode"],
        ),
        child: const LoungeListScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.premiumServicesList,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<PremiumServicesListCubit>(
        create: (context) => getIt.call(
          param1: (state.extra as Map)["airport"],
        ),
        child: PremiumServicesListScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.businessLoungeDetails,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<LoungeCubit>(
        create: (context) => getIt.call(
          param1: (state.extra as Map)["lounge"],
          param2: (state.extra as Map)["card"],
        ),
        child: LoungeDetailsScreen(
          type: (state.extra as Map)["searchType"],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.photoViewer,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<PhotoViewerCubit>(
        create: (context) => getIt.call(
          param1: (state.extra as Map)[AppExtra.photoIdsList],
          param2: (state.extra as Map?)?[AppExtra.currentId],
        ),
        child: const PhotoViewerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.premiumServicesDetails,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<PremiumDetailsCubit>(
        create: (context) => getIt.call(param1: (state.extra as Map)["service"], param2: (state.extra as Map)["destinationType"]),
        child: const PremiumDetailsScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.createOrderPremium,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<CreateOrderPremiumCubit>(
            create: (context) => getIt.call(
              param1: (state.extra as Map)["service"],
              param2: (state.extra as Map)["destinationType"],
            ),
          ),
          BlocProvider<SearchAirportCubit>(
            create: (context) => getIt.call(param1: ServiceSearchType.lounge),
          ),
        ],
        child: const CreateOrderPremiumScreen(),
      ),
    ),
    GoRoute(
        path: AppRoutes.acquiringWebViewTinkkoff,
        parentNavigatorKey: _navigatorKey,
        builder: (context, state) {
          final extra = state.extra as AcquiringExtraObject;
          return TinkoffAcquiringWebView(
            paymentUrl: extra.paymentUrl,
            activeCardType: extra.activeCardType,
            onPaymentSuccess: extra.onPaymentSuccess,
            onPaymentFailure: extra.onPaymentFailure,
            showTinkoffWarning: extra.showTinkoffWarning,
          );
        }),

    GoRoute(
      parentNavigatorKey: _navigatorKey,
      onExit: (BuildContext context) {
        getIt<CheckRateUseCase>().checkNeedShowRate();
        return true;
      },
      path: AppRoutes.orderDetailsModal,
      pageBuilder: (context, state) => ModalPage(
        child: BlocProvider<OrderDetailsCubit>(
          create: (context) => getIt(param1: state.extra as Order),
          child: const OrderDetailsScreen(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      onExit: (BuildContext context) {
        getIt<CheckRateUseCase>().checkNeedShowRate();
        return true;
      },
      path: AppRoutes.orderDetailsScreen,
      builder: (context, state) => BlocProvider<OrderDetailsCubit>(
        create: (context) => getIt(param1: state.extra as Order),
        child: const OrderDetailsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.feedbackContacts,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) => BlocProvider<FeedbackCubit>(
        create: (context) => getIt(),
        child: const FeedbackContacts(),
      ),
    ),
    GoRoute(
      path: AppRoutes.pdfViewScreen,
      parentNavigatorKey: _navigatorKey,
      builder: (context, state) {
        final extra = state.extra as PdfData;
        return PDFView(pdfData: extra);
      },
    ),
    GoRoute(
      parentNavigatorKey: _navigatorKey,
      path: AppRoutes.successSendFeedbackModal,
      pageBuilder: (context, state) => const ModalPage(
        child: SuccessSendFeedbackModal(),
      ),
    ),
  ],
);

class ModalPage<T> extends Page<T> {
  final Widget child;

  const ModalPage({
    required this.child,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
      isScrollControlled: true,
      settings: this,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      )),
      builder: (context) => Material(
            color: Colors.transparent,
            child: child,
          ));
}
