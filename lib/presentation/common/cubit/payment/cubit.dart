import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_alfa_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_pass.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_recurrent_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_tinkoff_pay.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_tinkoff_web_view.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'state.dart';

///Данный кубит можно использовать только в другом кубите
class PayOrderCubit extends Cubit<PayOrderState> {
  final PayRecurrentPaymentUseCase _payRecurrentPaymentUseCase = getIt();
  final PayWithTinkoffPayUseCase _payWithTinkoffPayUseCase = getIt();
  final PayWithAlfaPayUseCase _payWithAlfaPayUseCase = getIt();
  final PayWithTinkoffWebView _payWithTinkoffWebView = getIt();
  final PayWithPassUseCase _payWithPassUseCase = getIt();
  late final StreamSubscription<PayOrderState> _payOrderCubitSubscription;
  late final StreamSubscription<String> _payOrderCubitMessageSubscription;

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  PayOrderCubit() : super(const PayOrderState());

  listen(Function(PayOrderState event) onState, Function(String message) onMessage) {
    _payOrderCubitSubscription = stream.listen(onState);
    _payOrderCubitMessageSubscription = messageStream.listen(onMessage);
  }

  Future unListen() {
    return Future.wait([
      _payOrderCubitSubscription.cancel(),
      _payOrderCubitMessageSubscription.cancel(),
      _messageController.close(),
      close(),
    ]);
  }

  onTinkoffPayPressed(Order order) async {
    emit(state.copyWith(loading: true));
    final tinkoffPayResult = await _payWithTinkoffPayUseCase.pay(PaymentObject.fromOrder(order));
    _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
    if (!tinkoffPayResult.isSuccess) {
      _messageController.add(tinkoffPayResult.message);
    }
    emit(state.copyWith(loading: false));
  }

  fromBanksAppReturned() async {
    final payResult = await _payWithTinkoffPayUseCase.fromTinkoffBankReturned();
    if (payResult.isSuccess) {
      _navigateWithSuccess();
    } else {
      final payResult = await _payWithAlfaPayUseCase.fromAlfaBankReturned();
      if (payResult.isSuccess) {
        _navigateWithSuccess();
      }
    }
  }

  onAlfaPayPressed(Order order) async {
    emit(state.copyWith(loading: true));
    var result = await _payWithAlfaPayUseCase.pay(PaymentObject.fromOrder(order));
    _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
    if (!result.isSuccess) {
      _messageController.add(result.message);
    }
    emit(state.copyWith(loading: false));
  }

  onPayWithCardPressed(Order order) async {
    emit(state.copyWith(isPayByCardLoading: true));
    final result = await _payWithTinkoffWebView.createUri(PaymentObject.fromOrder(order));
    if (result.isSuccess) {
      emit(state.copyWith(webViewPaymentUri: () => result.value));
      if (!PlatformWrap.isWeb) {
        _messageController.add(PayOrderState.navigateToTinkoffWebView);
      } else {
        _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
        launchUrl(result.value);
      }
    } else {
      _messageController.add(result.message);
    }
    emit(state.copyWith(isPayByCardLoading: false));
  }

  launchWebViewPayment() async {
    launchUrl(state.webViewPaymentUri!);
  }

  onWebViewReturned(bool success) async {
    emit(state.copyWith(loading: true));
    if (success) {
      _payWithTinkoffWebView.processFromWebViewReturnedSuccess();
      _navigateWithSuccess();
    } else {
      _navigateToDetails();
    }
    emit(state.copyWith(loading: false));
  }

  onRecurrentPayPressed(Order order) async {
    emit(state.copyWith(loading: true));
    final recurrentResult = await _payRecurrentPaymentUseCase.pay(PaymentObject.fromOrder(order));
    _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
    if (recurrentResult.isSuccess) {
      _navigateWithSuccess();
    } else {
      _messageController.add(recurrentResult.message);
    }
    emit(state.copyWith(loading: false));
  }

  onUsePassPressed(Order order, {bool isTinkoff = false}) async {
    emit(state.copyWith(loading: true));
    final payResult = await _payWithPassUseCase.pay(PaymentObject.fromOrder(order), isTinkoff: isTinkoff);
    _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
    if (payResult.isSuccess) {
      _navigateWithSuccess();
      emit(
        state.copyWith(
          order: order.copyWith(
            acquiringType: AcquiringType.passages,
            status: OrderStatus.paid,
          ),
        ),
      );
    } else {
      _messageController.add(payResult.message);
    }
    emit(state.copyWith(loading: false));
  }

  _navigateWithSuccess() async {
    _messageController.add(PayOrderState.navigateToSuccess);
  }

  _navigateToDetails() async {
    _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
  }
}
