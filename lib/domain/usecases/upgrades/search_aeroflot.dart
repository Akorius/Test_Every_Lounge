import 'dart:async';

import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/upgrades.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';

abstract class SearchTicketUseCase {
  Future<Result<SearchedBooking>> search(String prn, String lastName);
}

class SearchTicketUseCaseImpl implements SearchTicketUseCase {
  final UpgradesApi _upgradesApi = getIt();
  final MetricsUseCase _metrics = getIt();

  @override
  Future<Result<SearchedBooking>> search(String prn, String lastName) async {
    try {
      var search = await _upgradesApi.searchAeroflot(prn, lastName);
      _metrics.sendEvent(event: eventName[updateFound]!, type: MetricsEventType.message);
      return Result.success(search);
    } on DioError catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure(getMessage(e));
    } catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure(errBookingNotFound);
    }
  }

  String getMessage(DioError e) {
    switch (e.response?.data['text']) {
      case errUnknown:
        {
          return "Что-то пошло не так";
        }
      case errBookingInvalidCharacter:
        {
          return errBookingNotFound;
        }
      case errClassUpgradeDisallow:
        {
          return errClassUpgradeDisallow;
        }
      default:
        return e.response?.data['text'] ?? errBookingNotFound;
    }
  }
}
