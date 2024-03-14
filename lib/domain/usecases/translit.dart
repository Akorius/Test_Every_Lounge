import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/core/utils/translitor.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';

abstract class TranslitUseCase {
  String translit(String string);

  bool findOut(String airportCode, String organizationId);
}

class TranslitUseCaseImplMock implements TranslitUseCase {
  @override
  bool findOut(String airportCode, String organizationId) {
    return true;
  }

  @override
  String translit(String string) {
    return '';
  }
}

class TranslitUseCaseImpl implements TranslitUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();
  final Translitor translitor = getIt();

  @override
  String translit(String string) {
    return translitor.translit(string);
  }

  @override
  bool findOut(String countryCode, String organizationId) {
    return countryCode != "RU" ||
        organizationId == _remoteConfigStorage.qrOrganizationId ||
        organizationId == _remoteConfigStorage.dragonPassOrganizationId;
  }
}
