import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/attach_card.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

///Данный кубит можно только присоединять к другим кубитам
class AttachCardCubit extends Cubit<AttachCardState> {
  final AttachCardUseCase _attachCardUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();
  late final StreamSubscription<AttachCardState> _attachCardCubitSubscription;
  late final StreamSubscription<String> _attachCardCubitMessageSubscription;

  AttachCardCubit() : super(const AttachCardState());

  listen(Function(AttachCardState event) onState, Function(String message) onMessage) {
    _attachCardCubitSubscription = stream.listen(onState);
    _attachCardCubitMessageSubscription = messageStream.listen(onMessage);
  }

  Future unListen() {
    return Future.wait([
      _attachCardCubitSubscription.cancel(),
      _attachCardCubitMessageSubscription.cancel(),
      _messageController.close(),
      close(),
    ]);
  }

  void openAttachCardScreen({Function? cardAttachedCallback}) async {
    if (state.cardAttaching) return;
    emit(state.copyWith(cardAttaching: true));
    final attachResult = await _attachCardUseCase.attach();
    if (attachResult.isSuccess) {
      await _getCardsUseCase.get();
      emit(state.copyWith(attachedCard: () => attachResult.value));
      _messageController.add(AttachCardState.successAddBankCardEvent);
      _metricsUseCase.sendEvent(event: eventName[addPaymentBackCardClick]!, type: MetricsEventType.click);
      cardAttachedCallback?.call();
    } else {
      _messageController.add(attachResult.message);
    }
    emit(state.copyWith(cardAttaching: false));
  }
}
