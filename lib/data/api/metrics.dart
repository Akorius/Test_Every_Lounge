import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/metrics.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/metrics/metric_backend_type.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';

class MetricsApiImpl implements MetricsApi {
  final Dio _client = getIt();

  @override
  Future<bool> signInMetric({
    required MetricAuthType authType,
    required MetricStep step,
    required MetricStatus status,
    required String? socialToken,
    required String? error,
    required MetricEmailType? emailType,
  }) async {
    final response = await _client.post(
      "/metrics",
      data: <String, dynamic>{
        "type": 0,
        "subtype": authType.index,
        "step": step.index,
        "status": status.index,
        "social_token": socialToken,
        "error": error,
        "backend_type": emailType?.index,
        "platform": PlatformWrap.isAndroid
            ? 0
            : PlatformWrap.isIOS
                ? 1
                : PlatformWrap.isWeb
                    ? 2
                    : throw Exception("Необработанная платформа в метриках")
      },
    );
    return response.data["code"] == 200;
  }
}
