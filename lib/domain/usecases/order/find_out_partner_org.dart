import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';

class FindOutPartnerOrgUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();

  bool isLoungeMe(String organizationId) {
    return organizationId == _remoteConfigStorage.qrOrganizationId;
  }

  bool isDragonPass(String organizationId) {
    return organizationId == _remoteConfigStorage.dragonPassOrganizationId;
  }

  bool isAirportOrgs(String organizationId) {
    return _remoteConfigStorage.airportOrgIds.contains(organizationId);
  }
}
