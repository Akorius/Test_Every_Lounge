import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/entities/upgrade_flight/upgrade.dart';

abstract class UpgradesApi {
  Future<SearchedBooking> searchAeroflot(String pnr, String lastName);

  Future<Order> upgradeAeroflot(CreateUpgradeOrderObject body);
}
