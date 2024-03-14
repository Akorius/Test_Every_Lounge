import 'package:hive/hive.dart';

part 'auth.g.dart';

@HiveType(typeId: 4)
enum AnonStatusRequesting {
  @HiveField(0)
  none,
  @HiveField(1)
  requesting,
  @HiveField(3)
  done,
}

@HiveType(typeId: 22)
enum AuthType {
  @HiveField(0)
  email,
  @HiveField(1)
  google,
  @HiveField(2)
  facebook,
  @HiveField(3)
  anon,
  @HiveField(4)
  ios,
  @HiveField(5)
  undefined
}
