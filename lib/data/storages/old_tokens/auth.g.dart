// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnonStatusRequestingAdapter extends TypeAdapter<AnonStatusRequesting> {
  @override
  final int typeId = 4;

  @override
  AnonStatusRequesting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnonStatusRequesting.none;
      case 1:
        return AnonStatusRequesting.requesting;
      case 3:
        return AnonStatusRequesting.done;
      default:
        return AnonStatusRequesting.none;
    }
  }

  @override
  void write(BinaryWriter writer, AnonStatusRequesting obj) {
    switch (obj) {
      case AnonStatusRequesting.none:
        writer.writeByte(0);
        break;
      case AnonStatusRequesting.requesting:
        writer.writeByte(1);
        break;
      case AnonStatusRequesting.done:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnonStatusRequestingAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class AuthTypeAdapter extends TypeAdapter<AuthType> {
  @override
  final int typeId = 22;

  @override
  AuthType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AuthType.email;
      case 1:
        return AuthType.google;
      case 2:
        return AuthType.facebook;
      case 3:
        return AuthType.anon;
      case 4:
        return AuthType.ios;
      case 5:
        return AuthType.undefined;
      default:
        return AuthType.email;
    }
  }

  @override
  void write(BinaryWriter writer, AuthType obj) {
    switch (obj) {
      case AuthType.email:
        writer.writeByte(0);
        break;
      case AuthType.google:
        writer.writeByte(1);
        break;
      case AuthType.facebook:
        writer.writeByte(2);
        break;
      case AuthType.anon:
        writer.writeByte(3);
        break;
      case AuthType.ios:
        writer.writeByte(4);
        break;
      case AuthType.undefined:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
