import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/metrics.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/metrics/metric_backend_type.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';

abstract class SendSignInMetricUseCase {
  ///Послать метрику.
  ///Отослать завершающую метрику в случае неуспеха.
  send({
    required MetricAuthType authType,
    required MetricStep step,
    required MetricStatus status,
    String? socialToken,
    String? error,
    MetricEmailType? emailType,
  });
}

class SendSignInMetricImpl extends SendSignInMetricUseCase {
  final MetricsApi _metricsApi = getIt();

  @override
  Future<Result<bool>> send({
    required MetricAuthType authType,
    required MetricStep step,
    required MetricStatus status,
    String? socialToken,
    String? error,
    MetricEmailType? emailType,
  }) async {
    try {
      ///Послать метрику.
      final result = await _metricsApi.signInMetric(
        authType: authType,
        step: step,
        status: status,
        socialToken: socialToken,
        error: error,
        emailType: emailType,
      );

      ///Отослать завершающую метрику в случае неуспеха
      if (status == MetricStatus.error || status == MetricStatus.cancelledByUser) {
        await _metricsApi.signInMetric(
          authType: authType,
          step: MetricStep.finish,
          status: status,
          socialToken: socialToken,
          error: error,
          emailType: emailType,
        );
      }
      return Result.success(result);
    } catch (e, s) {
      if (e is DioError && e.response?.statusCode == 401) {
        //ignore
      } else {
        Log.exception(e, s, "SendSignInMetric");
      }
      return Result.failure(e.toString());
    }
  }
}
