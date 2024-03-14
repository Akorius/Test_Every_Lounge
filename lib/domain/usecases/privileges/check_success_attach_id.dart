import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/user_preference.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';

abstract class CheckSuccessAttachIdUseCase {
  void checkNeedShowSuccessLoginById(List<BankCard>? cardList, Function callback);

  void setShowedSuccessModal(BankCard? activeCard);
}

class CheckSuccessAttachIdUseCaseImpl implements CheckSuccessAttachIdUseCase {
  final UserPreferenceUseCase _userPreferenceUseCase = getIt();

  @override
  void checkNeedShowSuccessLoginById(List<BankCard>? cardList, Function callback) {
    var activeCard = cardList?.firstWhereOrNull((element) => element.isActive);
    if (!_userPreferenceUseCase.isAlreadyShownSuccessAlfaIDModal && isAlfaTypeCard(activeCard?.type) ||
        !_userPreferenceUseCase.isAlreadyShownSuccessTinkoffIDModal && isTinkoffTypeCard(activeCard?.type)) {
      callback.call();
      setShowedSuccessModal(activeCard);
    }
    //проверка всех карт на наличие неактивны тинькоф или альфа
    if (!_userPreferenceUseCase.isAlreadyShownSuccessAlfaIDModal || !_userPreferenceUseCase.isAlreadyShownSuccessTinkoffIDModal) {
      //для каждого неактивного ставим флажок(потому что его уже подключали)
      cardList?.forEach((card) {
        if (card.type == isTinkoffTypeCard(card.type) || card.type == isAlfaTypeCard(card.type)) {
          setShowedSuccessModal(card);
        }
      });
    }
  }

  @override
  setShowedSuccessModal(BankCard? activeCard) {
    if (isTinkoffTypeCard(activeCard?.type)) {
      _userPreferenceUseCase.setShowedSuccessTinkoffIDModal(isShow: true);
    } else if (isAlfaTypeCard(activeCard?.type)) {
      _userPreferenceUseCase.setShowedSuccessAlfaIDModal(isShow: true);
    }
  }
}
