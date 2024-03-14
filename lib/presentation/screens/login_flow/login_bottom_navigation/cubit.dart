import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBottomNavigationCubit extends Cubit<int> {
  LoginBottomNavigationCubit() : super(0);
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  setIndex(int index) {
    if (index == 1) {
      _metricsUseCase.sendEvent(event: AppRoutes.loginInfoScreen, type: MetricsEventType.click);
      _metricsUseCase.sendEvent(event: eventName[infoButtonClick]!, type: MetricsEventType.click);
    }
    emit(index);
  }
}
