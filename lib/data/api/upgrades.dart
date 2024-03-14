import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/upgrades.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/entities/upgrade_flight/upgrade.dart';
import 'package:logger/logger.dart';

class UpgradesApiImpl implements UpgradesApi {
  final Dio _client = getIt();

  @override
  Future<SearchedBooking> searchAeroflot(String pnr, String lastName) async {
    final response = await _client.get(
      "upgrades/aeroflot/search",
      queryParameters: {'pnr': pnr, 'last_name': lastName},
    );
    return SearchedBooking.fromJson(response.data["data"]);
  }

  @override
  Future<Order> upgradeAeroflot(CreateUpgradeOrderObject body) async {
    final response = await _client.post("upgrades/aeroflot/upgrade", data: body.toJson());
    Logger().log(Level.debug, response.data);
    return Order.fromJson(response.data["data"]);
  }
}
