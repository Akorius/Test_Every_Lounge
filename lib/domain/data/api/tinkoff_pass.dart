import 'package:everylounge/domain/entities/tinkoff_pass/tinkoff_passage.dart';

abstract class TinkoffPassApi {
  Future<TinkoffPassage> getPassageInfo(String accessToken);
}
