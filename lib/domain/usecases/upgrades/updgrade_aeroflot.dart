import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/upgrades.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/upgrade.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';

abstract class UpgradeAeroflotUseCase {
  Future<Result<Order>> upgrade(CreateUpgradeOrderObject body);
}

class UpgradeAeroflotUseCaseImpl implements UpgradeAeroflotUseCase {
  final UpgradesApi _upgradesApi = getIt();
  final MetricsUseCase _metrics = getIt();
  final GetUserOrdersUseCase _getUserOrdersUseCase = getIt();

  @override
  Future<Result<Order>> upgrade(CreateUpgradeOrderObject body) async {
    try {
      var order = await _upgradesApi.upgradeAeroflot(body);
      _getUserOrdersUseCase.addOrderToStream(order);
      _metrics.sendEvent(event: eventName[updatePossible]!, type: MetricsEventType.message);
      return Result.success(order);
    } catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure("Не удалось повысить класс перелёта");
    }
  }
}
