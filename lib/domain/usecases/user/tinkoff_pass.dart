import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/tinkoff_pass.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/tinkoff_pass/tinkoff_passage.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';

abstract class TinkoffPassUseCase {
  Future<void> getPassageInfo(String accessToken);

  TinkoffPassage? get passage;

  void clean();
}

class TinkoffPassUseCaseImplMock implements TinkoffPassUseCase {
  final TinkoffPassage tinkoffPassage;

  TinkoffPassUseCaseImplMock({required this.tinkoffPassage});

  @override
  void clean() {}

  @override
  Future<void> getPassageInfo(String accessToken) async {
    return;
  }

  @override
  TinkoffPassage? get passage => tinkoffPassage;
}

class TinkoffPassUseCaseImpl implements TinkoffPassUseCase {
  final TinkoffPassApi _tinkoffPassApi = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  TinkoffPassage? _tinkoffPassage;

  @override
  Future<void> getPassageInfo(String accessToken) async {
    try {
      var isHide = _findOutHideParamsUseCase.isHideTinkoffPassage();
      _tinkoffPassage = isHide ? null : await _tinkoffPassApi.getPassageInfo(accessToken);
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 422) {
        //У клиента нет активной премиальной подписки
      } else {
        Log.exception(e, s, "Не удалось получить данные о проходах Тинькофф");
      }
    } catch (e, s) {
      Log.exception(e, s, "Не удалось получить данные о проходах Тинькофф");
    }
  }

  @override
  void clean() {
    _tinkoffPassage = null;
  }

  @override
  TinkoffPassage? get passage => _tinkoffPassage;
}
