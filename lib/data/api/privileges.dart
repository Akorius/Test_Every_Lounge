import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/entities/bank/bin.dart';
import 'package:everylounge/domain/entities/bank/card.dart';

class PrivilegesApiImpl implements PrivilegesApi {
  final Dio _client = getIt();

  @override
  Future<List<BankCard>> getCards() async {
    final response = await _client.get("cards/");
    final data = (response.data as Map<String, dynamic>)['data'];
    final list = data.map((e) => BankCard.fromJson(e as Map<String, dynamic>)).toList();
    return List<BankCard>.from(list);
  }

  @override
  Future<List<Bin>> getBins() async {
    final response = await _client.get("card-bins/");
    return (response.data['data'] as List).map((e) => Bin.fromJson(e)).toList();
  }

  @override
  Future<void> addCard(BankCard card) async {
    final formData = FormData.fromMap({
      "sdk_id": card.sdkId,
      "masked_number": card.maskedNumber,
      "type": card.type.index,
      "self_passes": card.selfPasses,
      "guest_passes": card.guestPasses,
      "rebill_id": card.rebillId,
    });
    await _client.post("cards/", data: formData);
  }

  @override
  Future<void> setCardActive(String idCard) async {
    await _client.put("cards/$idCard/active");
  }

  @override
  Future<bool> setBankActive(int id) async {
    final response = await _client.post("cards/bank/$id/active");
    return response.data["code"] == 200;
  }

  @override
  Future<void> removeCard({required int sdkCardId}) async {
    await _client.delete("cards/$sdkCardId");
  }

  @override
  Future<void> searchByPhone(String phone, int type) async {
    await _client.post(
      "cards/phone/add",
      data: FormData.fromMap({
        "phone_number": phone, //79115114131
        "type": type,
      }),
    );
  }

  @override
  Future<void> confirmByPhone(String phone, String code, int type) async {
    await _client.post(
      "cards/phone/add",
      data: FormData.fromMap({
        "phone_number": phone, //79115114131
        "type": type,
        "code": code,
      }),
    );
  }
}
