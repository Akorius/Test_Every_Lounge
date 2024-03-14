abstract class UserPreferenceUseCase {
  void setShowedUnauthorizedModal({required bool isShow});

  void setShowedSuccessAlfaIDModal({required bool isShow});

  void setShowedSuccessTinkoffIDModal({required bool isShow});

  bool get isAlreadyShownUnauthorizedModal;

  bool get isAlreadyShownSuccessAlfaIDModal;

  bool get isAlreadyShownSuccessTinkoffIDModal;
}
