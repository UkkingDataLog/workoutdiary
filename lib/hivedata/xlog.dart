import 'dart:typed_data';

import 'package:hive/hive.dart';
//flutter packages pub run build_runner build을 터미널에 실행하여 파일생성
//아답터를 만들어서 하이브와 플러터를 연결해준다.
part 'xlog.g.dart';

@HiveType(typeId: 1)
class Xlog extends HiveObject {
  @HiveField(0)
  String luid;
  @HiveField(1)
  final DateTime lxdate;
  @HiveField(2)
  final String xbodypart;
  @HiveField(3)
  final String xType;
  @HiveField(4)
  final double lxweight;
  @HiveField(5)
  final String lxweightUnit;
  @HiveField(6)
  final int lxnumber;
  @HiveField(7)
  final int lxset;
  @HiveField(8)
  bool finished;

  Xlog({
    this.luid = 'temp0000000000',
    required this.lxdate,
    required this.xbodypart,
    required this.xType,
    required this.lxweight,
    required this.lxweightUnit,
    required this.lxnumber,
    required this.lxset,
    this.finished = false,
  });
}

@HiveType(typeId: 2)
class Ximg extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final String luid;
  @HiveField(2)
  Uint8List image;

  Ximg({
    required this.date,
    this.luid = 'temp0000000000',
    required this.image,
  });
}

@HiveType(typeId: 3)
class UserSetting extends HiveObject {
  @HiveField(0)
  String language;
  @HiveField(1)
  String weightUnit;

  UserSetting({
    this.language = 'ko', //한국 초기설정
    this.weightUnit = 'kg', //한국 초기설정
  });
}
