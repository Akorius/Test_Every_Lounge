import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';

abstract class GetDeveloperModeUseCase {
  bool enabled();

  bool payWithOneRuble();

  bool toggleDeveloperMode();

  bool togglePayWithOneRuble();
}

class GetDeveloperModeUseCaseImpl implements GetDeveloperModeUseCase {
  final DeveloperModeStorage _developerModeStorage = getIt();

  @override
  bool enabled() => _developerModeStorage.enabled;

  @override
  bool payWithOneRuble() => _developerModeStorage.payWithOneRuble;

  @override
  bool toggleDeveloperMode() => _developerModeStorage.enabled = !_developerModeStorage.enabled;

  @override
  bool togglePayWithOneRuble() => _developerModeStorage.payWithOneRuble = !_developerModeStorage.payWithOneRuble;
}
