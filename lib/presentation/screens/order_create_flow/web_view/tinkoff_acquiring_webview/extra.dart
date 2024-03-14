import 'package:everylounge/domain/entities/bank/card_type.dart';

class AcquiringExtraObject {
  final Uri paymentUrl;
  final Function onPaymentSuccess;
  final Function onPaymentFailure;
  final bool showTinkoffWarning;
  final BankCardType? activeCardType;

  AcquiringExtraObject({
    required this.paymentUrl,
    required this.onPaymentSuccess,
    required this.onPaymentFailure,
    required this.showTinkoffWarning,
    this.activeCardType,
  });
}
