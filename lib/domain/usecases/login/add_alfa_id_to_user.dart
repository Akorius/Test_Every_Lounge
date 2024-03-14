import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_id.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/failure_value.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';

abstract class AddAlfaIdToUserUseCase {
  Future<Result<User>> add(AlfaIdResult? aResult);
}

class AddAlfaIdToUserUseCaseImpl implements AddAlfaIdToUserUseCase {
  final AlfaIdApi _alfaIdApi = getIt();

  @override
  Future<Result<User>> add(AlfaIdResult? aResult) async {
    ///Обрабатываем результат, который завершился с ошибкой
    if (!(aResult?.isSuccess ?? false)) {
      final String message;
      switch (aResult?.failureValue) {
        case null:
        case AlfaIdFailure.cancelledByUser:
          message = "Вход отменён пользователем";
          break;
        case AlfaIdFailure.webResourceError:
        case AlfaIdFailure.noCodeInRedirectUri:
        case AlfaIdFailure.apiCallError:
        case AlfaIdFailure.clientNotFound:
          Log.exception(Exception(aResult!.message), null, "processWebViewResult");
          message = aResult.message;
          break;
      }
      return Result.failure(message, aResult?.failureValue ?? AlfaIdFailure.cancelledByUser);
    }

    try {
      final User addResult = await _alfaIdApi.addAlfaIdToUser(aResult?.tokenPayload ?? '');
      // _tokensStorage.alfaRefreshToken = refreshToken;
      return Result.success(addResult);
    } catch (e, s) {
      Log.exception(e, s, "AddAlfaIdToUserUseCaseImpl");
      const message = "Не удалось добавить пользователя Alfa к пользователю EveryLounge.";
      return Result.failure(message);
    }
  }
}
