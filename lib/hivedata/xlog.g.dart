// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xlog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class XlogAdapter extends TypeAdapter<Xlog> {
  @override
  final int typeId = 1;

  @override
  Xlog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Xlog(
      luid: fields[0] as String,
      lxdate: fields[1] as DateTime,
      xbodypart: fields[2] as String,
      xType: fields[3] as String,
      lxweight: fields[4] as double,
      lxweightUnit: fields[5] as String,
      lxnumber: fields[6] as int,
      lxset: fields[7] as int,
      finished: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Xlog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.luid)
      ..writeByte(1)
      ..write(obj.lxdate)
      ..writeByte(2)
      ..write(obj.xbodypart)
      ..writeByte(3)
      ..write(obj.xType)
      ..writeByte(4)
      ..write(obj.lxweight)
      ..writeByte(5)
      ..write(obj.lxweightUnit)
      ..writeByte(6)
      ..write(obj.lxnumber)
      ..writeByte(7)
      ..write(obj.lxset)
      ..writeByte(8)
      ..write(obj.finished);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XlogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class XimgAdapter extends TypeAdapter<Ximg> {
  @override
  final int typeId = 2;

  @override
  Ximg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ximg(
      date: fields[0] as DateTime,
      luid: fields[1] as String,
      image: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, Ximg obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.luid)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XimgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSettingAdapter extends TypeAdapter<UserSetting> {
  @override
  final int typeId = 3;

  @override
  UserSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSetting(
      language: fields[0] as String,
      weightUnit: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserSetting obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.weightUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
