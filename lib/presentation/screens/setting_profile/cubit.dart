import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/setting_profile/get_developer_mode.dart';
import 'package:everylounge/domain/usecases/settings/settings.dart';
import 'package:everylounge/domain/usecases/user/change_email.dart';
import 'package:everylounge/domain/usecases/user/delete_user.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/log_out.dart';
import 'package:everylounge/domain/usecases/user/update_user.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final DeleteUserUseCase _orderUseCase = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final ChangeEmailUseCase _changeEmailUseCase = getIt();
  final UpdateUserUseCase _updateUserUseCase = getIt();
  final LogOutUserUseCase _logOutUserUseCase = getIt();
  final GetDeveloperModeUseCase _getDeveloperModeUseCase = getIt();
  final SettingsUseCase _settingsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<User> _userStreamSubscription;

  ProfileSettingsCubit() : super(ProfileSettingsState()) {
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  late final List _termsOfUser;

  void _onCreate() async {
    var settings = await _settingsUseCase.getSettings();

    _termsOfUser = [
      '${settings.value.actualRulesId ?? ''}/rules.pdf',
      // '${settings.value.actualPolicyId ?? ''}/policy.pdf',
      '${settings.value.actualOfferId ?? ''}/offer.pdf',
    ];

    _userStreamSubscription = _getUserUseCase.stream.listen((user) {
      emit(state.copyWith(
        isLoading: false,
        user: user,
        isDeveloper: _getDeveloperModeUseCase.enabled(),
        isRuble: _getDeveloperModeUseCase.payWithOneRuble(),
      ));
    });
  }

  String getLink(int index) {
    return '${ApiClient.filesUrl}${_termsOfUser[index]}';
  }

  void chooseReason({required String? reason}) async {
    emit(state.copyWith(isLoading: false, reasonValue: reason));
  }

  void toConfirmScreen({required bool? isConfirm}) async {
    deleteUser(email: state.user!.email);
    emit(state.copyWith(isLoading: false, isConfirm: isConfirm));
  }

  Future<bool> toggleDeveloperMode(String password) async {
    if (password == '12345qwerty') {
      emit(state.copyWith(
        isLoading: false,
        isDeveloper: _getDeveloperModeUseCase.toggleDeveloperMode(),
        passwordError: null,
      ));
      return true;
    } else {
      emit(state.copyWith(isLoading: false, passwordError: 'Неверный пароль'));
      return false;
    }
  }

  void togglePayWithOneRuble() async {
    emit(state.copyWith(
      isLoading: false,
      isRuble: _getDeveloperModeUseCase.togglePayWithOneRuble(),
    ));
  }

  void changeEmail({required String? email}) async {
    emit(state.copyWith(isLoading: true));
    final newError = TextValidators.email(email!);
    if (state.emailError != newError) {
      emit(state.copyWith(emailError: newError, isLoading: false));
      _getUserUseCase.get();
    }
    final changeResult = await _changeEmailUseCase.requestEmailChange(email: email);
    if (changeResult.isSuccess) {
      _getUserUseCase.get();
    }
    emit(state.copyWith(isLoading: false));
  }

  void updateUser({String? firstName, String? lastName, String? phone}) async {
    emit(state.copyWith(isLoading: true));
    final updateResult = await _updateUserUseCase.update(firstName: firstName, lastName: lastName, phone: phone);
    if (updateResult.isSuccess) {
      /// обновление для стрима
      _getUserUseCase.get();
    } else {
      emit(state.copyWith(isLoading: false));
      _messageController.add(updateResult.message);
      _metricsUseCase.sendEvent(error: updateResult.message, type: MetricsEventType.alert);
    }
  }

  void logOut() async {
    emit(state.copyWith(isLoading: true));
    final logOutResult = await _logOutUserUseCase.logOut();
    if (logOutResult.isSuccess) {
      _messageController.add(ProfileSettingsState.logoutEvent);
    } else {
      _messageController.add(logOutResult.message);
      _metricsUseCase.sendEvent(error: logOutResult.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  void deleteUser({required String? email, String? code}) async {
    emit(state.copyWith(isLoading: true));
    final deleteResult = await _orderUseCase.deleteUser(email: email, code: code);
    if (deleteResult.isSuccess && code?.isNotEmpty == true) {
      _messageController.add(ProfileSettingsState.successRemoveAccount);
    } else if (!deleteResult.isSuccess) {
      _messageController.add(deleteResult.message);
      _metricsUseCase.sendEvent(event: deleteResult.message, type: MetricsEventType.alert);
    }
    emit(
      state.copyWith(isLoading: false),
    );
  }

  Future<void> requestPermission(context) async {
    // const Permission locationPermission = Permission.location;
    // bool locationStatus = false;
    // bool isPermanentlyDenied = await locationPermission.isPermanentlyDenied;
    // if (isPermanentlyDenied) {
    await openAppSettings();
    // } else {
    //   final locationStat = await locationPermission.request();
    //   locationStatus = locationStat.isGranted;
    // }
  }

  @override
  Future<void> close() {
    return Future.wait([
      _messageController.close(),
      _userStreamSubscription.cancel(),
    ]).then((value) => super.close());
  }
}
