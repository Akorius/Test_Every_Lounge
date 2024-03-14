import 'package:everylounge/domain/entities/metrics/metric_backend_type.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';

abstract class MetricsApi {
  Future<bool> signInMetric({
    required MetricAuthType authType,
    required MetricStep step,
    required MetricStatus status,
    required String? socialToken,
    required String? error,
    required MetricEmailType? emailType,
  });
}
