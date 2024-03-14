import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/screen_description_map.dart';
import 'package:everylounge/domain/data/storages/orders.dart';
import 'package:everylounge/domain/data/storages/user_preference.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_services_use_case.dart';
import 'package:everylounge/domain/usecases/user/change_email.dart';
import 'package:everylounge/domain/usecases/user/check_rate.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/screens/home/state.dart';
import 'package:everylounge/presentation/screens/home/widget/add_card_modal.dart';
import 'package:everylounge/presentation/screens/home/widget/authorize_modal.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/rating/rating_flag.dart';
import 'package:everylounge/presentation/widgets/managers/modal_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetUserOrdersUseCase _orderUseCase = getIt();
  final OrdersStorage _ordersStorage = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  final FindOutHideServicesUseCase _findOutHideServicesUseCase = getIt();
  final ChangeEmailUseCase _changeEmailUseCase = getIt();
  final ModalManager _modalManager = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();
  final ModalManager modalManager = getIt<ModalManager>();
  final CheckRateUseCase _checkRateUseCase = getIt();
  final AttachCardCubit attachCardCubit = getIt();
  final UserPreferenceUseCase _userPreferenceUseCase = getIt();

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<List<BankCard>> _cardsSubscription;
  late final StreamSubscription<List<Order>> _ordersSubscription;
  StreamSubscription<bool>? _checkRateSubscription;

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  HomeCubit() : super(const HomeState()) {
    attachCardCubit.listen(
      (event) => emit(state.copyWith(cardAttaching: event.cardAttaching)),
      _messageController.add,
    );
    _onCreate();
  }

  _onCreate() async {
    emit(state.copyWith(
      hideLounge: production && _findOutHideServicesUseCase.hideLounge,
      hideMeetAndAssist: production && _findOutHideServicesUseCase.hideMeetAndAssist,
      hideBanks: _findOutHideParamsUseCase.modalAddBankCard(),
    ));
    getOrderList();

    _ordersSubscription = _orderUseCase.stream.listen((orders) {
      var activeOrderList = orders
          .where((element) => toShowOrderStatusesInActive.contains(element.status))
          .toList()
          .sorted((a, b) => a.createdAt.compareTo(b.createdAt))
          .reversed
          .toList();
      activeOrderList = activeOrderList.sublist(0, activeOrderList.length > 3 ? 3 : activeOrderList.length);

      emit(state.copyWith(
        activeOrdersList: activeOrderList,
        ordersLoading: _ordersStorage.orders != null ? false : state.ordersLoading,
      ));
    });

    ///Сначала получаем список карт, прежде чем подписываться на карты,
    ///чтобы при новом логине показывалось актуальное предложение привязать карту

    final cardResult = await _getCardsUseCase.get();
    if (!cardResult.isSuccess) {
      _messageController.add(cardResult.message);
      _metricsUseCase.sendEvent(error: cardResult.message, type: MetricsEventType.alert);
    } else {
      // emit(state.copyWith(
      //   activeBankCard: () => cardResult.value.firstWhereOrNull((element) => element.isActive),
      // ));
      // Проверки на вывод модального акна при входе в приложение
      //TODO рефакторить после добавления на бэке

      // _checkSuccessAttachIdUseCase.checkNeedShowSuccessLoginById(
      //   cardResult.value,
      //   () => _messageController.add(
      //     AttachCardState.successAddBankCardEvent,
      //   ),
      // );
    }
    _userSubscription = _getUserUseCase.stream.listen((user) async {
      emit(state.copyWith(user: user, profileLoading: false));
      _metricsUseCase.sendUserId(user.id);
      if (_changeEmailUseCase.needSetEmail()) {
        _messageController.add(HomeState.showNeedSetEmailScreen);
      }
    });
    _cardsSubscription = _getCardsUseCase.stream.listen((cards) async {
      if (cards.isNotEmpty && !state.addCardModalWasShown) {
        ///если уже есть карты не показываем сообщение при удалении всех способов оплаты
        emit(state.copyWith(addCardModalWasShown: true));
      }
      final activeCard = cards.firstWhereOrNull((element) => element.isActive);
      emit(state.copyWith(
        cardsLoading: false,
        activeBankCard: () => activeCard,
        hideUpgrades: hideUpgrades(activeCard),
        isServicesLoading: false,
      ));
      if (state.user?.authType != AuthType.anon) {
        if (!PlatformWrap.isWeb && cards.isEmpty && !state.addCardModalWasShown) {
          _metricsUseCase.sendScreenName(modalSheetNames[showAddCardModalPath]);
          _messageController.add(HomeState.showAddCardModal);
          emit(state.copyWith(addCardModalWasShown: true));
        }
      } else {
        if (!_userPreferenceUseCase.isAlreadyShownUnauthorizedModal) {
          _messageController.add(HomeState.showAuthorizeModal);
          _metricsUseCase.sendScreenName(modalSheetNames[showAuthorizeModalPath]);
          _userPreferenceUseCase.setShowedUnauthorizedModal(isShow: true);
        }
      }
    });
    if (!PlatformWrap.isWeb) {
      _checkRateSubscription = _checkRateUseCase.checkRateStream.listen((showRateModal) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (showRateModal && !_messageController.isClosed) {
            _messageController.add(HomeState.showRateAppModal);
          }
        });
      });
      _checkRateUseCase.checkNeedShowRate();
    }
  }

  bool hideUpgrades(BankCard? activeCard) {
    bool hideUpgrades = production && _findOutHideServicesUseCase.hideUpgrades;
    if (activeCard != null && activeCard.type == BankCardType.alfaPrem && !hideUpgrades) {
      return production && _findOutHideServicesUseCase.hideUpgradesForAlfaPrem;
    } else {
      return hideUpgrades;
    }
  }

  Future<void> getOrderList() async {
    emit(state.copyWith(isOrdersLoadingByRefresh: true));
    await _orderUseCase.get(limit: 3, statuses: toShowOrderStatusesInActive);
    emit(state.copyWith(isOrdersLoadingByRefresh: false));
  }

  onProductsPageChanged(int index) {
    emit(state.copyWith(orderIndex: index));
  }

  sendEvent(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  onUpdateRateFlag({RateFlag? rateFlag}) async {
    await _checkRateUseCase.updateRateFlag(rateFlag);
  }

  void openAddCardModal(BuildContext context) {
    _modalManager.openAddCardModal(context, state.hideBanks);
  }

  void openAuthModal(BuildContext context) {
    _modalManager.openAuthModal(context);
  }

  @override
  Future<void> close() {
    return Future.wait([
      _userSubscription.cancel(),
      _cardsSubscription.cancel(),
      _ordersSubscription.cancel(),
      _checkRateSubscription?.cancel() ?? Future(() => null),
      attachCardCubit.unListen(),
    ]).then(
      (value) => super.close(),
    );
  }
}
