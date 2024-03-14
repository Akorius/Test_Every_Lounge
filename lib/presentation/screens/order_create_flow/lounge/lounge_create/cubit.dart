import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/contacts.dart';
import 'package:everylounge/domain/entities/order/create_order_object.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/passengers.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/lounge/check_aa_health.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/create_order.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_pass.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/translit.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/common/cubit/payment/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/state.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoungeCubit extends Cubit<LoungeState> {
  final GetUserUseCase getUserUseCase;
  final GetCardsUseCase getCardsUseCase;
  final CheckAAHealthUseCase checkAAHealthUseCase;
  final AttachCardCubit? attachCardCubit;
  final FindOutHideParamsUseCase findOutHideParamsUseCase;
  final TranslitUseCase translitUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final PayWithPassUseCase payWithPassUseCase;
  final GetUserOrdersUseCase orderUseCase;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final PayOrderCubit? payOrderCubit;
  final PassageManager? passageManager;
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<User> _userStreamSubscription;

  var _isFirstAttention = true;

  LoungeCubit({
    required Lounge lounge,
    required BankCard? activeCard,
    required this.getUserUseCase,
    required this.getCardsUseCase,
    required this.checkAAHealthUseCase,
    required this.attachCardCubit,
    required this.findOutHideParamsUseCase,
    required this.translitUseCase,
    required this.createOrderUseCase,
    required this.orderUseCase,
    required this.payWithPassUseCase,
    required this.payOrderCubit,
    required this.passageManager,
  }) : super(
          LoungeState(
              lounge: lounge,
              activeBankCard: activeCard,
              passenger: Passengers(firstName: "", lastName: ""),
              nameError: null,
              lastNameError: null,
              price: lounge.cost),
        ) {
    payOrderCubit?.listen(
      (event) => {
        emit(
          state.copyWith(
              isLoading: event.loading,
              webViewPaymentUri: event.webViewPaymentUri,
              createdOrder: event.order ?? state.createdOrder),
        ),
      },
      _messageController.add,
    );
    attachCardCubit?.listen(
      (event) => emit(state.copyWith(isLoading: event.cardAttaching)),
      _messageController.add,
    );
    _userStreamSubscription = getUserUseCase.stream.listen((user) {
      emit(state.copyWith(
        isAuth: user.authType != AuthType.anon,
      ));
    });
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  _onCreate() async {
    await passageManager?.checkPassage(state.lounge);

    ///Получаем карты, получем пользователя, выясняем транслитировать ли пассажиров,транслитируем
    final user = await getUserUseCase.stream.first;
    final needTranslitName = translitUseCase.findOut(state.lounge.airport.countryCode, state.lounge.organization);
    var firstNamePassage = user.activePassage?.firstName;
    var lastNamePassage = user.activePassage?.lastName;
    var activeBank = user.activeBank;
    var firstName = getName(needTranslitName, activeBank, firstNamePassage, user.profile.firstName);
    var lastName = getName(needTranslitName, activeBank, lastNamePassage, user.profile.lastName);

    if (!isClosed) {
      emit(
        state.copyWith(
          isTranslitNames: needTranslitName,
          cardsLoading: false,
          isLoading: false,
          canChangeName: !(firstNamePassage?.isNotEmpty == true && activeBank == ActiveBank.alfa),
          passenger: Passengers(
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      );
      checkNamePassenger(firstName, lastName);
    }
    _checkAAHealth();
    _checkShowAttention(isLaunchScreen: true);
  }

  String getName(bool needTranslitName, ActiveBank? bank, String? namePassage, String? nameProfile) {
    if (namePassage?.isNotEmpty == true && bank == ActiveBank.alfa) {
      return (needTranslitName ? translitUseCase.translit(namePassage ?? '').toUpperCase() : namePassage) ?? '';
    } else {
      return (needTranslitName ? translitUseCase.translit(nameProfile ?? '').toUpperCase() : nameProfile) ?? '';
    }
  }

  onCardAttached() async {
    final result = await getCardsUseCase.active(notFake: false);
    emit(state.copyWith(
      activeBankCard: () => result.isSuccess ? result.value : null,
    ));
  }

  checkNamePassenger(String firstName, String lastName) {
    onPassengerNameChanged(firstName);
    onPassengerLastNameChanged(lastName);
  }

  void clearName() {
    nameController.clear();
    onPassengerNameChanged(nameController.text);
  }

  void clearLastName() {
    lastNameController.clear();
    onPassengerLastNameChanged(lastNameController.text);
  }

  int get maxPassengers => passageManager?.maxPassengers ?? 7;

  bool get isPassageOver => passageManager?.isPassageOver ?? false;

  bool get isPassLimitEnable => passageManager?.isPassLimitEnable() ?? false;

  bool get needDisableAdditionPassengers => passageManager?.needDisableAdditionPassengers ?? false;

  bool get passesMoreThenPassengers => passageManager?.passesMoreThenPassengers ?? false;

  bool get isFirstAttention => _isFirstAttention;

  bool get isRichedMaxGuests => passageManager?.isRichedMaxGuests ?? false;

  bool get canPress {
    final noErrorsInNames = state.nameError == null || state.nameError!.isEmpty;
    final noErrorsInLastNames = state.lastNameError == null || state.lastNameError!.isEmpty;
    final passengerIsFilled = state.passenger.firstName.isNotEmpty || state.passenger.lastName.isNotEmpty;
    return noErrorsInNames &&
        noErrorsInLastNames &&
        passengerIsFilled &&
        state.isLoading == false &&
        state.isPayByCardLoading == false &&

        ///если активной карты нет - разрешаем онлайн оплату
        ///если проходы по лимиту закончились - переключаем на онлайн оплату
        ///и не блокируем кнопку оплаты
        ((state.activeBankCard != null) ? (isPassageOver ? true : passesMoreThenPassengers) : true);
  }

  onPassengerNameChanged(String firstName) {
    state.passenger.firstName = firstName;
    final newError = TextValidators.name(firstName);
    if (state.nameError != newError) {
      emit(state.copyWith(nameError: () => newError));
    }
  }

  onPassengerLastNameChanged(String lastName) {
    state.passenger.lastName = lastName;
    final newError = TextValidators.name(lastName);
    if (state.lastNameError != newError) {
      emit(state.copyWith(lastNameError: () => newError));
    }
  }

  _checkAAHealth() async {
    final result = await checkAAHealthUseCase.check(state.lounge.internalId);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    } else {
      if (!result.value) {
        _messageController.add("Бронирование зала временно  недоступно. Попробуйте позднее.");
        _metricsUseCase.sendEvent(
            error: "Бронирование зала временно  недоступно. Попробуйте позднее.", type: MetricsEventType.alert);
      }
    }
  }

  onTinkoffPayPressed() async {
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit?.onTinkoffPayPressed(createResult.value);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onAlfaPayPressed() async {
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit?.onAlfaPayPressed(createResult.value);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onPayWithCardPressed() async {
    if (state.isPayByCardLoading) return;
    emit(state.copyWith(isPayByCardLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit?.onPayWithCardPressed(createResult.value);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isPayByCardLoading: false));
  }

  onRecurrentPayPressed() async {
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit?.onRecurrentPayPressed(createResult.value);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onUsePassPressed() async {
    emit(state.copyWith(isLoading: true));
    final createResult = await _createOrderObject();
    if (createResult.isSuccess) {
      await payOrderCubit?.onUsePassPressed(createResult.value, isTinkoff: state.activeBankCard?.availableTinkoffPasses == true);
    } else {
      _messageController.add(createResult.message);
      _metricsUseCase.sendEvent(error: createResult.message, type: MetricsEventType.alert);
    }
  }

  Future<Result<Order>> _createOrderObject() async {
    var listPassengers = <Passengers>[];
    listPassengers.add(state.passenger);
    for (var i = 1; i < state.passengersCount; i++) {
      listPassengers.add(Passengers(firstName: '', lastName: ''));
    }

    final result = await createOrderUseCase.createLounge(
      CreateOrderObject(
        loungeId: state.lounge.id,
        contacts: Contacts(
          name: "${state.passenger.firstName} ${state.passenger.lastName}",
        ),
        passengers: listPassengers,
      ),
    );

    if (result.isSuccess) {
      emit(state.copyWith(createdOrder: result.value));
    }
    return result;
  }

  increasePassengers() {
    var newCount = state.passengersCount + 1;
    passageManager?.passengersCount = newCount;
    emit(state.copyWith(passengersCount: newCount));
    _checkShowAttention();
  }

  void _checkShowAttention({bool isLaunchScreen = false}) {
    if (((passageManager?.needShowAttention == true) && !isPassageOver) ||
        //TODO вынести логику в менеджер, особенно activeCard?.type != BankCardType.tinkoffPremium
        (isLaunchScreen && isPassageOver && state.activeBankCard?.type != BankCardType.tinkoffPremium)) {
      if (!isLaunchScreen) {
        _isFirstAttention = false;
      }
      emit(state.copyWith(needShowAttention: true));
    }
  }

  decreasePassengers() {
    var newCount = state.passengersCount - 1;
    passageManager?.passengersCount = newCount;
    emit(state.copyWith(passengersCount: newCount));
  }

  hideAttention() {
    _isFirstAttention = false;
    emit(state.copyWith(needShowAttention: false));
  }

  changeTitleOpacity(double opacity) {
    emit(state.copyWith(titleOpacity: opacity));
  }

  sendEventSuccess(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.message);
  }

  @override
  Future<void> close() {
    return Future.wait([
      _userStreamSubscription.cancel(),
      _messageController.close(),
      attachCardCubit?.unListen() ?? Future(() => null),
      payOrderCubit?.unListen() ?? Future(() => null),
    ]).then(
      (value) => super.close(),
    );
  }
}
