import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/find_out_partner_org.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/order/share_order.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/common/cubit/payment/cubit.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetUserOrdersUseCase _orderUseCase = getIt();
  final ShareOrderUseCase _sharedUseCase = getIt();
  final FindOutPartnerOrgUseCase _findOutPartnerOrgUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<List<Order>> _orderSubscription;

  final PayOrderCubit payOrderCubit = getIt();
  final AttachCardCubit attachCardCubit = getIt();
  PassageManager? _passageManager = getIt();

  OrderDetailsCubit({
    required Order order,
  }) : super(OrderDetailsState(order: order)) {
    _onCreate(order);
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  _onCreate(Order order) async {
    payOrderCubit.listen(
      (event) => emit(state.copyWith(
          payInProgress: event.loading,
          isPayByCardLoading: event.isPayByCardLoading,
          webViewPaymentUri: () => event.webViewPaymentUri,
          order: event.order ?? state.order)),
      _messageController.add,
    );
    attachCardCubit.listen(
      (event) => emit(state.copyWith(attachingCard: event.cardAttaching)),
      _messageController.add,
    );
    _orderSubscription = _orderUseCase.stream.listen((orders) {
      final newOrder = orders.firstWhereOrNull((element) => element.id == order.id);
      if (newOrder != null) {
        emit(state.copyWith(
          order: newOrder,
        ));
      }
    });

    final cardResult = await _getCardsUseCase.active(notFake: false);
    final activeCard = cardResult.isSuccess ? cardResult.value : null;

    if (order.type == OrderType.lounge) {
      _passageManager = getIt(param1: activeCard);
      _passageManager?.passengersCount = order.passengers.length;
      await _passageManager?.checkPassage(order.lounge);
    }

    refreshOrder();

    emit(state.copyWith(cardsLoading: false, activeCard: () => activeCard));
  }

  ///переключает на онлайн оплату
  bool get isPassageOver => _passageManager?.isPassageOver ?? false;

  bool get isPassLimitEnable => _passageManager?.isPassLimitEnable(isFullPassengersCount: true) ?? false;

  ///можно оплатить если это оплата деньгами или привязка карты
  ///если альфа или тинькоф то -> безлимит и лимиты не достигнуты
  ///если обычные то -> проходов >= пасажиров в заказе
  bool canPress() {
    var activeCard = state.activeCard;
    return (activeCard == null || activeCard.cardForPaymentByPasses == false || isPassageOver) ||
        (activeCard.cardForPaymentByPasses == true && !isPassLimitEnable);
  }

  String getPNR() {
    return needMaskPnr() ? state.order.pnr.replaceRange(3, state.order.pnr.length, '******') : state.order.pnr;
  }

  bool needMaskPnr() => state.order.maskPNR(isPartnerOrg: isPartnerOrg) || state.order.status.needMaskedPnr();

  bool get isPartnerOrg => isLoungeMe || isDragonPass || isAirportOrgs;

  bool get isDragonPass => _findOutPartnerOrgUseCase.isDragonPass(state.order.lounge.organization);

  bool get isAirportOrgs =>
      _findOutPartnerOrgUseCase.isAirportOrgs(state.order.lounge.organization) && state.order.pnr.length <= 20;

  bool get isLoungeMe => _findOutPartnerOrgUseCase.isLoungeMe(state.order.lounge.organization);

  bool get needLoadQrForLoungeMe => _findOutHideParamsUseCase.needLoadQRForLoungeMe();

  @override
  Future<void> close() async {
    await Future.wait([
      _orderSubscription.cancel(),
      payOrderCubit.unListen(),
      attachCardCubit.unListen(),
      _messageController.close(),
    ]);
    return super.close();
  }

  Future<void> shareFile(Widget widget, BuildContext context) async {
    _metricsUseCase.sendEvent(event: eventName[shareButtonClick]!, type: MetricsEventType.click);

    emit(state.copyWith(isSharing: true));
    final shareResult = await _sharedUseCase.call(widget, context);
    if (!shareResult.isSuccess) {
      _messageController.add(shareResult.message);
    }
    emit(state.copyWith(isSharing: false));
  }

  Future<void> refreshOrder() async {
    _orderUseCase.getOrder(orderId: state.order.id.toString());
  }

  sendEventError(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.alert);
  }
}
