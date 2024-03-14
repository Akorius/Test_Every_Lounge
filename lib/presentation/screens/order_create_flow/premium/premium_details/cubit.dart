import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/domain/usecases/lounge/check_aa_health.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class PremiumDetailsCubit extends Cubit<PremiumDetailsState> {
  final GetUserUseCase _getUserUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final CheckAAHealthUseCase _checkAAHealthUseCase = getIt();
  final AttachCardCubit attachCardCubit = getIt();
  late final StreamSubscription<User> _userStreamSubscription;
  late final StreamSubscription<List<BankCard>> _cardsStreamSubscription;
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  PremiumDetailsCubit({
    required PremiumService premiumService,
    required InnerDestinationType destinationType,
  }) : super(PremiumDetailsState(service: premiumService, destinationType: destinationType)) {
    attachCardCubit.listen(
      (event) => emit(state.copyWith(canPressAttach: !event.cardAttaching)),
      _messageController.add,
    );
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  _onCreate() async {
    _userStreamSubscription = _getUserUseCase.stream.listen((user) {
      emit(state.copyWith(
        isAuth: user.authType != AuthType.anon,
      ));
    });
    _cardsStreamSubscription = _getCardsUseCase.stream.listen((cards) {
      emit(state.copyWith(
        isLoading: false,
        activeBankCard: () => cards.firstWhereOrNull((element) => element.isActive),
      ));
    });
  }

  changeTitleOpacity(double opacity) {
    emit(state.copyWith(titleOpacity: opacity));
  }

  onMakePassButtonPressed() async {
    emit(state.copyWith(isLoading: true));
    final result = await _checkAAHealthUseCase.check(state.service.internalId);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    } else {
      if (!result.value) {
        _messageController.add(eventName[serviceTempUnavailable]!);
        _metricsUseCase.sendEvent(error: eventName[serviceTempUnavailable]!, type: MetricsEventType.alert);
      } else {
        _messageController.add(PremiumDetailsState.navigateToCreateOrder);
      }
    }
    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> close() {
    return Future.wait([
      _userStreamSubscription.cancel(),
      _cardsStreamSubscription.cancel(),
      _messageController.close(),
      attachCardCubit.unListen(),
    ]).then(
      (value) => super.close(),
    );
  }
}
