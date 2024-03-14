import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/feedback/faq.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/feedback/feedback.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackUseCase _feedBackUseCase = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<User> _userSubscription;

  FeedbackCubit() : super(const FeedbackState()) {
    _getUser();
    _getFaq();
  }

  void _getFaq() async {
    emit(state.copyWith(isLoading: true));
    List<bool> tempButtons = [];
    final result = await _feedBackUseCase.getFaq();
    if (result.isSuccess) {
      for (int i = 0; i < result.value.length; i++) {
        tempButtons.add(false);
      }
      emit(state.copyWith(buttons: tempButtons, isLoading: false, faq: result.value));
    } else {
      emit(state.copyWith(isLoading: true));
    }
  }

  void _getUser() async {
    _userSubscription = _getUserUseCase.stream.listen((user) {
      emit(
        state.copyWith(
          isLoading: false,
          user: user,
        ),
      );
    });
  }

  onAnswerTaped(int index) {
    emit(state.copyWith(isLoading: true));
    List<bool> temp = state.buttons;

    for (int i = 0; i < state.buttons.length; i++) {
      if (index == i) {
        temp[i] = !temp[i];
      } else {
        temp[i] = false;
      }
    }
    emit(state.copyWith(buttons: temp, isLoading: false));
  }

  void checkFiledData({String? name, String? email, String? text}) async {
    if (name != null && email != null && text != null && name != '' && email != '' && text != '') {
      emit(state.copyWith(isLoading: false, canPress: true));
    } else {
      emit(state.copyWith(isLoading: false, canPress: false));
    }
  }

  Future<bool> postFeedback({
    required String name,
    required String email,
    required String text,
  }) async {
    _metricsUseCase.sendEvent(event: eventName[sendFeedback]!, type: MetricsEventType.message);
    emit(state.copyWith(isLoading: true));
    final newError = TextValidators.email(email);
    if (state.emailError != newError) {
      emit(state.copyWith(emailError: newError, isLoading: false));
      return false;
    } else {
      final result = await _feedBackUseCase.postFeedBack(
        name: name,
        email: email,
        text: text,
      );
      emit(state.copyWith(isLoading: false));
      return result.isSuccess;
    }
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    return super.close();
  }
}
