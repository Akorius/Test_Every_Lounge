import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/card.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_anon.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';

abstract class LogOutUserUseCase {
  Future<Result<bool>> logOut();
}

class LogOutUserUseCaseImpl implements LogOutUserUseCase {
  final TokensStorage _tokensStorage = getIt();
  final UserStorage _userStorage = getIt();
  final CardStorage _cardStorage = getIt();
  final GetUserOrdersUseCase _getUserOrdersUseCase = getIt();
  final SignInWithAnonUseCase _signInWithAnonUseCase = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  @override
  Future<Result<bool>> logOut() async {
    try {
      await _tokensStorage.deleteTokens();
      _userStorage.user = null;
      _cardStorage.cards = null;
      _getUserOrdersUseCase.cleanOrders();
      _tinkoffPassUseCase.clean();
      await _signInWithAnonUseCase.signIn();
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "LogOutUserUseCaseImpl");
      return Result.failure("Не удалось выйти из аккаунта.");
    }
  }
}
