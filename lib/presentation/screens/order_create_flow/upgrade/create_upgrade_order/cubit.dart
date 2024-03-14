import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/passenger.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';
import 'package:everylounge/domain/entities/upgrade_flight/upgrade.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/upgrades/updgrade_aeroflot.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/common/cubit/payment/cubit.dart';
import 'package:everylounge/presentation/common/cubit/payment/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class CreateUpgradeOrderCubit extends Cubit<CreateUpgradeOrderState> {
  final GetUserUseCase _getUserUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final UpgradeAeroflotUseCase _upgradeAeroflotUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<User> _userStreamSubscription;
  late final StreamSubscription<List<BankCard>> _cardsSubscription;

  final PayOrderCubit payOrderCubit = getIt();
  final AttachCardCubit _attachCardCubit = getIt();

  CreateUpgradeOrderCubit({required SearchedBooking searchedBooking})
      : super(CreateUpgradeOrderState(
          searchedBooking: searchedBooking,
          ticketToCardMap: {},
        )) {
    _userStreamSubscription = _getUserUseCase.stream.listen((user) {
      emit(state.copyWith(user: user));
    });
    _cardsSubscription = _getCardsUseCase.stream.listen((cards) async {
      final activeCard = cards.firstWhereOrNull((element) => element.isActive);
      emit(state.copyWith(cardsLoading: false, activeCard: () => activeCard));
    });
    payOrderCubit.listen(
      (event) => emit(state.copyWith(payInProgress: event.loading, webViewPaymentUri: () => event.webViewPaymentUri)),
      _messageController.add,
    );
    _attachCardCubit.listen(
      (event) => emit(state.copyWith(attachingCard: event.cardAttaching)),
      _messageController.add,
    );
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  onPayWithCardPressed() async {
    if (state.isPayByCardLoading) return;
    emit(state.copyWith(isPayByCardLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit.onPayWithCardPressed(createResult.value);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isPayByCardLoading: false));
  }

  onRecurrentPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit.onRecurrentPayPressed(createResult.value);
      _navigateToOrderDetails();
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onAttachCardPressed() async {
    _attachCardCubit.openAttachCardScreen();
  }

  onTinkoffPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit.onTinkoffPayPressed(createResult.value);
      _navigateToOrderDetails();
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onAlfaPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit.onAlfaPayPressed(createResult.value);
      _navigateToOrderDetails();
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  addPassToCard(Segment segment, PassengerFU passenger) {
    if (!state.ticketToCardMap.containsKey(segment)) {
      state.ticketToCardMap[segment] = [passenger];
    } else {
      state.ticketToCardMap.forEach((key, value) {
        if (key == segment) {
          if (value.contains(passenger)) {
            value.remove(passenger);
          } else {
            value.add(passenger);
          }
        }
      });
    }

    var price = 0.0;
    state.ticketToCardMap.forEach((segment, passList) {
      if (passList.isNotEmpty) {
        for (var _ in passList) {
          price += num.tryParse(segment.upgrades?.first?.toBusiness.amount ?? '') ?? 0;
        }
      }
    });

    emit(state.copyWith(currentPrice: price, webViewPaymentUri: null));
    payOrderCubit.emit(payOrderCubit.state.copyWith(webViewPaymentUri: () => null));
  }

  Future<Result<Order>> _createOrderObject() async {
    final List<CreateUpgradeOrderObjectPosition> upgradesRequestList = [];
    state.ticketToCardMap.forEach((key, value) {
      if (value.isNotEmpty) {
        for (var pass in value) {
          upgradesRequestList.add(CreateUpgradeOrderObjectPosition(
              amount: key.upgrades?.first?.toBusiness.amount ?? '',
              segmentNumber: key.segmentNumber,
              refNumber: pass.refNumber,
              rficCode: key.upgrades?.first?.toBusiness.rficCode ?? '',
              rfiscCode: key.upgrades?.first?.toBusiness.rfiscCode ?? ''));
        }
      }
    });
    final upgradeRequest = CreateUpgradeOrderObject(
      pnr: state.searchedBooking.pnrLocator,
      lastName: state.searchedBooking.passengers.first.lastName,
      airport: state.searchedBooking.legs.first.segments.first.origin.airportCode,
      upgrades: upgradesRequestList,
    );
    final result = await _upgradeAeroflotUseCase.upgrade(upgradeRequest);
    if (result.isSuccess) {
      emit(state.copyWith(createdOrder: result.value));
    }
    return result;
  }

  _navigateToOrderDetails() async {
    if (state.createdOrder != null) {
      _messageController.add(PayOrderState.navigateToOrderDetailsScreen);
    }
  }

  @override
  Future<void> close() {
    return Future.wait([
      _userStreamSubscription.cancel(),
      _cardsSubscription.cancel(),
      payOrderCubit.unListen(),
      _attachCardCubit.unListen(),
    ]).then((value) => super.close());
  }
}
