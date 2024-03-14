import 'package:dio/dio.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/storages/card.dart';
import 'package:everylounge/data/storages/developer_mode.dart';
import 'package:everylounge/data/storages/old_tokens/old_tokens_storage.dart';
import 'package:everylounge/data/storages/orders.dart';
import 'package:everylounge/data/storages/remote_config/firebase_options.dart';
import 'package:everylounge/data/storages/settings.dart';
import 'package:everylounge/data/storages/tokens.dart';
import 'package:everylounge/data/storages/update.dart';
import 'package:everylounge/data/storages/user.dart';
import 'package:everylounge/data/storages/user_preference.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/usecases/login/init_tinkoff_id_sdk.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future initAsyncServices() async {
  //root independent: firebase app, Hive
  await Future.wait([
    Hive.initFlutter(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  //firebase and hive dependent
  await Future.wait([
    TokensStorageImpl.initHive(),
    SettingsStorageImpl.initHive(),
    OldTokensStorageImpl.initHive(),
    UserStorageImpl.initHive(),
    DeveloperModeStorageImpl.initHive(),
    CardStorageImpl.initHive(),
    OrdersStorageImpl.initHive(),
    UpdateStorageImpl.initHive(),
    UserPreferenceUseCaseImpl.initHive(),
    getIt<RemoteConfigStorage>().init().then((value) => getIt<RemoteConfigStorage>().fetch()),
    getIt<MetricsUseCase>().init(MetricsUseCase.apiKey),
  ]);

  ///For WEB --> MissingPluginException(No implementation found for method init on channel tinkoff_id_flutter)
  if (!PlatformWrap.isWeb) {
    await Future.wait([
      getIt<InitTinkoffSDKUseCase>().init(),
    ]);
  }

  await initializeDateFormatting('ru_RU');
  await setPlatformInfo();
}

Future<void> setPlatformInfo() async {
  final data = <String, dynamic>{};
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  data['App-version'] = packageInfo.version;

  /// определяем платформу (ios/android/desctop)
  data['X-User-Platform'] = PlatformWrap.isIOS ? Platform.ios.index : Platform.android.index;

  /// определяем ресурс (еври, дельта, альфа и тд)
  data['X-User-Source'] = currentBuild.header;

  getIt<Dio>().options.headers.addAll(data);
}

enum Platform {
  android,
  ios,
  desktop,
}
