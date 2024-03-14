import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/change_email.dart';
import 'package:everylounge/domain/usecases/user/log_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class NeedSetEmailCubit extends Cubit<NeedSetEmailState> {
  final ChangeEmailUseCase _changeEmailUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  NeedSetEmailCubit() : super(NeedSetEmailState());

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  final TextEditingController emailController = TextEditingController();
  final LogOutUserUseCase _logOutUserUseCase = getIt();

  onEmailChanged(String email) {
    state.email = email;
    final newError = TextValidators.email(email);
    if (state.emailError != newError) {
      emit(state.copyWith(emailError: newError));
    }
  }

  onClearEmail() {
    emailController.clear();
    onEmailChanged(emailController.text);
  }

  onEmailContinuePressed() async {
    if (state.emailLoading) return;
    if (state.email.isEmpty) {
      final error = TextValidators.email(state.email);
      emit(state.copyWith(emailError: error));
      return;
    }
    if (state.emailError != null) return;
    emit(state.copyWith(canPress: false, emailLoading: true));
    final result = await _changeEmailUseCase.requestEmailChange(email: state.email);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    } else {
      _messageController.add(NeedSetEmailState.navigateToCodeSend);
    }
    emit(state.copyWith(canPress: true, emailLoading: false));
  }

  void logOut() async {
    emit(state.copyWith(canPress: false, emailLoading: true));
    final logOutResult = await _logOutUserUseCase.logOut();
    if (logOutResult.isSuccess) {
      _messageController.add(NeedSetEmailState.logout);
    } else {
      _messageController.add(logOutResult.message);
      _metricsUseCase.sendEvent(error: logOutResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(canPress: true, emailLoading: false));
  }

  @override
  Future<void> close() {
    _messageController.close();
    emailController.dispose();
    return super.close();
  }
}
