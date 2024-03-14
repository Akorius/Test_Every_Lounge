import 'package:everylounge/domain/data/storages/orders.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrdersStorageImpl implements OrdersStorage {
  static const String boxName = 'orders';

  static Future initHive() {
    return Hive.openBox(boxName);
  }

  @override
  List<Order>? get orders {
    final List? list = _hiveBox.get(_Keys.orders.name);
    if (list == null) return null;
    return list.map<Order>((e) {
      return Order.fromJson(e);
    }).toList();
  }

  @override
  set orders(List<Order>? value) {
    _hiveBox.put(_Keys.orders.name, value?.map((e) => e.toJson()).toList());
  }

  final _hiveBox = Hive.box(boxName);
}

enum _Keys { orders }
