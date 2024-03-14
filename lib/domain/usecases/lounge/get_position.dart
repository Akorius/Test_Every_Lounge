import 'package:everylounge/domain/entities/common/result.dart';
import 'package:geolocator/geolocator.dart';

abstract class GetPositionUseCase {
  ///Получаем геопозицию
  Future<Result<Position>> get();
}

class GetPositionUseCaseImpl implements GetPositionUseCase {
  @override
  Future<Result<Position>> get() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Result.failure('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Result.failure('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Result.failure('Location permissions are permanently denied, we cannot request permissions.');
      }

      var position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 10));
      } else {
        Geolocator.getCurrentPosition();
      }
      return Result.success(position);
    } catch (e) {
      return Result.failure('Не удалось определить местоположение');
    }
  }
}
