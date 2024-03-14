import 'package:dio/dio.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Log {
  ///в веб версии не отправляем логи в Sentry
  static final logWriter = kReleaseMode && PlatformWrap.isAndroidOrIOS ? LogWriterProduction() : LogWriterDevelopment();

  static void message(
    String message, {
    sender,
    StackTrace? stackTrace,
    skipInProduction = false,
  }) =>
      logWriter.captureMessage(message, sender, stackTrace, skipInProduction);

  static void exception(error, [StackTrace? stackTrace, sender]) => logWriter.captureException(error, stackTrace, sender);
}

abstract class LogWriter {
  void captureMessage(String message, sender, StackTrace? stackTrace, bool skipInProduction);

  void captureException(error, StackTrace? stackTrace, sender);
}

class LogWriterDevelopment extends LogWriter {
  final logger = Logger();

  @override
  void captureMessage(String message, [sender, StackTrace? stackTrace, bool skipInProduction = false]) {
    message = "$sender\n$message";
    logger.v(message, null, stackTrace);
  }

  @override
  void captureException(error, [StackTrace? stackTrace, sender]) {
    if (error is Error || error is DioError) stackTrace = error.stackTrace;
    logger.e(sender, error.toString(), stackTrace);
  }
}

class LogWriterProduction extends LogWriter {
  @override
  void captureMessage(String message, [sender, StackTrace? stackTrace, bool skipInProduction = false]) {
    if (skipInProduction) return;
    Sentry.addBreadcrumb(Breadcrumb(message: stackTrace.toString()));
    Sentry.captureMessage("$sender: $message");
  }

  @override
  void captureException(error, [StackTrace? stackTrace, sender]) {
    if (error is DioError) {
      if (error.type == DioErrorType.connectTimeout) {
        return;
      }
      try {
        var text = error.response?.data is String? ? error.response?.data : error.response?.data["text"];
        if (text is String? &&
            (text?.contains(errAlreadyExists) == true ||
                text?.contains(errBookingNotFound) == true ||
                text?.contains(errClassUpgradeDisallow) == true ||
                text?.contains(errBookingInvalidCharacter) == true)) {
          return;
        }
      } catch (e) {
        //ignore
      }
      final data = "${error.requestOptions.baseUrl + error.requestOptions.path}"
          "\n${error.requestOptions.data}"
          "\n${error.response?.data}"
          "\n${error.response?.extra}"
          "\n${error.response?.headers}";

      Sentry.addBreadcrumb(Breadcrumb(message: data));
      Sentry.captureException(
        error,
        stackTrace: stackTrace ?? error.stackTrace,
      );
    } else if (error is Error) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace ?? error.stackTrace,
      );
    } else {
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}

const String errAlreadyExists = "already exists";
const String errBookingNotFound = "Бронирование не найдено";
const String errBookingInvalidCharacter = "invalid character '<' looking for beginning of value";
const String errClassUpgradeDisallow = "На данном рейсе заказ услуги недоступен";
const String errUnknown = "Неизвестная ошибка";
