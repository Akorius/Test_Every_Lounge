///Объект-обёртка возвращаемый из метода репозитория
///Содержит в себе либо значение в случае успешного завершения метода,
///либо сообщение для пользователя, которое мы отобразим через BLOC, а также опционально тип неудачи
class Result<V> {
  late final bool isSuccess;
  late final V value;
  late final String message;
  late final dynamic failureValue;

  ///Конструктор, обозначающий успешное завершение метода, содержит значение
  Result.success(this.value) {
    isSuccess = true;
  }

  ///Конструктор, обозначающий неудачное завершение метода.
  ///Содержит сообщение [message] для отображения пользователю
  ///и опционально значение [failureValue] - enum причины неудачи, на тот случай, если необходимо
  /// в зависимости от причины ошибки отобразить различные  графические элементы, а не просто вывести текст
  /// ошибки
  Result.failure(this.message, [this.failureValue]) {
    isSuccess = false;
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Result{isSuccess: $isSuccess, value: ${value.toString()}';
    } else {
      return 'Result{isSuccess: $isSuccess, message: $message}';
    }
  }
}
