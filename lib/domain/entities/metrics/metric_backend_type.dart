///Подтип метрики  [StepOfMetric.requestSending] и [StepOfMetric.gettingResponse].
///Применим только для входа через email. Для социального входа не должен использоваться.
///Не менять местами и сохранять порядок.
enum MetricEmailType {
  /// 0
  emailCodeRequest,

  /// 1
  emailCodeResend,

  /// 2
  emailCodeConfirm,
}
