import 'dart:async';

import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/update.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/version_comparator.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/settings/settings.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/state.dart';
import 'package:everylounge/presentation/widgets/managers/modal_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBottomNavigationCubit extends Cubit<HomeBottomState> {
  final SettingsUseCase _settingsUseCase = getIt();
  final ModalManager modalManager = getIt<ModalManager>();
  final UpdateStorage updateStorage = getIt<UpdateStorage>();
  final GetUserOrdersUseCase _orderUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  StreamSubscription<List<Order>>? orderSubscription;

  var packageInfoVersion = '';

  HomeBottomNavigationCubit() : super(const HomeBottomState()) {
    _getSettings().whenComplete(
      () => !PlatformWrap.isWeb ? _checkForUpdateApp() : emit(state.copyWith(isCheckUpdating: false)),
    );

    orderSubscription = _orderUseCase.stream.listen((orders) {
      orders.removeWhere(
        (element) => element.type == OrderType.upgrade && !toShowUpgradeStatusesInHistory.contains(element.status),
      );
      emit(state.copyWith(orders: orders));
    });
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = BehaviorSubject<String>();

  setIndex(int index) {
    sendEvent(AppRoutes.purchasesScreen);
    emit(
      state.copyWith(
        currentScreen: index,
      ),
    );
  }

  Future<void> _getSettings() async {
    var result = await _settingsUseCase.getSettings();
    emit(state.copyWith(appSettings: () => result.isSuccess ? result.value : null));
  }

  void _checkForUpdateApp() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageInfoVersion = packageInfo.version;

    try {
      if (VersionComparator.isUpdateAvailable(packageInfoVersion, state.appSettings?.actualAppVersion ?? '') == true) {
        final upgrader = Upgrader();
        await upgrader.initialize();
        var needUpdate = upgrader.isUpdateAvailable();

        ///если upgrader не смог прочитать версию
        if (upgrader.currentAppStoreVersion() == null) {
          needUpdate = true;
        }
        if (needUpdate && state.appSettings?.isRequired == true) {
          _messageController.add(HomeBottomState.showUpdateAppScreen);
          await Future.delayed(const Duration(seconds: 1));
        } else if (needUpdate) {
          _messageController.add(HomeBottomState.showUpdateAppModal);
        }
      }
    } finally {
      emit(state.copyWith(isCheckUpdating: false));
    }
  }

  void updateApp() {
    if (PlatformWrap.isIOS) {
      launchUrl(Uri.parse(iosStoreLink));
    } else if (PlatformWrap.isAndroid) {
      launchUrl(Uri.parse(androidStoreLink));
    }
  }

  sendEvent(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  void openUpdateModal(BuildContext context) {
    if (updateStorage.needShowUpdate(packageInfoVersion) == true) {
      updateStorage.addAppVersion(packageInfoVersion);
      modalManager.openUpdateModal(context, updateCallback: () => updateApp());
    }
  }

  @override
  Future<void> close() async {
    await orderSubscription?.cancel();
    return super.close();
  }
}
