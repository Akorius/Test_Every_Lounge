import 'package:everylounge/domain/data/storages/user_preference.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserPreferenceUseCaseImpl implements UserPreferenceUseCase {
  static const String boxName = 'UserPreferenceUseCaseImpl';

  static Future initHive() {
    return Hive.openBox(boxName);
  }

  final _hiveBox = Hive.box(boxName);

  bool _isShowUnauthorizedModal = false;

  @override
  void setShowedUnauthorizedModal({required bool isShow}) async {
    _isShowUnauthorizedModal = isShow;
  }

  @override
  void setShowedSuccessAlfaIDModal({required bool isShow}) => _hiveBox.put(_Keys.isAlreadyShownAuthCardAlfaModal.name, isShow);

  @override
  void setShowedSuccessTinkoffIDModal({required bool isShow}) =>
      _hiveBox.put(_Keys.isAlreadyShownAuthCardTinkoffModal.name, isShow);

  @override
  bool get isAlreadyShownUnauthorizedModal => _isShowUnauthorizedModal;

  @override
  bool get isAlreadyShownSuccessAlfaIDModal => _hiveBox.get(_Keys.isAlreadyShownAuthCardAlfaModal.name) ?? false;

  @override
  bool get isAlreadyShownSuccessTinkoffIDModal => _hiveBox.get(_Keys.isAlreadyShownAuthCardTinkoffModal.name) ?? false;
}

enum _Keys {
  isAlreadyShownAuthCardTinkoffModal,
  isAlreadyShownAuthCardAlfaModal,
}
