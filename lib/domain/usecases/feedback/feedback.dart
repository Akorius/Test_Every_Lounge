import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/feedback.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/feedback/faq.dart';
import 'package:everylounge/domain/entities/feedback/faq_type.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_services_use_case.dart';

abstract class FeedbackUseCase {
  Future<Result<bool>> postFeedBack({
    required String name,
    required String email,
    required String text,
  });

  Future<Result<List<Faq>>> getFaq();
}

class FeedbackUseCaseImpl implements FeedbackUseCase {
  final FeedbackApi _feedbackApi = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  final FindOutHideServicesUseCase _findOutHideServicesUseCase = getIt();

  @override
  Future<Result<bool>> postFeedBack({
    required String name,
    required String email,
    required String text,
  }) async {
    try {
      final result = await _feedbackApi.postFeedback(name: name, email: email, text: text);
      return Result.success(result);
    } catch (e, s) {
      Log.exception(e, s, "FeedbackUseCaseImpl");
      return Result.failure("Не удалось отправить ваше сообщение. Попробуйте позднее.");
    }
  }

  @override
  Future<Result<List<Faq>>> getFaq() async {
    try {
      var result = await _feedbackApi.getFaq();

      ///убираем упоминания банков из faq, если нужно
      if (_findOutHideParamsUseCase.faq()) {
        result = result.whereNot((element) => element.answer.contains("Тинькофф")).toList();
      }

      ///Фильтруем faq в зависимости от того, какие типы faq мы можем показывать
      final allowedFaqTypes = [
        if (!_findOutHideServicesUseCase.hideLounge) FaqType.lounge,
        if (!_findOutHideServicesUseCase.hideUpgrades) FaqType.upgrade,
        if (!_findOutHideServicesUseCase.hideMeetAndAssist) FaqType.premiumService,
      ];
      result = result.where((element) => allowedFaqTypes.contains(element.type)).toList();

      ///Фильтруем faq в зависимости от платформы
      result = result.where((element) => PlatformWrap.isWeb ? element.displayInWeb : element.displayInApp).toList();

      return Result.success(result);
    } catch (e, s) {
      Log.exception(e, s, "getFaq");
      return Result.failure("Не удалось получить часто задаваемые вопросы.");
    }
  }
}
