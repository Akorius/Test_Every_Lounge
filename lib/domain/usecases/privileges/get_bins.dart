import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/data/storages/card.dart';
import 'package:everylounge/domain/entities/bank/bin.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetBinsUseCase {
  ///Получаем пользователя через API
  ///Сохраняем в хранилище
  ///Передаеём с поток
  Future<Result<List<Bin>>> get();

  ///Получаем поток пользователя, где гарантированно есть локально сохранённый пользователь
  Stream<List<Bin>> get stream;
}

class GetBinsUseCaseImpl implements GetBinsUseCase {
  final PrivilegesApi _cardApi = getIt();
  final CardStorage _storage = getIt();
  final BehaviorSubject<List<Bin>> _binsController = BehaviorSubject();

  @override
  Future<Result<List<Bin>>> get() async {
    ///Получаем бины через api
    late final List<Bin> bins;
    try {
      bins = await _cardApi.getBins();
    } catch (e, s) {
      Log.exception(e, s, "GetBinsUseCase");
      return Result.failure("Не удалось получить информацию о вашем профиле. Попробуйте позднее.");
    }

    /// Сохраняем бины локально
    try {
      _storage.bins = bins;
    } catch (e, s) {
      Log.exception(e, s, "userMe");
      return Result.failure("Не удалось сохранить профиль в базу данных. Попробуйте позднее.");
    }

    /// Добавляем бины в поток из хранилища
    _binsController.add(bins);
    return Result.success(bins);
  }

  @override
  Stream<List<Bin>> get stream {
    final bins = _storage.bins;
    if (bins != null) {
      _binsController.add(bins);
    } else {
      get();
    }
    return _binsController.stream;
  }
}
