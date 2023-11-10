import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("de", LocaleData.DE),
  MapLocale("ko", LocaleData.KO),
  MapLocale("ja", LocaleData.JA),
  MapLocale("es", LocaleData.ES),
  MapLocale("zh", LocaleData.ZH),
  MapLocale("pt", LocaleData.PT),
  MapLocale("ar", LocaleData.AR),
  MapLocale("hi", LocaleData.HI),
];

mixin LocaleData {
  static const String title = 'title';
  static const String body = 'body';
  static const String add = 'add';

  // 영어 (English)
  static const Map<String, dynamic> EN = {
    title: 'Localization',
    body: 'Welcome to this localized Flutter app',
    add: 'Add',
  };

  // 독일어 (German)
  static const Map<String, dynamic> DE = {
    title: 'Lokalisierung',
    body: 'Willkommen bei dieser lokalisierten Flutter-App',
    add: 'Hinzufügen',
  };

  // 한국어 (Korean)
  static const Map<String, dynamic> KO = {
    title: '로컬라이제이션',
    body: '이 로컬라이즈된 Flutter 앱에 오신 것을 환영합니다.',
    add: '추가',
  };

  // 일본어 (Japanese)
  static const Map<String, dynamic> JA = {
    title: 'ローカリゼーション',
    body: 'このローカライズされたFlutterアプリへようこそ',
    add: '追加',
  };

  // 스페인어 (Spanish)
  static const Map<String, dynamic> ES = {
    title: 'Localización',
    body: 'Bienvenido a esta aplicación Flutter localizada',
    add: 'Agregar',
  };

  // 중국어 (Simplified Chinese)
  static const Map<String, dynamic> ZH = {
    title: '本地化',
    body: '欢迎来到本地化的Flutter应用',
    add: '添加',
  };

  // 포르투갈어 (Portuguese)
  static const Map<String, dynamic> PT = {
    title: 'Localização',
    body: 'Bem-vindo a este aplicativo Flutter localizado',
    add: 'Adicionar',
  };

  // 아랍어 (Arabic)
  static const Map<String, dynamic> AR = {
    title: 'التوطين',
    body: 'مرحبًا بك في تطبيق Flutter المحلي',
    add: 'إضافة',
  };

  // 힌디어 (Hindi)
  static const Map<String, dynamic> HI = {
    title: 'स्थानीयकरण',
    body: 'इस स्थानीयकृत Flutter ऐप में आपका स्वागत है',
    add: 'जोड़ें',
  };
}
