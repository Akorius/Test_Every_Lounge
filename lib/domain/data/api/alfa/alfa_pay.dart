import 'package:everylounge/domain/entities/payment/alfa_init_result.dart';

abstract class AlfaPayApi {
  Future<AlfaInitResult> createUri({required int orderId});
}
