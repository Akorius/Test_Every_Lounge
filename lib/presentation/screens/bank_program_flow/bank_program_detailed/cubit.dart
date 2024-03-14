import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/privileges/remove_card.dart';
import 'package:everylounge/domain/usecases/privileges/remove_passage.dart';
import 'package:everylounge/domain/usecases/privileges/set_active.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class BankProgramDetailedCubit extends Cubit<BankProgramDetailedState> {
  final SetActiveCardUseCase _setActiveCardUseCase = getIt();
  final RemoveCardUseCase _removeCardUseCaseImpl = getIt();
  final RemovePassageUseCase _removePassageUseCaseImpl = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();
  late final StreamSubscription<List<BankCard>> _cardsStreamSubscription;

  BankProgramDetailedCubit({required BankCard bankCard})
      : super(BankProgramDetailedState(
          bankCard: bankCard,
        )) {
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  void _onCreate() async {
    _cardsStreamSubscription = _getCardsUseCase.stream.listen((cards) {
      emit(state.copyWith(
        bankCard: cards.firstWhere(
          (element) => element.sdkId == state.bankCard.sdkId,
          orElse: () => state.bankCard, // чтобы при удалении не было ошибки
        ),
        loading: false,
      ));
    });
  }

  removeCard() async {
    emit(state.copyWith(loading: true));
    final result = await _removeCardUseCaseImpl.call(sdkCardId: int.parse(state.bankCard.sdkId));
    if (result.isSuccess) {
      await updateCards();
      _metricsUseCase.sendEvent(event: eventName[removeCardSuccess]!, type: MetricsEventType.message);
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(loading: false));
  }

  Future<void> updateCards() async {
    var result = await _getCardsUseCase.get();
    if (result.isSuccess) {
      var activeCards = result.value.firstWhereOrNull((element) => element.isActive == true);
      if (activeCards == null && result.value.isNotEmpty) {
        var card = result.value.first;
        var type = card.type;
        if (type == BankCardType.alfaClub) {
          type = card.fake ?? false ? BankCardType.alfaClub : BankCardType.other;
        }
        await _setActiveCardUseCase.set(cardType: type, sdkId: card.sdkId);
        await _getCardsUseCase.get();
      }
      _messageController.add(BankProgramDetailedState.successRemoveBankCardEvent);
    }
  }

  removePassage() async {
    emit(state.copyWith(loading: true));
    final result = await _removePassageUseCaseImpl.call(id: state.bankCard.id);
    if (result.isSuccess) {
      await updateCards();
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(loading: false));
  }

  void setActiveCard() async {
    emit(state.copyWith(loading: true));
    final result = await _setActiveCardUseCase.set(cardType: state.bankCard.type, sdkId: state.bankCard.sdkId);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
      emit(state.copyWith(loading: false));
    } else {
      await _getCardsUseCase.get();
    }
  }

  @override
  Future<void> close() {
    return Future.wait([
      _messageController.close(),
      _cardsStreamSubscription.cancel(),
    ]).then((value) => super.close());
  }
}
