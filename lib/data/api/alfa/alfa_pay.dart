import 'package:dio/dio.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_pay.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:everylounge/domain/entities/payment/alfa_init_result.dart';

class AlfaPayApiImpl implements AlfaPayApi {
  final Dio _client = getIt();
  final DeveloperModeStorage _developerModeStorage = getIt();

  @override
  Future<AlfaInitResult> createUri({required int orderId}) async {
    var data = {
      'order_id': orderId,
      'redirect_success': successUrl,
      'redirect_fail': failUrl,
    };
    if (_developerModeStorage.payWithOneRuble) {
      data['amount'] = 100;
    }
    final response = await _client.post(
      'orders/alfapay',
      data: data,
    );
    return AlfaInitResult.fromJson(response.data["data"]);
  }
}
