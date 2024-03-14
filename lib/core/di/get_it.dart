import 'package:dio/dio.dart';
import 'package:everylounge/core/utils/translitor.dart';
import 'package:everylounge/data/api/alfa/alfa_id.dart';
import 'package:everylounge/data/api/alfa/alfa_pay.dart';
import 'package:everylounge/data/api/feedback.dart';
import 'package:everylounge/data/api/file.dart';
import 'package:everylounge/data/api/login.dart';
import 'package:everylounge/data/api/lounge.dart';
import 'package:everylounge/data/api/metrics.dart';
import 'package:everylounge/data/api/order.dart';
import 'package:everylounge/data/api/passage.dart';
import 'package:everylounge/data/api/premium.dart';
import 'package:everylounge/data/api/privileges.dart';
import 'package:everylounge/data/api/settings.dart';
import 'package:everylounge/data/api/tinkoff_pass.dart';
import 'package:everylounge/data/api/upgrades.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/data/clients/gprc.dart';
import 'package:everylounge/data/clients/interceptors/token.dart';
import 'package:everylounge/data/clients/interceptors/unauth.dart';
import 'package:everylounge/data/clients/tinkoff_api_client.dart';
import 'package:everylounge/data/storages/card.dart';
import 'package:everylounge/data/storages/developer_mode.dart';
import 'package:everylounge/data/storages/old_tokens/old_tokens_storage.dart';
import 'package:everylounge/data/storages/orders.dart';
import 'package:everylounge/data/storages/remote_config/remote_config.dart';
import 'package:everylounge/data/storages/settings.dart';
import 'package:everylounge/data/storages/tokens.dart';
import 'package:everylounge/data/storages/update.dart';
import 'package:everylounge/data/storages/user.dart';
import 'package:everylounge/data/storages/user_preference.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_id.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_pay.dart';
import 'package:everylounge/domain/data/api/feedback.dart';
import 'package:everylounge/domain/data/api/file.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/data/api/metrics.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/data/api/passage.dart';
import 'package:everylounge/domain/data/api/premium.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/data/api/settings.dart';
import 'package:everylounge/domain/data/api/tinkoff_pass.dart';
import 'package:everylounge/domain/data/api/upgrades.dart';
import 'package:everylounge/domain/data/storages/card.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:everylounge/domain/data/storages/old_tokens.dart';
import 'package:everylounge/domain/data/storages/orders.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/data/storages/settings.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/data/storages/update.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/data/storages/user_preference.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_identifier.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/usecases/feedback/feedback.dart';
import 'package:everylounge/domain/usecases/file/file_upload.dart';
import 'package:everylounge/domain/usecases/login/add_alfa_id_to_user.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user_sdk.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user_web.dart';
import 'package:everylounge/domain/usecases/login/init_tinkoff_id_sdk.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_alfa_web.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_anon.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_apple.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_email.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_google.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_old_token.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_social_token.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_sdk.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_web.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_web_web.dart';
import 'package:everylounge/domain/usecases/lounge/check_aa_health.dart';
import 'package:everylounge/domain/usecases/lounge/get_airport.dart';
import 'package:everylounge/domain/usecases/lounge/get_lounges.dart';
import 'package:everylounge/domain/usecases/lounge/get_position.dart';
import 'package:everylounge/domain/usecases/lounge/search_airport.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/order/check_passage.dart';
import 'package:everylounge/domain/usecases/order/create_order.dart';
import 'package:everylounge/domain/usecases/order/find_out_partner_org.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/order/share_order.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';
import 'package:everylounge/domain/usecases/payment/init_pay.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_created.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_paid.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_alfa_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_pass.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_recurrent_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_tinkoff_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_tinkoff_web_view.dart';
import 'package:everylounge/domain/usecases/premium/get_premium.dart';
import 'package:everylounge/domain/usecases/privileges/add_by_phone_number.dart';
import 'package:everylounge/domain/usecases/privileges/attach_card.dart';
import 'package:everylounge/domain/usecases/privileges/check_success_attach_id.dart';
import 'package:everylounge/domain/usecases/privileges/get_bins.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/privileges/remove_card.dart';
import 'package:everylounge/domain/usecases/privileges/remove_passage.dart';
import 'package:everylounge/domain/usecases/privileges/set_active.dart';
import 'package:everylounge/domain/usecases/privileges/synchronize_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_bank.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_services_use_case.dart';
import 'package:everylounge/domain/usecases/setting_profile/get_developer_mode.dart';
import 'package:everylounge/domain/usecases/settings/settings.dart';
import 'package:everylounge/domain/usecases/translit.dart';
import 'package:everylounge/domain/usecases/upgrades/search_aeroflot.dart';
import 'package:everylounge/domain/usecases/upgrades/updgrade_aeroflot.dart';
import 'package:everylounge/domain/usecases/user/change_email.dart';
import 'package:everylounge/domain/usecases/user/check_rate.dart';
import 'package:everylounge/domain/usecases/user/delete_user.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/log_out.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:everylounge/domain/usecases/user/update_tinkoff_user.dart';
import 'package:everylounge/domain/usecases/user/update_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/common/cubit/payment/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/cubit.dart';
import 'package:everylounge/presentation/screens/feedback/cubit.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/enter_code/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/need_set_email/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_list/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/photo_viewer/cubit.dart';
import 'package:everylounge/presentation/screens/profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/widgets/managers/modal_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_alfa_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_other_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_tinkoff_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:native_launcher/native_launcher.dart';
import 'package:tinkoff_acquiring_native_flutter/tinkoff_acquiring_native_flutter.dart' as n;
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

final getIt = GetIt.instance;

Future<void> registerGetIt() async {
  ///3rd party
  getIt.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);
  getIt.registerLazySingleton<TinkoffIdFlutter>(() => TinkoffIdFlutter());
  getIt.registerLazySingleton<n.TinkoffAcquiring>(() => n.TinkoffAcquiring());
  getIt.registerLazySingleton<NativeLauncher>(() => NativeLauncher());
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(scopes: ["email"]));
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<OAuthProvider>(() => OAuthProvider("apple.com"), instanceName: "apple");

  ///Metrics
  getIt.registerLazySingleton<MetricsUseCase>(() => MetricsUseCaseImpl());

  ///Http Client, grpc
  getIt.registerLazySingleton<TokenInterceptor>(() => TokenInterceptor());
  getIt.registerLazySingleton<LogOutInterceptor>(() => LogOutInterceptor());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<TinkoffApiClient>(() => TinkoffApiClient());
  getIt.registerLazySingleton<Dio>(() => getIt<ApiClient>().create());
  getIt.registerLazySingleton<Grpc>(() => Grpc());

  ///Managers
  getIt.registerLazySingleton(() => ModalManager());
  getIt.registerFactoryParam<PassageManager, BankCard?, void>((BankCard? bankCard, _) {
    late PassageManager manager;
    if (bankCard?.type == BankCardType.alfaClub) {
      manager = PassageAlfaManager(checkPassageUseCase: getIt());
    } else if (isTinkoffTypeCard(bankCard?.type)) {
      manager = PassageTinkoffManager(tinkoffPassUseCase: getIt());
    } else {
      manager = PassageOtherManager();
    }
    manager.activeBankCard = bankCard;
    return manager;
  });

  ///Api
  getIt.registerLazySingleton<MetricsApi>(() => MetricsApiImpl());
  getIt.registerLazySingleton<LoginApi>(() => LoginApiImpl());
  getIt.registerLazySingleton<AlfaIdApi>(() => AlfaIdApiImpl());
  getIt.registerLazySingleton<OrderApi>(() => OrderApiImpl());
  getIt.registerLazySingleton<FeedbackApi>(() => FeedbackApiImpl());
  getIt.registerLazySingleton<PrivilegesApi>(() => PrivilegesApiImpl());
  getIt.registerLazySingleton<PassageApi>(() => PassageApiImpl());
  getIt.registerLazySingleton<FileApi>(() => FileApiImpl());
  getIt.registerLazySingleton<LoungeApi>(() => LoungeApiImpl());
  getIt.registerLazySingleton<PremiumServicesApi>(() => PremiumServicesApiImpl());
  getIt.registerLazySingleton<AppSettingsApi>(() => AppSettingsApiImpl());
  getIt.registerLazySingleton<UpgradesApi>(() => UpgradesApiImpl());
  getIt.registerLazySingleton<OrderGrpcService>(() => OrderGrpcService());
  getIt.registerLazySingleton<AlfaPayApi>(() => AlfaPayApiImpl());
  getIt.registerLazySingleton<TinkoffPassApi>(() => TinkoffPassApiImpl());

  ///Storages
  getIt.registerLazySingleton<TokensStorage>(() => TokensStorageImpl());
  getIt.registerLazySingleton<SettingsStorage>(() => SettingsStorageImpl());
  getIt.registerLazySingleton<OldTokensStorage>(() => OldTokensStorageImpl());
  getIt.registerLazySingleton<UserStorage>(() => UserStorageImpl());
  getIt.registerLazySingleton<RemoteConfigStorage>(() => RemoteConfigStorageImpl());
  getIt.registerLazySingleton<DeveloperModeStorage>(() => DeveloperModeStorageImpl());
  getIt.registerLazySingleton<UpdateStorage>(() => UpdateStorageImpl());
  getIt.registerLazySingleton<CardStorage>(() => CardStorageImpl());
  getIt.registerLazySingleton<OrdersStorage>(() => OrdersStorageImpl());

  ///Entities
  getIt.registerLazySingleton<BankCardIdentifier>(() => BankCardIdentifier());
  getIt.registerLazySingleton<Translitor>(() => Translitor());

  ///UseCases
  //sign in
  getIt.registerLazySingleton<SendSignInMetricUseCase>(() => SendSignInMetricImpl());
  getIt.registerLazySingleton<SignInWithSocialTokenUseCase>(() => SignInWithSocialTokenUseCaseImpl());
  getIt.registerLazySingleton<SignInWithTinkoffSDKUseCase>(() => SignInWithTinkoffIdUseCaseImpl());
  getIt.registerLazySingleton<SignInWithAlfaWebUseCase>(() => SignInWithAlfaWebUseCaseImpl());
  getIt.registerLazySingleton<SignInWithTinkoffWebUseCase>(() => SignInWithTinkoffWebUseCaseImpl());
  getIt.registerLazySingleton<SignInWithTinkoffWebToWebUseCase>(() => SignInWithTinkoffWebToWebUseCaseImpl());
  getIt.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCaseImpl());
  getIt.registerLazySingleton<SignInWithAppleUseCase>(() => SignInWithAppleUseCaseImpl());
  getIt.registerLazySingleton<SignInWithEmailUseCase>(() => SignInWithEmailUseCaseImpl());
  getIt.registerLazySingleton<SignInWithAnonUseCase>(() => SignInWithAnonUseCaseImpl());
  getIt.registerLazySingleton<SignInWithOldTokenUseCase>(() => SignInWithOldTokenUseCaseImpl());
  getIt.registerLazySingleton<AddAlfaIdToUserUseCase>(() => AddAlfaIdToUserUseCaseImpl());
  getIt.registerLazySingleton<AddTinkoffIdToUserUseCase>(() => AddTinkoffIdToUserUseCaseImpl());
  getIt.registerLazySingleton<AddTinkoffIdToUserSDKUseCase>(() => AddTinkoffIdToUserSDKUseCaseImpl());
  getIt.registerLazySingleton<AddTinkoffIdToUserWebUseCase>(() => AddTinkoffIdToUserWebUseCaseImpl());
  getIt.registerLazySingleton<InitTinkoffSDKUseCase>(() => InitTinkoffSDKUseCaseImpl());
  //user
  getIt.registerLazySingleton<GetUserUseCase>(() => GetUserUseCaseImpl());
  getIt.registerLazySingleton<ChangeEmailUseCase>(() => ChangeEmailUseCaseImpl());
  getIt.registerLazySingleton<DeleteUserUseCase>(() => DeleteUserUseCaseImpl());
  getIt.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCaseImpl());
  getIt.registerLazySingleton<LogOutUserUseCase>(() => LogOutUserUseCaseImpl());
  getIt.registerLazySingleton<UpdateTinkoffUserUseCase>(() => UpdateTinkoffUserUseCaseImpl());
  getIt.registerLazySingleton<UserPreferenceUseCase>(() => UserPreferenceUseCaseImpl());
  getIt.registerLazySingleton<TinkoffPassUseCase>(() => TinkoffPassUseCaseImpl());
  getIt.registerLazySingleton<CheckRateUseCase>(() => CheckRateUseCaseImpl());
  getIt.registerLazySingleton<CheckSuccessAttachIdUseCase>(() => CheckSuccessAttachIdUseCaseImpl());
  //cards and programs
  getIt.registerLazySingleton<RemoveCardUseCase>(() => RemoveCardUseCaseImpl());
  getIt.registerLazySingleton<RemovePassageUseCase>(() => RemovePassageUseCaseImpl());
  getIt.registerLazySingleton<GetCardsUseCase>(() => GetCardsUseCaseImpl());
  getIt.registerLazySingleton<SynchronizeCardsInMagazineAndBackendUseCase>(
      () => SynchronizeCardsInMagazineAndBackendUseCaseImpl());
  getIt.registerLazySingleton<AttachCardUseCase>(() => AttachCardUseCaseImpl());
  getIt.registerLazySingleton<GetBinsUseCase>(() => GetBinsUseCaseImpl());
  getIt.registerLazySingleton<SetActiveCardUseCase>(() => SetActiveCardUseCaseImpl());
  getIt.registerLazySingleton<AddBankByPhoneNumberUseCase>(() => AddBankByPhoneNumberUseCaseImpl());
  //pay
  getIt.registerLazySingleton<InitAcquiringUseCase>(() => InitAcquiringUseCaseImpl());
  getIt.registerLazySingleton<PayWithTinkoffPayUseCase>(() => PayWithTinkoffPayUseCaseImpl());
  getIt.registerLazySingleton<PayWithAlfaPayUseCase>(() => PayWithAlfaPayUseCaseImpl());
  getIt.registerLazySingleton<NotifyPaymentWasCreatedUseCase>(() => NotifyPaymentWasCreatedUseCaseImpl());
  getIt.registerLazySingleton<NotifyPaymentWasPaidUseCase>(() => NotifyPaymentWasPaidUseCaseImpl());
  getIt.registerLazySingleton<PayRecurrentPaymentUseCase>(() => PayRecurrentPaymentUseCaseImpl());
  getIt.registerLazySingleton<InitPayUseCase>(() => InitPayUseCaseImpl());
  getIt.registerLazySingleton<PayWithTinkoffWebView>(() => PayWithTinkoffWebViewImpl());
  getIt.registerLazySingleton<PayWithPassUseCase>(() => PayWithPassUseCaseImpl());
  //orders
  getIt.registerLazySingleton<CreateOrderUseCase>(() => CreateOrderUseCaseImpl());
  getIt.registerLazySingleton<GetUserOrdersUseCase>(() => GetUserOrdersUseCaseImpl());
  getIt.registerLazySingleton<ShareOrderUseCase>(() => ShareOrderUseCaseImpl());
  getIt.registerLazySingleton<FindOutPartnerOrgUseCase>(() => FindOutPartnerOrgUseCase());
  getIt.registerLazySingleton<CheckPassageUseCase>(() => CheckPassageUseCaseImpl());
  //settings
  getIt.registerLazySingleton<GetDeveloperModeUseCase>(() => GetDeveloperModeUseCaseImpl());
  getIt.registerLazySingleton<SettingsUseCase>(() => SettingsUseCaseImpl());
  //upgrades
  getIt.registerLazySingleton<SearchTicketUseCase>(() => SearchTicketUseCaseImpl());
  getIt.registerLazySingleton<UpgradeAeroflotUseCase>(() => UpgradeAeroflotUseCaseImpl());
  //airports/lounge
  getIt.registerLazySingleton<SearchAirportUseCase>(() => SearchAirportUseCaseImpl());
  getIt.registerLazySingleton<GetLoungesUseCase>(() => GetLoungesUseCaseImpl());
  getIt.registerLazySingleton<GetPremiumServicesUseCase>(() => GetPremiumServicesUseCaseImpl());
  getIt.registerLazySingleton<GetAirportUseCase>(() => GetAirportUseCaseImpl());
  getIt.registerLazySingleton<GetPositionUseCase>(() => GetPositionUseCaseImpl());
  getIt.registerLazySingleton<CheckAAHealthUseCase>(() => CheckAAHealthUseCaseImpl());
  //other
  getIt.registerLazySingleton<FeedbackUseCase>(() => FeedbackUseCaseImpl());
  getIt.registerLazySingleton<FileUploadUseCase>(() => FileUploadUseCaseImpl());
  getIt.registerLazySingleton<TranslitUseCase>(() => TranslitUseCaseImpl());
  getIt.registerLazySingleton<FindOutHideBanksUseCase>(() => FindOutHideBanksUseCaseImpl());
  getIt.registerLazySingleton<FindOutHideParamsUseCase>(() => FindOutHideParamsUseCaseImpl());
  getIt.registerLazySingleton<FindOutHideServicesUseCase>(() => FindOutHideServicesUseCaseImpl());

  ///Cubits
  getIt.registerFactory(() => SelectPaymentMethodCubit());
  getIt.registerFactoryParam((BankCardType bankType, _) => AddBankByPhoneNumberCubit(bankCardType: bankType));
  getIt.registerFactoryParam((BankCard bankCard, _) => BankProgramDetailedCubit(bankCard: bankCard));
  getIt.registerFactory(() => HomeCubit());
  getIt.registerFactory(() => OtherLoginCubit());
  getIt.registerFactory(() => NeedSetEmailCubit());
  getIt.registerFactoryParam((bool changeEmail, p2) => EnterCodeCubit(changeEmail: changeEmail));
  getIt.registerFactory(() => FeedbackCubit());
  getIt.registerFactory(() => ProfileCubit());
  getIt.registerFactoryParam((PremiumService service, InnerDestinationType destinationType) =>
      CreateOrderPremiumCubit(service: service, destinationType: destinationType));
  getIt.registerFactory(() => ProfileSettingsCubit());
  getIt.registerFactoryParam((ServiceSearchType searchType, _) => SearchAirportCubit(serviceType: searchType));
  getIt.registerFactoryParam((Airport airport, _) => PremiumServicesListCubit(airport: airport));
  getIt.registerFactoryParam((List<String> photoUrlsList, String? currentId) => PhotoViewerCubit(photoUrlsList, currentId));
  getIt.registerFactoryParam((Lounge lounge, BankCard? card) => LoungeCubit(
      lounge: lounge,
      activeCard: card,
      getCardsUseCase: getIt<GetCardsUseCase>(),
      getUserUseCase: getIt<GetUserUseCase>(),
      checkAAHealthUseCase: getIt<CheckAAHealthUseCase>(),
      attachCardCubit: getIt<AttachCardCubit>(),
      findOutHideParamsUseCase: getIt<FindOutHideParamsUseCase>(),
      translitUseCase: getIt<TranslitUseCase>(),
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      payWithPassUseCase: getIt<PayWithPassUseCase>(),
      payOrderCubit: getIt<PayOrderCubit>(),
      orderUseCase: getIt<GetUserOrdersUseCase>(),
      passageManager: getIt<PassageManager>(param1: card)));
  getIt.registerFactoryParam((PremiumService premiumService, InnerDestinationType destinationType) =>
      PremiumDetailsCubit(premiumService: premiumService, destinationType: destinationType));
  getIt.registerFactoryParam(
      (Airport? airport, String airportCode) => LoungeListCubit(airport: airport, airportCode: airportCode));
  getIt.registerFactoryParam((Order order, _) => OrderDetailsCubit(order: order));
  getIt.registerFactory(() => PayOrderCubit());
  getIt.registerFactory(() => AttachCardCubit());
  getIt.registerFactory(() => SearchUpgradeFlightCubit());
  getIt.registerFactoryParam((SearchedBooking searchedBooking, _) => CreateUpgradeOrderCubit(searchedBooking: searchedBooking));
}
