import 'package:everylounge/domain/entities/bank/bin.dart';
import 'package:everylounge/domain/entities/bank/card.dart';

abstract class PrivilegesApi {
  Future<void> removeCard({required int sdkCardId});

  Future<List<BankCard>> getCards();

  Future<void> setCardActive(String idCard);

  Future<bool> setBankActive(int id);

  Future<void> addCard(BankCard card);

  Future<List<Bin>> getBins();

  Future<void> searchByPhone(String phone, int type);

  Future<void> confirmByPhone(String phone, String code, int type);
}
