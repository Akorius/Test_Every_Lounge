import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';

abstract class MetricsUseCase {
  static const apiKey = "a239de9f-8f70-4cc9-ab5f-fe69f07110fd";

  Future<void> init(String apiKey);

  void sendEvent({String event, required MetricsEventType type, String? error});

  void sendScreenName(String? title);

  void sendUserId(int userId);
}

class MetricsUseCaseImpl implements MetricsUseCase {
  @override
  Future<void> init(String apiKey) async {
    await AppMetrica.activate(AppMetricaConfig(apiKey));
  }

  @override
  void sendEvent({String event = "", required MetricsEventType type, String? error}) async {
    if (error != null) {
      AppMetrica.reportError(message: error);
    } else {
      AppMetrica.reportEventWithJson(event, '{"type": "${fromEnum(type)}"');
    }
  }

  @override
  void sendScreenName(String? title) {
    AppMetrica.reportEventWithJson(title ?? "", "Screen");
  }

  @override
  void sendUserId(int userId) {
    AppMetrica.setUserProfileID(userId.toString());
  }

  String fromEnum(MetricsEventType type) {
    switch (type) {
      case MetricsEventType.message:
        return 'Message';
      case MetricsEventType.alert:
        return 'Alert';
      case MetricsEventType.click:
        return 'Click';
    }
  }
}
