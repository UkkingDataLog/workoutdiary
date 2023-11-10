import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:timer_builder/timer_builder.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/exercise_date/ximg_saved_tile.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_date_calendar_view.dart';
import 'package:workoutdiary/exercise_log/today_xlog_list_tile.dart';
import 'package:workoutdiary/hivedata/xlog.dart';

import 'package:workoutdiary/common_widget/round_button.dart';
import 'package:workoutdiary/common_widget/show_toast_message.dart';
import 'package:workoutdiary/data/xlog_data_list.dart';
import 'package:workoutdiary/exercise_log/xlog_create_tile.dart';

import 'package:workoutdiary/helper/app_image_picker.dart';
import 'package:workoutdiary/localization/locales.dart';
import 'package:workoutdiary/providers/app_image_provider.dart';

import 'package:screenshot/screenshot.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:workoutdiary/setting/setting_view.dart';
import 'package:workoutdiary/ui/ui_group.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:workoutdiary/youtubeVideo/custom_youtube_player.dart';

class XlogCreateView extends StatefulWidget {
  const XlogCreateView({super.key});

  @override
  State<XlogCreateView> createState() => XlogCreateViewState();
}

class XlogCreateViewState extends State<XlogCreateView> {
  //
  bool isSelectedYoutube = false;
  bool isSelectedkg = true;
  String selectedWeighUnint = 'kg';

  //현재 이미지가 찼는지 확인을 위한 변수
  late Ximg tempximg;
  late int tempximgindex;
  bool isselectedlog = true;
  //스크롤 컨트롤러를 선언합니다.
  final ScrollController _scrollController = ScrollController();
  //기록상태변경
  bool isselectedWritting = false;

  //이미지 가져오기, 카메라 사용
  late AppImageProvider imageProvider;

  // youtube streaming
  String videoURL = 'default';
  //
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      _flutterLocalization.translate(('en'));
    } else if (value == 'ko') {
      _flutterLocalization.translate(('ko'));
    } else if (value == 'de') {
      _flutterLocalization.translate(('de'));
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    // print(_currentLocale);

    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _createRewardedInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  //화면 전환 후 초기화
  void _update() {
    setState(() {
      //
    });
  }

  //--------------------<<  Variable  >>--------------------
  int _timeformat = 0;
  //사진 크기 변경
  int _ratio = 1;
  final Map<int, String> ratios = {
    0: '1:1',
    1: '4:5',
    2: '9:16',
  };
  final Map<int, double> ratiosMultiply = {
    0: 1, //1:1
    1: 1 / 4 * 5, //4:5
    2: 1 / 9 * 16, //9:16 반올림
  };

  //1. exercise
  var _isbodypartcontroller = BodyPart.values[0].koreanName;

  //
  //1. exercise
  //input
  int xTypeIndex = 0;
  int selectedxTypeIndex = 0;
  String selectedxTypeItem = '바벨 글루트 브릿지'; //부위선택하고 나오는 첫번째 운동으로 변경해줘야함
  String selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Glute_Bridge.png';

  //2. weight when exercising
  //input
  int lxweightIndex = 30; //무게초기설정
  String selectedlxweightItems = '30';

  //3. Number of repetitions per exercise
  //input
  int lxnumberIndex = 14;
  String selectedlxnumberItem = '15';

  //4. input number of sets
  //input
  int lxsetIndex = 4;
  String selectedlxsetItem = '5';

  //--------------------<<   design   >>--------------------
  //selected log options
  //public
  double logheightmargin = 50;
  double logTextSizeselected = 18;
  double logTextSize = 14;
  double logbottomHeight = 60;
  FontWeight logTextFontselectedWeight = FontWeight.w700;

  //about CupertinoPicker
  //public
  //CupertinoPicker height
  double cupertinoPickerHeight = 180;
  double cupertinoPickeritemExtent = 44;
  //background color
  Color cupertinoPickercolor = TColor.primarygray.withOpacity(0.05);

  //스크린샷 컨트롤러
  final screenshotController = ScreenshotController();
  //장비 선택 유무
  bool isSelectedBabel = true;
  bool isSelectedDumbbell = true;
  bool isSelectedMachine = true;
  bool isSelectedBodyweight = true;
  //
  @override
  Widget build(BuildContext context) {
    switch (selectedxTypeItem) {
      case '바벨 글루트 브릿지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Glute_Bridge.png';
        break;
      case '스모 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Sumo_Deadlift.png';
        break;
      case '바벨 백 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Back_Squat.png';
        break;
      case '바벨 불가리안 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Bulgarian_Split_Squat.png';
        break;
      case '바벨 프론트 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Front_Squat.png';
        break;
      case '바벨 핵 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Hack_Squat.png';
        break;
      case '바벨 레터럴 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Lateral_Lunge.png';
        break;
      case '바벨 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Lunge.png';
        break;
      case '컨벤셔널 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Conventional_Deadlift.png';
        break;
      case '데피싯 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Deficit_Deadlift.png';
        break;
      case '루마니안 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Romanian_Deadlift.png';
        break;
      case '바벨 프론트 랙 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Front_Rack_Lunge.png';
        break;
      case '바벨 힙 쓰러스트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Hip_Thrust.png';
        break;
      case '바벨 점프 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Jump_Squat.png';
        break;
      case '바벨 원레그 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_One_Leg_Deadlift.png';
        break;
      case '바벨 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Split_Squat.png';
        break;
      case '바벨 스탠딩 카프 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Standing_Calf_Raise.png';
        break;
      case '바벨 스모 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Sumo_Squat.png';
        break;
      case '트랩바 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Trap_Bar_Deadlift.png';
        break;
      case '저처 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Zercher_Squat.png';
        break;
      case '덤벨 레터럴 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Lateral_Lunge.png';
        break;
      case '덤벨 스모 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Sumo_Deadlift.png';
        break;
      case '덤벨 불가리안 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Bulgarian_Split_Squat.png';
        break;
      case '덤벨 고블릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Goblet_Squat.png';
        break;
      case '덤벨 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Lunge.png';
        break;
      case '덤벨 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Squat.png';
        break;
      case '덤벨 스모 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Sumo_Squat.png';
        break;
      case '덤벨 루마니안 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Romanian_Deadlift.png';
        break;
      case '덤벨 카프 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Calf_Raise.png';
        break;
      case '덤벨 레그컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Leg_Curl.png';
        break;
      case '덤벨 원레그 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_One_Leg_Deadlift.png';
        break;
      case '덤벨 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Split_Squat.png';
        break;
      case '덤벨 스티프 레그 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Stiff_Leg_Deadlift.png';
        break;
      case '중량 스텝업':
        selectedxTypeImgpath = 'assets/img/workoutType/L_D_Weight_Step_Up.png';
        break;
      case '글루트 킥백 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Glute_Kickback_Machine.png';
        break;
      case '레그 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Extension.png';
        break;
      case '레그 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Press.png';
        break;
      case '레그 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Curl.png';
        break;
      case '케이블 덩키 킥':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Donkey_Kick.png';
        break;
      case '케이블 힙 어브덕션':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Hip_Abduction.png';
        break;
      case '케이블 힙 어덕션':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Hip_Adduction.png';
        break;
      case '케이블 풀 스루':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Pull_Through.png';
        break;
      case '핵 스쿼트 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hack_Squat_Machine.png';
        break;
      case '힙 어브덕션 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hip_Abduction_Machine.png';
        break;
      case '힙 쓰러스트 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hip_Thrust_Machine.png';
        break;
      case '수평 레그 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Horizontal_Leg_Press.png';
        break;
      case '수평 원레그 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Horizontal_One_Leg_Press.png';
        break;
      case '이너 싸이 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Inner_Cy_Machine.png';
        break;
      case '몬스터 글루트 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Monster_Glute_Machine.png';
        break;
      case '원레그 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Curl.png';
        break;
      case '원레그 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Extension.png';
        break;
      case '원레그 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Press.png';
        break;
      case '리버스 브이 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Reverse_V_Squat.png';
        break;
      case '시티드 카프 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_Calf_Raises.png';
        break;
      case '시티드 레그 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_Leg_Curl.png';
        break;
      case '시티드 원레그 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_One_Leg_Curl.png';
        break;
      case '스미스 머신 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Deadlift.png';
        break;
      case '스미스머신 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Split_Squat.png';
        break;
      case '스미스머신 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Squat.png';
        break;
      case '스탠딩 카프 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_Standing_Calf_Raise.png';
        break;
      case '브이 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_M_V_Squat.png';
        break;
      case '덩키 킥':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Donkey_Kick.png';
        break;
      case '런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lunge.png';
        break;
      case '글루트 브릿지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Glute_Bridge.png';
        break;
      case '노르딕 햄스트링 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Nordic_Hamstring_Curl.png';
        break;
      case '에어 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Air_Squat.png';
        break;
      case '맨몸 카프 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Body_Calf_Raise.png';
        break;
      case '맨몸 레터럴 런지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Lateral_Lunge.png';
        break;
      case '맨몸 원레그 데드리프트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_One_Leg_Deadlift.png';
        break;
      case '맨몸 오버헤드 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Overhead_Squat.png';
        break;
      case '맨몸 스플릿 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Split_Squat.png';
        break;
      case '힙 쓰러스트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Hip_Thrust.png';
        break;
      case '점프 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Jump_Squat.png';
        break;
      case '런지 트위스트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lunge_Twist.png';
        break;
      case '라잉 힙 어브덕션':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lying_Hip_Abduction.png';
        break;
      case '피스톨 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Pistol_Squat.png';
        break;
      case '사이드 라잉 클램':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Side_Lying_Clam.png';
        break;
      case '싱글 레그 글루트 브릿지':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Single_Leg_Glute_Bridge.png';
        break;
      case '스텝업':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Step_Up.png';
        break;
      case '스모 에어 스쿼트':
        selectedxTypeImgpath = 'assets/img/workoutType/L_B_Sumo_Air_Squat.png';
        break;
      case '바벨 오버헤드 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Overhead_Press.png';
        break;
      case '바벨 프론트 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Front_Raise.png';
        break;
      case '바벨 슈러그':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Shrug.png';
        break;
      case '바벨 업라이트 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Upright_Row.png';
        break;
      case '이지바 프론트 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Easy_Bar_Front_Raise.png';
        break;
      case '이지바 업라이트 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Easy_Bar_Upright_Row.png';
        break;
      case '플레이트 숄더 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Plate_Shoulder_Press.png';
        break;
      case '푸시 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Push_Press.png';
        break;
      case '시티드 바벨 숄더 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Seated_Barbell_Shoulder_Press.png';
        break;
      case '아놀드 덤벨 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Arnold_Dumbbell_Press.png';
        break;
      case '벤트오버 덤벨 레터럴 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Bentover_Dumbbell_Lateral_Raise.png';
        break;
      case '덤벨 프론트 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Front_Raise.png';
        break;
      case '덤벨 레터럴 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Lateral_Raise.png';
        break;
      case '덤벨 숄더 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Shoulder_Press.png';
        break;
      case '덤벨 슈러그':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Shrug.png';
        break;
      case '덤벨 업라이트 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Upright_Row.png';
        break;
      case '덤벨 Y 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Y_Raise.png';
        break;
      case '시티드 덤벨 리어 레터럴 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Seated_Dumbbell_Rear_Lateral_Raise.png';
        break;
      case '시티드 덤벨 숄더 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_D_Seated_Dumbbell_Shoulder_Press.png';
        break;
      case '비하인드 넥 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Behind_Neck_Press.png';
        break;
      case '케이블 익스터널 로테이션':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_External_Rotation.png';
        break;
      case '케이블 프론트 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Front_Raise.png';
        break;
      case '케이블 인터널 로테이션':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Internal_Rotation.png';
        break;
      case '케이블 레터럴 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Lateral_Raise.png';
        break;
      case '케이블 리버스 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Reverse_Fly.png';
        break;
      case '케이블 슈러그':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Shrug.png';
        break;
      case '페이스풀':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Faithfull.png';
        break;
      case '랜드마인 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Landmine_Press.png';
        break;
      case '레터럴 레이즈 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Lateral_Raise_Machine.png';
        break;
      case '원암 케이블 레터럴 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_One-Arm_Cable_Lateral_Raise.png';
        break;
      case '리어 델토이드 플라이 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Rear_Deltoid_Fly_Machine.png';
        break;
      case '숄더 플레스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Shoulder_Press_Machine.png';
        break;
      case '슈러그 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Shrug_Machine.png';
        break;
      case '스미스머신 오버헤드 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Smith_Machine_Overhead_Press.png';
        break;
      case '스미스머신 슈러그':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Smith_Machine_Shrug.png';
        break;
      case '원암 랜드마인 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/S_M_Wonam_Landmine_Press.png';
        break;
      case '핸드스탠드':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Handstand.png';
        break;
      case '핸드스탠드 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Handstand_Push_Up.png';
        break;
      case '숄더 탭':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Shoulder_Tab.png';
        break;
      case 'Y 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/S_B_Y_Raise.png';
        break;
      case '바벨 플로어 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Barbell_Floor_Press.png';
        break;
      case '벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Bench_Press.png';
        break;
      case '디클라인 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Decline_Bench_Press.png';
        break;
      case '인클라인 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Incline_Bench_Press.png';
        break;
      case '스포토 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Spoto_Bench_Press.png';
        break;
      case '디클라인 덤벨 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Decline_Dumbbell_Bench_Press.png';
        break;
      case '디클라인 덤벨 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Decline_Dumbbell_Fly.png';
        break;
      case '덤벨 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Bench_Press.png';
        break;
      case '덤벨 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Fly.png';
        break;
      case '덤벨 풀오버':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Pullover.png';
        break;
      case '덤벨 스퀴즈 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Squeeze_Press.png';
        break;
      case '인클라인 덤벨 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Bench_Press.png';
        break;
      case '인클라인 덤벨 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Flyes.png';
        break;
      case '인클라인 덤벨 트위스트 프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Twist_Press.png';
        break;
      case '중량 딥스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_D_Weighted_Dips.png';
        break;
      case '어시스트 딥스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Assist_Dips_Machine.png';
        break;
      case '케이블 크로스오버':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Cable_Crossover.png';
        break;
      case '체스트 프레스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Chest_Press_Machine.png';
        break;
      case '디클라인 체스트 프레스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Decline_Chest_Press_Machine.png';
        break;
      case '해머 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Hammer_Bench_Press.png';
        break;
      case '인클라인 벤치프레스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Bench_Press_Machine.png';
        break;
      case '인클라인 케이블 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Cable_Fly.png';
        break;
      case '인클라인 체스트 프레스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Chest_Press_Machine.png';
        break;
      case '로우 풀리 케이블 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Low_Pulley_Cable_Fly.png';
        break;
      case '펙덱 플라이 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Peck_Deck_Fly_Machine.png';
        break;
      case '시티드 딥스 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Seated_Dips_Machine.png';
        break;
      case '스미스머신 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Smith_Machine_Bench_Press.png';
        break;
      case '스미스머신 인클라인 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Smith_Machine_Inline_Bench_Press.png';
        break;
      case '스탠딩 케이블 플라이':
        selectedxTypeImgpath = 'assets/img/workoutType/C_M_Standing_Cable_Fly.png';
        break;
      case '아처 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Archer_Push_Up.png';
        break;
      case '클랩 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Clap_Push_Up.png';
        break;
      case '클로즈그립 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Close_Grip_Push_Up.png';
        break;
      case '딥스':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Dips.png';
        break;
      case '힌두 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Hindu_Push_Up.png';
        break;
      case '파이크 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Pike_Push_Up.png';
        break;
      case '푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Push_Up.png';
        break;
      case '중량 푸시업':
        selectedxTypeImgpath = 'assets/img/workoutType/C_B_Weighted_Push_Ups.png';
        break;
      //팔-----
      case '바벨 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Curl.png';
        break;
      case '바벨 라잉 트라이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Lying_Tricep_Extension.png';
        break;
      case '바벨 프리쳐 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Preacher_Curl.png';
        break;
      case '바벨 리스트 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Wrist_Curl.png';
        break;
      case '클로즈 그립 벤치프레스':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Close_Grip_Bench_Press.png';
        break;
      case '이지바 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Curl.png';
        break;
      case '이지바 프리쳐 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Preacher_Curl.png';
        break;
      case '이지바 리스트 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Wrist_Curl.png';
        break;
      case '리스트 롤러':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_List_Roller.png';
        break;
      case '리버스 바벨 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Reverse_Barbell_Curl.png';
        break;
      case '리버스 바벨 리스트 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Reverse_Barbell_Wrist_Curl.png';
        break;
      case '스컬 크러셔':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Skull_Crusher.png';
        break;
      case '뎀벨 프리쳐 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dembel_Preacher_Curl.png';
        break;
      case '덤벨 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Curl.png';
        break;
      case '덤벨 해머 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Hammer_Curl.png';
        break;
      case '덤벨 킥백':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Kickback.png';
        break;
      case '덤벨 트리이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Tricep_Extension.png';
        break;
      case '덤벨 리스트 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Wrist_Curl.png';
        break;
      case '인클라인 덤벨 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Incline_Dumbbell_Curl.png';
        break;
      case '리버스 덤벨 리스트 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Reverse_Dumbbell_Wrist_Curl.png';
        break;
      case '시티드 덤벨 트라이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_D_Seated_Dumbbell_Tricep_Extension.png';
        break;
      case '암 컬 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Arm_Curl_Machine.png';
        break;
      case '케이블 컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Curl.png';
        break;
      case '케이블 해머컬':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Hammer_Curl.png';
        break;
      case '케이블 라잉 트라이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Lying_Tricep_Extension.png';
        break;
      case '케이블 오버헤드 트라이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Overhead_Tricep_Extension.png';
        break;
      case '케이블 푸시 다운':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Push_Down.png';
        break;
      case '케이블 트라이셉 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Tricep_Extension.png';
        break;
      case '프리쳐 컬 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Preacher_Curl_Machine.png';
        break;
      case '트라이셉 익스텐션 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/R_M_Tricep_Extension_Machine.png';
        break;
      case '벤치 딥스':
        selectedxTypeImgpath = 'assets/img/workoutType/R_B_Bench_Dips.png';
        break;

      //
      case '바벨 풀오버':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Barbell_Pullover.png';
        break;
      case '바벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Barbell_Row.png';
        break;
      case '굿모닝 엑서사이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Good_Morning_Exercise.png';
        break;
      case '인클라인 바벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Incline_Barbell_Row.png';
        break;
      case '라잉 바벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Lying_Barbell_Row.png';
        break;
      case '펜들레이 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Pendlay_Row.png';
        break;
      case '언더그립 바벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Undergrip_Barbell_Row.png';
        break;
      case '덤벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_D_Dumbbell_Row.png';
        break;
      case '인클라인 덤벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_D_Incline_Dumbbell_Row.png';
        break;
      case '원암 덤벨 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_D_One-Arm_Dumbbell_Row.png';
        break;
      case '중량 친업':
        selectedxTypeImgpath = 'assets/img/workoutType/B_D_Weighted_Chin-Up.png';
        break;
      case '중량 풀업':
        selectedxTypeImgpath = 'assets/img/workoutType/B_D_Weighted_Pull_Ups.png';
        break;
      case '어시스트 풀업 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Assist_Pull-Up_Machine.png';
        break;
      case '비하인드 넥 풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Behind_The_Neck_Pulldown.png';
        break;
      case '케이블 암 풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Cable_Arm_Pulldown.png';
        break;
      case '플로어 시티드 케이블 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Floor_Seated_Cable_Row.png';
        break;
      case '중량 하이퍼 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Heavy_Hyperextension.png';
        break;
      case '하이 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_High_Low_Machine.png';
        break;
      case '인버티드 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Inverted_Row.png';
        break;
      case '랫풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Lat_Pulldown.png';
        break;
      case '레터럴 와이드 풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Lateral_Wide_Pulldown.png';
        break;
      case '맥그립 랫풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Mcgrip_Lat_Pulldown.png';
        break;
      case '원암 케이블 풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Cable_Pull_Down.png';
        break;
      case '원암 하이 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_High_Low_Machine.png';
        break;
      case '원암 레터럴 와이드 풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Lateral_Wide_Pulldown.png';
        break;
      case '원암 시티드 케이블 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Seated_Cable_Row.png';
        break;
      case '원암 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_One-Arm_Row_Machine.png';
        break;
      case '패러럴그립 랫풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Parallel_Grip_Lat_Pulldown.png';
        break;
      case '로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Row_Machine.png';
        break;
      case '시티드 케이블 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Seated_Cable_Row.png';
        break;
      case '시티드 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Seated_Row_Machine.png';
        break;
      case '스미스머신 로우':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Smith_Machine_Row.png';
        break;
      case '티바 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_T-Bar_Row_Machine.png';
        break;
      case '언더그랩 랫풀다운':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Undergrab_Lat_Pulldown.png';
        break;
      case '언더그립 하이 로우 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/B_M_Undergrip_High_Low_Machine.png';
        break;
      case '백 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Back_Extension.png';
        break;
      case '친업':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Chin_Up.png';
        break;
      case '하이퍼 익스텐션':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Hyper_Extension.png';
        break;
      case '풀업':
        selectedxTypeImgpath = 'assets/img/workoutType/B_B_Pull_Up.png';
        break;
      case '복근 롤아웃':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Abs_Rollout.png';
        break;
      case '덤벨 사이드 벤드':
        selectedxTypeImgpath = 'assets/img/workoutType/A_D_Dumbbell_Side_Bend.png';
        break;
      case '중량 디클라인 싯업':
        selectedxTypeImgpath = 'assets/img/workoutType/A_D_Heavy_Decline_Sit-Up.png';
        break;
      case '중량 업도미널 힙 쓰러스트':
        selectedxTypeImgpath = 'assets/img/workoutType/A_D_Heavy_Updominal_Hip_Thrust.png';
        break;
      case '러시안 트위스트':
        selectedxTypeImgpath = 'assets/img/workoutType/A_D_Russian_Twist.png';
        break;
      case '중량 디클라인 크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_D_Weighted_Decline_Crunch.png';
        break;
      case '복근 크런치 머신':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Abdominal_Crunch_Machine.png';
        break;
      case '케이블 사이드 벤드':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Cable_Side_Bend.png';
        break;
      case '케이블 트위스트':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Cable_Twist.png';
        break;
      case '행잉 니 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Hanging_Knee_Raise.png';
        break;
      case '행잉 레그 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Hanging_Leg_Raise.png';
        break;
      case '토즈투 바':
        selectedxTypeImgpath = 'assets/img/workoutType/A_M_Tods_To_Bar.png';
        break;
      case '45도 사이드 벤드':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_45_Degree_Side_Bend.png';
        break;
      case '복근 에어 바이크':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Abs_Air_Bike.png';
        break;
      case '크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Crunch.png';
        break;
      case '디클라인 크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Crunch.png';
        break;
      case '디클라인 리버스 크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Reverse_Crunch.png';
        break;
      case '디클라인 싯업':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Sit-Up.png';
        break;
      case '힐 터치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Heel_Touch.png';
        break;
      case '할로우 포지션':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Hollow_Position.png';
        break;
      case '할로우 락':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Hollow_Rock.png';
        break;
      case '레그 레이즈':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Leg_Raise.png';
        break;
      case '필라테스 잭나이프':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Pilates_Jackknife.png';
        break;
      case '플랭크':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Plank.png';
        break;
      case '리버스 크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Reverse_Crunch.png';
        break;
      case '사이드 크런치':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Side_Crunches.png';
        break;
      case '사이드 플랭크':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Side_Plank.png';
        break;
      case '싯업':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Sit_Up.png';
        break;
      case '업도미널 힙 쓰러스트':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_Updominal_Hip_Thrust.png';
        break;
      case '브이 업':
        selectedxTypeImgpath = 'assets/img/workoutType/A_B_V_Up.png';
        break;
    }

    switch (selectedxTypeItem) {
      //영상주소입력위치
      case '바벨 글루트 브릿지':
        videoURL = 'https://youtu.be/coDVXIpfhhI';
        break;
      case '스모 데드리프트':
        videoURL = 'https://youtu.be/ZPcy5aDBbr4';
        break;
      case '바벨 백 스쿼트':
        videoURL = 'https://youtu.be/0tYihRsCHOM';
        break;
      case '바벨 불가리안 스플릿 스쿼트':
        videoURL = 'https://youtu.be/IFK5auzHY4c';
        break;
      case '바벨 프론트 스쿼트':
        videoURL = 'https://youtu.be/WRoThcAqqNI';
        break;

      case '바벨 런지':
        videoURL = 'https://youtu.be/iHWygRKZp3g';
        break;
      case '컨벤셔널 데드리프트':
        videoURL = 'https://youtu.be/lqmyZhUK30M';
        break;

      case '루마니안 데드리프트':
        videoURL = 'https://youtu.be/0toNMnclnUg';
        break;

      case '바벨 힙 쓰러스트':
        videoURL = 'https://youtu.be/5U0GW8Kohys';
        break;

      case '바벨 스플릿 스쿼트':
        videoURL = 'https://youtu.be/jgn5wz322p0';
        break;

      case '덤벨 스모 데드리프트':
        videoURL = 'https://youtu.be/2Qwpr8vUkIM';
        break;

      case '덤벨 고블릿 스쿼트':
        videoURL = 'https://youtu.be/wJWiYBE9Kc0';
        break;

      case '덤벨 스쿼트':
        videoURL = 'https://youtu.be/DpRSG07VqUU';
        break;

      case '덤벨 루마니안 데드리프트':
        videoURL = 'https://youtu.be/cwpKQJ4XvT4';
        break;

      case '덤벨 원레그 데드리프트':
        videoURL = 'https://youtu.be/Qmp606CgBMU';
        break;

      case '에어 스쿼트':
        videoURL = 'https://youtu.be/Dp2PXU7RSHs';
        break;

      case '힙 쓰러스트':
        videoURL = 'https://youtu.be/h3Y_3kH8GYU';
        break;
      case '점프 스쿼트':
        videoURL = 'https://youtu.be/xc-S57DdON8';
        break;

      case '스모 에어 스쿼트':
        videoURL = 'https://youtu.be/m2R7LTY_CMY';
        break;
      case '바벨 오버헤드 프레스':
        videoURL = 'https://youtu.be/lK3SQiEC2JE';
        break;
      case '바벨 프론트 레이즈':
        videoURL = 'https://youtu.be/Ajzr2ISl-x8';
        break;
      case '바벨 슈러그':
        videoURL = 'https://youtu.be/6cIl7Qcx61c';
        break;
      case '바벨 업라이트 로우':
        videoURL = 'https://youtu.be/iSytfNPQJhY';
        break;

      case '이지바 업라이트 로우':
        videoURL = 'https://youtu.be/cxsrYqQ4nfg';
        break;

      case '아놀드 덤벨 프레스':
        videoURL = 'https://youtu.be/kTS24mrinwk';
        break;

      case '덤벨 프론트 레이즈':
        videoURL = 'https://youtu.be/UCQGQ_QnQ5A';
        break;
      case '덤벨 레터럴 레이즈':
        videoURL = 'https://youtu.be/tI0mXXyfIYI';
        break;
      case '덤벨 숄더 프레스':
        videoURL = 'https://youtu.be/hat7My5Sdx4';
        break;

      case '벤치프레스':
        videoURL = 'https://youtu.be/ot21xT-iHLg';
        break;
      case '디클라인 벤치프레스':
        videoURL = 'https://youtu.be/UaKvRJOZEzU';
        break;
      case '인클라인 벤치프레스':
        videoURL = 'https://youtu.be/xsWYKRz2uBA';
        break;

      case '디클라인 덤벨 벤치프레스':
        videoURL = 'https://youtu.be/_Y2PEyAdoMM';
        break;
      case '디클라인 덤벨 플라이':
        videoURL = 'https://youtu.be/PFEM97UIRHo';
        break;
      case '덤벨 벤치프레스':
        videoURL = 'https://youtu.be/78trrdwb0QM';
        break;
      case '덤벨 플라이':
        videoURL = 'https://youtu.be/AtF9dS1KoyE';
        break;
      case '덤벨 풀오버':
        videoURL = 'https://youtu.be/sJ7kkU4Y59Y';
        break;
      case '덤벨 스퀴즈 프레스':
        videoURL = 'https://youtu.be/dL9errKGTos';
        break;
      case '인클라인 덤벨 벤치프레스':
        videoURL = 'https://youtu.be/1hPqxOOw0cQ';
        break;
      case '인클라인 덤벨 플라이':
        videoURL = 'https://youtu.be/n6kM4d_j-sY';
        break;

      case '딥스':
        videoURL = 'https://youtu.be/Aca7f32SWYU';
        break;

      case '푸시업':
        videoURL = 'https://youtu.be/1Ih3_2cmqgo';
        break;

      case '바벨 컬':
        videoURL = 'https://youtu.be/fcpf89fwj78';
        break;

      case '바벨 프리쳐 컬':
        videoURL = 'https://youtu.be/Rca1MXVcbxw';
        break;
      case '바벨 리스트 컬':
        videoURL = 'https://youtu.be/71LgWfyUBss';
        break;

      case '이지바 컬':
        videoURL = 'https://youtu.be/jAUbcb2kPCo';
        break;
      case '이지바 프리쳐 컬':
        videoURL = 'https://youtu.be/MuSjk76sncM';
        break;
      case '이지바 리스트 컬':
        videoURL = 'https://youtu.be/dsYYN44U4mk';
        break;
      case '리스트 롤러':
        videoURL = 'https://youtu.be/6RXLZRgWoxY';
        break;
      case '리버스 바벨 컬':
        videoURL = 'https://youtu.be/yptPNjn_Yos';
        break;
      case '리버스 바벨 리스트 컬':
        videoURL = 'https://youtu.be/AOR1OXuTryY';
        break;
      case '스컬 크러셔':
        videoURL = 'https://youtu.be/MGTeyqavy50';
        break;

      case '덤벨 킥백':
        videoURL = 'https://youtu.be/x8aNnHma5NM';
        break;
      case '덤벨 트리이셉 익스텐션':
        videoURL = 'https://youtu.be/JBgK6Preqks';
        break;

      case '인클라인 덤벨 컬':
        videoURL = 'https://youtu.be/TnZXYJa6W38';
        break;

      case '벤치 딥스':
        videoURL = 'https://youtu.be/28Bdr_SVvmw';
        break;
      case '바벨 풀오버':
        videoURL = 'https://youtu.be/hi94Tw2HuoY';
        break;
      case '바벨 로우':
        videoURL = 'https://youtu.be/ECda9GHJw4g';
        break;
      case '굿모닝 엑서사이즈':
        videoURL = 'https://youtu.be/2__DMFtag7A';
        break;

      case '덤벨 로우':
        videoURL = 'https://youtu.be/ErAy1GVVZ-M';
        break;

      case '원암 덤벨 로우':
        videoURL = 'https://youtu.be/vciXM0GnkmI';
        break;

      case '티바 로우 머신':
        videoURL = 'https://youtu.be/y1GrFDU5et4';
        break;

      case '친업':
        videoURL = 'https://youtu.be/24CixqZA-8k';
        break;
      case '하이퍼 익스텐션':
        videoURL = 'https://youtu.be/N2I6X1bwZaA';
        break;
      case '풀업':
        videoURL = 'https://youtu.be/nSUyfgWzc9M';
        break;

      case '덤벨 사이드 벤드':
        videoURL = 'https://youtu.be/u2bMCVbcQqc';
        break;

      case '행잉 니 레이즈':
        videoURL = 'https://youtu.be/XZQzqapu-DE';
        break;

      case '토즈투 바':
        videoURL = 'https://youtu.be/uGIXMOHc2Sg';
        break;

      case '복근 에어 바이크':
        videoURL = 'https://youtu.be/7k-GKzeiMmk';
        break;
      case '크런치':
        videoURL = 'https://youtu.be/G3cc4LdZwhg';
        break;

      case '레그 레이즈':
        videoURL = 'https://youtu.be/5RHqSaab9RA';
        break;

      case '리버스 크런치':
        videoURL = 'https://youtu.be/pVwPV9z8A44';
        break;
      case '사이드 크런치':
        videoURL = 'https://youtu.be/M9404UBHLSE';
        break;

      case '싯업':
        videoURL = 'https://youtu.be/HDrWX5_JSzM';
        break;
      case '업도미널 힙 쓰러스트':
        videoURL = 'https://youtu.be/uENEi455Ozo';
        break;

      //기본값
      default:
        videoURL = 'default';
        break;
    }

    //날짜 포멧을 한국어로 생성한다
    initializeDateFormatting('ko_KR');
    //오늘 날짜 비교용 코드
    DateTime todaydate = DateTime.now();

//------------------------
//2.무게 1~100까지 만들기
    for (int i = 0; i < lxweightItems.length; i++) {
      lxweightItems[i] = i; // 0부터 시작
    }
//3.횟수 1~50까지 만들기
    for (int i = 0; i < lxnumberItems.length; i++) {
      lxnumberItems[i] = i + 1;
    }
//4.세트 1~20까지 만들기
    for (int i = 0; i < lxsetItems.length; i++) {
      lxsetItems[i] = i + 1;
    }

//------------------------

    //화면 크기를 생성한다.
    var media = MediaQuery.of(context).size;
    //

    // bool isSelectedkg = true;
    // String selectedWeighUnint = 'kg';

    return FutureBuilder<List<Ximg>>(
      future: HiveHelper().readXimg(),
      builder: (context, snapshot) {
        List<Ximg> ximgs = snapshot.data ?? [];
        // 리스트를 연, 월, 일 별로 분류합니다.
        Map<int, Map<int, Map<int, List<DateTime>>>> listByYearMonthDayimg = {};
        for (int i = 0; i < ximgs.length; i++) {
          DateTime dateimg = ximgs[i].date;
          int year = dateimg.year;
          int month = dateimg.month;
          int day = dateimg.day;

          // 연도별로 맵을 생성합니다.
          if (!listByYearMonthDayimg.containsKey(year)) {
            listByYearMonthDayimg[year] = {};
          }

          // 월별로 맵을 생성합니다.
          if (!listByYearMonthDayimg[year]!.containsKey(month)) {
            listByYearMonthDayimg[year]![month] = {};
          }

          // 일별로 리스트를 생성합니다.
          if (!listByYearMonthDayimg[year]![month]!.containsKey(day)) {
            listByYearMonthDayimg[year]![month]![day] = [];
          }

          listByYearMonthDayimg[year]![month]![day]!.add(dateimg);
          // listByYearMonthDayimg[year]![month]![day]!.sort();
        }

        //오늘 생성된 목록 개수
        int todayaddimgcount = 0;

        for (int index = 0; index < ximgs.length; index += 1) {
          if (ximgs[index].date.year == todaydate.year //년 비교
                  &&
                  ximgs[index].date.month == todaydate.month //월 비교
                  &&
                  ximgs[index].date.day == todaydate.day //일 비교
              ) {
            todayaddimgcount++;

            tempximg = ximgs[index];
            tempximgindex = index;
          }
        }

        return FutureBuilder<List<Xlog>>(
          future: HiveHelper().readXlog(),
          builder: (context, snapshot) {
            List<Xlog> xlogs = snapshot.data ?? [];

            //오늘 생성된 목록 개수
            int todayaddcount = 0;
            int todayaddcountComplete = 0;
            for (int index = 0; index < xlogs.length; index += 1) {
              if (xlogs[index].lxdate.year == todaydate.year //년 비교
                      &&
                      xlogs[index].lxdate.month == todaydate.month //월 비교
                      &&
                      xlogs[index].lxdate.day == todaydate.day //일 비교
                  ) {
                todayaddcount++;
                if (xlogs[index].finished == true) {
                  todayaddcountComplete++;
                }
              }
            }

            // 1. [하체]운동목록
            // // [바벨]
            List legsBabel = [
              '바벨 글루트 브릿지',
              '스모 데드리프트',
              '바벨 백 스쿼트',
              '바벨 불가리안 스플릿 스쿼트',
              '바벨 프론트 스쿼트',
              '바벨 핵 스쿼트',
              '바벨 레터럴 런지',
              '바벨 런지',
              '컨벤셔널 데드리프트',
              '데피싯 데드리프트',
              '루마니안 데드리프트',
              '바벨 프론트 랙 런지',
              '바벨 힙 쓰러스트',
              '바벨 점프 스쿼트',
              '바벨 원레그 데드리프트',
              '바벨 스플릿 스쿼트',
              '바벨 스탠딩 카프 레이즈',
              '바벨 스모 스쿼트',
              '트랩바 데드리프트',
              '저처 스쿼트',
            ];
            // // [덤벨]
            List legsDumbbell = [
              '덤벨 레터럴 런지',
              '덤벨 스모 데드리프트',
              '덤벨 불가리안 스플릿 스쿼트',
              '덤벨 고블릿 스쿼트',
              '덤벨 런지',
              '덤벨 스쿼트',
              '덤벨 스모 스쿼트',
              '덤벨 루마니안 데드리프트',
              '덤벨 카프 레이즈',
              '덤벨 레그컬',
              '덤벨 원레그 데드리프트',
              '덤벨 스플릿 스쿼트',
              '덤벨 스티프 레그 데드리프트',
              '중량 스텝업',
            ];
            // // [머신]
            List legsMachine = [
              '글루트 킥백 머신',
              '레그 익스텐션',
              '레그 프레스',
              '레그 컬',
              '케이블 덩키 킥',
              '케이블 힙 어브덕션',
              '케이블 힙 어덕션',
              '케이블 풀 스루',
              '핵 스쿼트 머신',
              '힙 어브덕션 머신',
              '힙 쓰러스트 머신',
              '수평 레그 프레스',
              '수평 원레그 프레스',
              '이너 싸이 머신',
              '몬스터 글루트 머신',
              '원레그 컬',
              '원레그 익스텐션',
              '원레그 프레스',
              '리버스 브이 스쿼트',
              '시티드 카프 레이즈',
              '시티드 레그 컬',
              '시티드 원레그 컬',
              '스미스 머신 데드리프트',
              '스미스머신 스플릿 스쿼트',
              '스미스머신 스쿼트',
              '스탠딩 카프 레이즈',
              '브이 스쿼트',
            ];
            // // [맨몸]
            List legsBodyweight = [
              '덩키 킥',
              '런지',
              '글루트 브릿지',
              '노르딕 햄스트링 컬',
              '에어 스쿼트',
              '맨몸 카프 레이즈',
              '맨몸 레터럴 런지',
              '맨몸 원레그 데드리프트',
              '맨몸 오버헤드 스쿼트',
              '맨몸 스플릿 스쿼트',
              '힙 쓰러스트',
              '점프 스쿼트',
              '런지 트위스트',
              '라잉 힙 어브덕션',
              '피스톨 스쿼트',
              '사이드 라잉 클램',
              '싱글 레그 글루트 브릿지',
              '스텝업',
              '스모 에어 스쿼트',
            ];

            // 2. [어깨]운동목록
            // // [바벨]
            List shouldersBabel = [
              '바벨 오버헤드 프레스',
              '바벨 프론트 레이즈',
              '바벨 슈러그',
              '바벨 업라이트 로우',
              '이지바 프론트 레이즈',
              '이지바 업라이트 로우',
              '플레이트 숄더 프레스',
              '푸시 프레스',
              '시티드 바벨 숄더 프레스',
            ];
            // // [덤벨]
            List shouldersDumbbell = [
              '아놀드 덤벨 프레스',
              '벤트오버 덤벨 레터럴 레이즈',
              '덤벨 프론트 레이즈',
              '덤벨 레터럴 레이즈',
              '덤벨 숄더 프레스',
              '덤벨 슈러그',
              '덤벨 업라이트 로우',
              '덤벨 Y 레이즈',
              '시티드 덤벨 리어 레터럴 레이즈',
              '시티드 덤벨 숄더 프레스',
            ];
            // // [머신]
            List shouldersMachine = [
              '비하인드 넥 프레스',
              '케이블 익스터널 로테이션',
              '케이블 프론트 레이즈',
              '케이블 인터널 로테이션',
              '케이블 레터럴 레이즈',
              '케이블 리버스 플라이',
              '케이블 슈러그',
              '페이스풀',
              '랜드마인 프레스',
              '레터럴 레이즈 머신',
              '원암 케이블 레터럴 레이즈',
              '리어 델토이드 플라이 머신',
              '숄더 플레스 머신',
              '슈러그 머신',
              '스미스머신 오버헤드 프레스',
              '스미스머신 슈러그',
              '원암 랜드마인 프레스',
            ];
            // // [맨몸]
            List shouldersBodyweight = [
              '핸드스탠드',
              '핸드스탠드 푸시업',
              '숄더 탭',
              'Y 레이즈',
            ];

            // 3. [가슴]운동목록
            // // [바벨]
            List chestBabel = [
              '바벨 플로어 프레스',
              '벤치프레스',
              '디클라인 벤치프레스',
              '인클라인 벤치프레스',
              '스포토 벤치프레스',
            ];
            // // [덤벨]
            List chestDumbbell = [
              '디클라인 덤벨 벤치프레스',
              '디클라인 덤벨 플라이',
              '덤벨 벤치프레스',
              '덤벨 플라이',
              '덤벨 풀오버',
              '덤벨 스퀴즈 프레스',
              '인클라인 덤벨 벤치프레스',
              '인클라인 덤벨 플라이',
              '인클라인 덤벨 트위스트 프레스',
              '중량 딥스',
            ];
            // // [머신]
            List chestMachine = [
              '어시스트 딥스 머신',
              '케이블 크로스오버',
              '체스트 프레스 머신',
              '디클라인 체스트 프레스 머신',
              '해머 벤치프레스',
              '인클라인 벤치프레스 머신',
              '인클라인 케이블 플라이',
              '인클라인 체스트 프레스 머신',
              '로우 풀리 케이블 플라이',
              '펙덱 플라이 머신',
              '시티드 딥스 머신',
              '스미스머신 벤치프레스',
              '스미스머신 인클라인 벤치프레스',
              '스탠딩 케이블 플라이',
            ];
            // // [맨몸]
            List chestBodyweight = [
              '아처 푸시업',
              '클랩 푸시업',
              '클로즈그립 푸시업',
              '딥스',
              '힌두 푸시업',
              '파이크 푸시업',
              '푸시업',
              '중량 푸시업',
            ];

            // 4. [팔]운동목록
            // // [바벨]
            List armsBabel = [
              '바벨 컬',
              '바벨 라잉 트라이셉 익스텐션',
              '바벨 프리쳐 컬',
              '바벨 리스트 컬',
              '클로즈 그립 벤치프레스',
              '이지바 컬',
              '이지바 프리쳐 컬',
              '이지바 리스트 컬',
              '리스트 롤러',
              '리버스 바벨 컬',
              '리버스 바벨 리스트 컬',
              '스컬 크러셔',
            ];
            // // [덤벨]
            List armsDumbbell = [
              '뎀벨 프리쳐 컬',
              '덤벨 컬',
              '덤벨 해머 컬',
              '덤벨 킥백',
              '덤벨 트리이셉 익스텐션',
              '덤벨 리스트 컬',
              '인클라인 덤벨 컬',
              '리버스 덤벨 리스트 컬',
              '시티드 덤벨 트라이셉 익스텐션',
            ];
            // // [머신]
            List armsMachine = [
              '암 컬 머신',
              '케이블 컬',
              '케이블 해머컬',
              '케이블 라잉 트라이셉 익스텐션',
              '케이블 오버헤드 트라이셉 익스텐션',
              '케이블 푸시 다운',
              '케이블 트라이셉 익스텐션',
              '프리쳐 컬 머신',
              '트라이셉 익스텐션 머신',
            ];
            // // [맨몸]
            List armsBodyweight = [
              '벤치 딥스',
            ];

            // 5. [등]운동목록
            // // [바벨]
            List backBabel = [
              '바벨 풀오버',
              '바벨 로우',
              '굿모닝 엑서사이즈',
              '인클라인 바벨 로우',
              '라잉 바벨 로우',
              '펜들레이 로우',
              '언더그립 바벨 로우',
            ];
            // // [덤벨]
            List backDumbbell = [
              '덤벨 로우',
              '인클라인 덤벨 로우',
              '원암 덤벨 로우',
              '중량 친업',
              '중량 풀업',
            ];
            // // [머신]
            List backMachine = [
              '어시스트 풀업 머신',
              '비하인드 넥 풀다운',
              '케이블 암 풀다운',
              '플로어 시티드 케이블 로우',
              '중량 하이퍼 익스텐션',
              '하이 로우 머신',
              '인버티드 로우',
              '랫풀다운',
              '레터럴 와이드 풀다운',
              '맥그립 랫풀다운',
              '원암 케이블 풀다운',
              '원암 하이 로우 머신',
              '원암 레터럴 와이드 풀다운',
              '원암 시티드 케이블 로우',
              '원암 로우 머신',
              '패러럴그립 랫풀다운',
              '로우 머신',
              '시티드 케이블 로우',
              '시티드 로우 머신',
              '스미스머신 로우',
              '티바 로우 머신',
              '언더그랩 랫풀다운',
              '언더그립 하이 로우 머신',
            ];
            // // [맨몸]
            List backBodyweight = [
              '백 익스텐션',
              '친업',
              '하이퍼 익스텐션',
              '풀업',
            ];

            // 6. [복근]운동목록
            // // [바벨]
            List absBabel = [
              '복근 롤아웃',
            ];
            // // [덤벨]
            List absDumbbell = [
              '덤벨 사이드 벤드',
              '중량 디클라인 싯업',
              '중량 업도미널 힙 쓰러스트',
              '러시안 트위스트',
              '중량 디클라인 크런치',
            ];
            // // [머신]
            List absMachine = [
              '복근 크런치 머신',
              '케이블 사이드 벤드',
              '케이블 트위스트',
              '행잉 니 레이즈',
              '행잉 레그 레이즈',
              '토즈투 바',
            ];
            // // [맨몸]
            List absBodyweight = [
              '45도 사이드 벤드',
              '복근 에어 바이크',
              '크런치',
              '디클라인 크런치',
              '디클라인 리버스 크런치',
              '디클라인 싯업',
              '힐 터치',
              '할로우 포지션',
              '할로우 락',
              '레그 레이즈',
              '필라테스 잭나이프',
              '플랭크',
              '리버스 크런치',
              '사이드 크런치',
              '사이드 플랭크',
              '싯업',
              '업도미널 힙 쓰러스트',
              '브이 업',
            ];
            //

            return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: Stack(
                children: [
                  // 추가된 운동 목록 지우기쉽게(완료) + 위치 바꾸기(미구현)
                  (todayaddcount >= 1)
                      ? Align(
                          alignment: Alignment(Alignment.bottomCenter.x + 0.95, Alignment.bottomCenter.y),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColor.white,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Badge(
                                alignment: Alignment.topCenter,
                                label: Text('$todayaddcountComplete/$todayaddcount'),
                                backgroundColor: TColor.secondaryColor1,
                                child: FloatingActionButton.extended(
                                  heroTag: "btn3",
                                  backgroundColor: TColor.black, //TColor.secondaryColor1,
                                  elevation: 2,

                                  label: const Text('ToDo'),
                                  icon: const Icon(
                                    Icons.checklist_outlined,
                                  ),
                                  onPressed: () async {
                                    //

                                    await showModalBottomSheet(
                                      backgroundColor: TColor.white,
                                      isScrollControlled: true,
                                      enableDrag: false,
                                      // shape: const RoundedRectangleBorder(
                                      // <-- SEE HERE
                                      // borderRadius: BorderRadius.vertical(
                                      //   top: Radius.circular(25.0),
                                      // ),
                                      // ),
                                      context: context,
                                      builder: (BuildContext context) => StatefulBuilder(
                                        builder: (context, setState) => Wrap(
                                          // spacing: 60, // Add spacing between the child widgets.
                                          children: <Widget>[
                                            // Add a container with height to create some space.
                                            // Container(height: 10),
                                            // Add a text widget with a title for the sheet.
                                            Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    // const SizedBox(width: 2),
                                                    IconButton(
                                                      onPressed: () {
                                                        for (int index = 0; index < xlogs.length; index += 1) {
                                                          (

                                                                  ////둘다 dateTime 형식이므로 해당년, 월, 일 비교가 필요함
                                                                  xlogs[index].lxdate.year == todaydate.year //년 비교
                                                                      &&
                                                                      xlogs[index].lxdate.month == todaydate.month //월 비교
                                                                      &&
                                                                      xlogs[index].lxdate.day == todaydate.day //일 비교

                                                              )
                                                              ? {xlogs[index].finished = true, xlogs[index].save()}
                                                              : null;
                                                        }
                                                        setState(() {});
                                                        this.setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.library_add_check_outlined,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        for (int index = 0; index < xlogs.length; index += 1) {
                                                          (

                                                                  ////둘다 dateTime 형식이므로 해당년, 월, 일 비교가 필요함
                                                                  xlogs[index].lxdate.year == todaydate.year //년 비교
                                                                      &&
                                                                      xlogs[index].lxdate.month == todaydate.month //월 비교
                                                                      &&
                                                                      xlogs[index].lxdate.day == todaydate.day //일 비교

                                                              )
                                                              ? {
                                                                  xlogs[index].finished = false,
                                                                  xlogs[index].save(),
                                                                }
                                                              : null;
                                                        }
                                                        setState(() {});
                                                        this.setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.filter_none_rounded,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Center(
                                                    child: Text(
                                                      //"${todaydate.month}/${todaydate.day} ToDo $todayaddcountComplete($todayaddcount)",
                                                      "${todaydate.month}/${todaydate.day} ToDo",
                                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Container(height: 10), // Add some more space.

                                            // Add a text widget with a long description for the sheet.
                                            // 타일 추가할 공간
                                            SizedBox(
                                              height: media.height * 0.770,
                                              child: ListView(
                                                physics: const NeverScrollableScrollPhysics(),
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      for (int index = 0; index < xlogs.length; index += 1)
                                                        if (
                                                            ////둘다 dateTime 형식이므로 해당년, 월, 일 비교가 필요함
                                                            xlogs[index].lxdate.year == todaydate.year //년 비교
                                                                &&
                                                                xlogs[index].lxdate.month == todaydate.month //월 비교
                                                                &&
                                                                xlogs[index].lxdate.day == todaydate.day //일 비교

                                                            )
                                                          Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: todayXlogTile(
                                                              xlog: xlogs[index],
                                                              selectedweightUnit: selectedWeighUnint,
                                                              onFinished: () {
                                                                setState(() {
                                                                  if (xlogs[index].finished == true) {
                                                                    xlogs[index].finished = false;
                                                                    xlogs[index].save();
                                                                    todayaddcountComplete--;
                                                                    this.setState(() {});
                                                                  } else {
                                                                    xlogs[index].finished = true;
                                                                    xlogs[index].save();
                                                                    todayaddcountComplete++;
                                                                    this.setState(() {});
                                                                  }
                                                                });
                                                              },
                                                              onDeleted: () {
                                                                setState(() {
                                                                  xlogs.removeAt(index);
                                                                  todayaddcount--;
                                                                  todayaddcountComplete--;
                                                                  this.setState(() {});
                                                                  (todayaddcount == 0) ? Navigator.pop(context) : null;

                                                                  // (todayaddcount == 0) ? Navigator.pop(context) : Container();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Text(
                                            //   'Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.',
                                            //   style: TextStyle(
                                            //       color: Colors.grey[600], // Set the text color.
                                            //       fontSize: 18 // Set the text size.
                                            //       ),
                                            // ),
                                            //
                                            // Add some more space.
                                            // Add a row widget to display buttons for closing and reading more.

                                            Align(
                                              alignment: Alignment(Alignment.bottomCenter.x + 0.95, Alignment.bottomCenter.y),
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: TColor.white,
                                                      // spreadRadius: 3,
                                                      blurRadius: 1,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: FloatingActionButton.extended(
                                                  heroTag: "btn3",
                                                  elevation: 1,
                                                  backgroundColor: TColor.white,
                                                  label: Text(
                                                    'close',
                                                    style: TextStyle(color: TColor.black),
                                                  ),
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: TColor.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    // setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),

                  (isselectedWritting == false)
                      ? Align(
                          alignment: Alignment(Alignment.bottomCenter.x - 0.55, Alignment.bottomCenter.y),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.small(
                              heroTag: "btn2",
                              backgroundColor: TColor.white, //TColor.secondaryColor1,
                              elevation: 1,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _ratio = (_ratio + 1) % 3;
                                  });
                                },
                                child: FittedBox(
                                  child: Text(
                                    ratios[_ratio]!,
                                    style: TextStyle(
                                      color: TColor.black,
                                    ),
                                  ),
                                ),
                              ),
                              // label: const Text('add'),
                              // icon: Icon(
                              //   Icons.add,
                              //   size: iconsize + 4,
                              // ),
                              onPressed: () {
                                setState(
                                  () {
                                    if (isselectedWritting == true) {
                                      isselectedWritting = false;
                                    } else {
                                      isselectedWritting = true;
                                    }
                                    _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),

                  //
                  (isselectedWritting == false)
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              heroTag: "btn1",
                              backgroundColor: TColor.secondaryColor1, //TColor.secondaryColor1,
                              elevation: 2,
                              label: Text(
                                LocaleData.add.getString((context)),
                              ),
                              icon: const Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    if (isselectedWritting == true) {
                                      isselectedWritting = false;
                                    } else {
                                      isselectedWritting = true;
                                      //
                                      switch (_isbodypartcontroller) {
                                        case '하체':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.legs]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < legsBabel.length; i++) {
                                              exerciseList[BodyPart.legs]?.add(legsBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < legsDumbbell.length; i++) {
                                              exerciseList[BodyPart.legs]?.add(legsDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < legsMachine.length; i++) {
                                              exerciseList[BodyPart.legs]?.add(legsMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < legsBodyweight.length; i++) {
                                              exerciseList[BodyPart.legs]?.add(legsBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.legs]!;

                                          break;
                                        case '어깨':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.shoulders]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < shouldersBabel.length; i++) {
                                              exerciseList[BodyPart.shoulders]?.add(shouldersBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < shouldersDumbbell.length; i++) {
                                              exerciseList[BodyPart.shoulders]?.add(shouldersDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < shouldersMachine.length; i++) {
                                              exerciseList[BodyPart.shoulders]?.add(shouldersMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < shouldersBodyweight.length; i++) {
                                              exerciseList[BodyPart.shoulders]?.add(shouldersBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.shoulders]!;

                                          break;
                                        case '가슴':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.chest]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < chestBabel.length; i++) {
                                              exerciseList[BodyPart.chest]?.add(chestBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < chestDumbbell.length; i++) {
                                              exerciseList[BodyPart.chest]?.add(chestDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < chestMachine.length; i++) {
                                              exerciseList[BodyPart.chest]?.add(chestMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < chestBodyweight.length; i++) {
                                              exerciseList[BodyPart.chest]?.add(chestBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.chest]!;

                                          break;
                                        case '팔':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.arms]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < armsBabel.length; i++) {
                                              exerciseList[BodyPart.arms]?.add(armsBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < armsDumbbell.length; i++) {
                                              exerciseList[BodyPart.arms]?.add(armsDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < armsMachine.length; i++) {
                                              exerciseList[BodyPart.arms]?.add(armsMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < armsBodyweight.length; i++) {
                                              exerciseList[BodyPart.arms]?.add(armsBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.arms]!;

                                          break;
                                        case '등':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.back]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < backBabel.length; i++) {
                                              exerciseList[BodyPart.back]?.add(backBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < backDumbbell.length; i++) {
                                              exerciseList[BodyPart.back]?.add(backDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < backMachine.length; i++) {
                                              exerciseList[BodyPart.back]?.add(backMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < backBodyweight.length; i++) {
                                              exerciseList[BodyPart.back]?.add(backBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.back]!;

                                          break;
                                        case '복근':
                                          //필터 확인 후 운동 추가
                                          //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                          exerciseList[BodyPart.abs]?.clear();
                                          //[바벨]필터
                                          if (isSelectedBabel == true) {
                                            for (int i = 0; i < absBabel.length; i++) {
                                              exerciseList[BodyPart.abs]?.add(absBabel[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedDumbbell == true) {
                                            for (int i = 0; i < absDumbbell.length; i++) {
                                              exerciseList[BodyPart.abs]?.add(absDumbbell[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedMachine == true) {
                                            for (int i = 0; i < absMachine.length; i++) {
                                              exerciseList[BodyPart.abs]?.add(absMachine[i]);
                                            }
                                          }
                                          //[덤벨]필터
                                          if (isSelectedBodyweight == true) {
                                            for (int i = 0; i < absBodyweight.length; i++) {
                                              exerciseList[BodyPart.abs]?.add(absBodyweight[i]);
                                            }
                                          }
                                          //
                                          exerciseItems = exerciseList[BodyPart.abs]!;

                                          break;
                                      }

                                      if (selectedxTypeIndex > exerciseItems.length - 1) {
                                        selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                        selectedxTypeIndex = exerciseItems.length - 1;
                                      } else {
                                        selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                      }
                                      //
                                    }

                                    _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              heroTag: "btn1",
                              elevation: 1,
                              backgroundColor: TColor.white,
                              label: Text(
                                'close',
                                style: TextStyle(color: TColor.black),
                              ),
                              icon: Icon(
                                Icons.close,
                                color: TColor.black,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    if (isselectedWritting == true) {
                                      isselectedWritting = false;
                                    } else {
                                      isselectedWritting = true;
                                    }
                                    _scrollController.animateTo(
                                      _scrollController.position.minScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
              backgroundColor: TColor.white,
              body: SingleChildScrollView(
                physics: (isselectedWritting == false)
                    ? const NeverScrollableScrollPhysics()
                    : //const ScrollPhysics(),
                    // const ClampingScrollPhysics(),
                    const NeverScrollableScrollPhysics(), //스크롤 불가
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: FittedBox(
                            child: Text(
                              '  $xlogcreateviewtitle',
                              style: TextStyle(color: xlogcreateviewtitlecolor, fontSize: xlogcreateviewtitlefontSize, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton2(
                                customButton: const Icon(Icons.language, size: 22),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 500,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: TColor.white,
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all<double>(6),
                                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "en",
                                    child: Text("English"),
                                  ),
                                  DropdownMenuItem(
                                    value: "de",
                                    child: Text("German"),
                                  ),
                                  DropdownMenuItem(
                                    value: "ko",
                                    child: Text("Korean"),
                                  ),
                                  // DropdownMenuItem(
                                  //   value: "ja",
                                  //   child: Text("Japanese"),
                                  // ),
                                  // DropdownMenuItem(
                                  //   value: "es",
                                  //   child: Text("Spanish"),
                                  // ),
                                  // DropdownMenuItem(
                                  //   value: "zh",
                                  //   child: Text("Chinese"),
                                  // ),
                                  // DropdownMenuItem(
                                  //   value: "pt",
                                  //   child: Text("Portuguese"),
                                  // ),
                                  // DropdownMenuItem(
                                  //   value: "ar",
                                  //   child: Text("Arabic"),
                                  // ),
                                  // DropdownMenuItem(
                                  //   value: "hi",
                                  //   child: Text("Hindi"),
                                  // ),
                                ],
                                onChanged: (value) {
                                  _setLocale(value);
                                },
                              ),
                            ),
                            FlutterSwitch(
                              width: flutterswitchwidth,
                              height: flutterswitcheight,
                              showOnOff: true,
                              activeColor: TColor.black,
                              // activeTextColor: TColor.white,
                              activeText: activeText,
                              // inactiveTextColor: TColor.black,
                              inactiveText: inactiveText,
                              valueFontSize: valueFontSize,
                              value: isselectedlog,
                              onToggle: (val) async {
                                //광고 추가
                                val = true;
                                if (isselectedlog == val) {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          Container(height: media.height * 0.125),
                                          RoundButton(
                                              type: RoundButtonType.textGradient,
                                              onPressed: () {
                                                _showRewardedInterstitialAd();
                                                setState(() {});
                                              },
                                              title: '광고보기'),
                                          Container(height: 8),
                                          RoundButton(
                                              type: RoundButtonType.textGradient,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: '돌아가기'),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  isselectedlog = true;
                                  setState(() {});
                                }
                              },
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => XlogXimgDateCalendarView(
                                              xlogs: xlogs,
                                              ximgs: ximgs,
                                            ))).then((value) {
                                  _update();
                                });
                              }),
                              icon: Icon(
                                Icons.date_range_rounded,
                                color: TColor.black,
                              ),
                            ),
                            IconButton(
                                onPressed: (() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingView())).then((value) {
                                    _update();
                                  });
                                }),
                                icon: Icon(
                                  Icons.settings,
                                  color: TColor.black,
                                )),
                          ],
                        )
                      ],
                    ),

                    //002. photo view zone
                    Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.black,
                        height: media.width * ratiosMultiply[_ratio]!,
                        width: media.width * 1.00,
                        child: Stack(alignment: Alignment.center, children: [
                          if (todayaddimgcount > 0)
                            for (int index = 0; index < ximgs.length; index += 1)
                              if (ximgs[index].date.year == todaydate.year //년 비교
                                      &&
                                      ximgs[index].date.month == todaydate.month //월 비교
                                      &&
                                      ximgs[index].date.day == todaydate.day //일 비교
                                  )
                                XimgSavedTile(
                                  ximg: ximgs[index],
                                  height: ratiosMultiply[_ratio]!,
                                  onDeleted: () {
                                    setState(() {
                                      ximgs.removeAt(index);
                                      todayaddimgcount--;
                                    });
                                  },
                                ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(color: TColor.black.withOpacity(0.25), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: FittedBox(
                                  child: ((_timeformat % 3) + 1 == 1)
                                      ? TimerBuilder.periodic((const Duration(seconds: 1)),
                                          builder: (context) => Text(
                                                DateFormat(' M/ d E \n a hh:mm:ss ').format(DateTime.now()),
                                                style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                              ))
                                      : ((_timeformat % 3) + 1 == 2)
                                          ? TimerBuilder.periodic((const Duration(minutes: 1)),
                                              builder: (context) => Text(
                                                    DateFormat(' M/ d E \n a hh:mm').format(DateTime.now()),
                                                    style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                                  ))
                                          : TimerBuilder.periodic((const Duration(days: 1)),
                                              builder: (context) => Text(
                                                    DateFormat(' M/ d E ').format(DateTime.now()),
                                                    style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                                  )), //((_timeformat%3)+1==3)일 때
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isselectedlog)
                                      Container(
                                        decoration: BoxDecoration(color: TColor.black.withOpacity(0.25), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        child: FittedBox(
                                          child: Text(
                                            ' $logotitle ',
                                            style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  for (int index = 0; index < xlogs.length; index += 1)
                                    if (

                                        ////둘다 dateTime 형식이므로 해당년, 월, 일 비교가 필요함
                                        xlogs[index].lxdate.year == todaydate.year //년 비교
                                            &&
                                            xlogs[index].lxdate.month == todaydate.month //월 비교
                                            &&
                                            xlogs[index].lxdate.day == todaydate.day //일 비교

                                        )
                                      XlogCreateTile(
                                        xlog: xlogs[index],
                                        selectedweightUnit: selectedWeighUnint,
                                        onDeleted: () {
                                          setState(() {
                                            xlogs.removeAt(index);
                                            todayaddcount--;
                                            todayaddcountComplete--;
                                          });
                                        },
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),

                    //003. photo edit tools
                    Container(
                      color: Theme.of(context).canvasColor,
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isselectedWritting == true) //기록중이라면 사진앨범,카메라,이미지비율조정 버튼 비활성화(안보임)
                              ? (videoURL == 'default')
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 4),
                                      child: Container(
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: FittedBox(
                                          child: SizedBox(
                                            height: 48,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: TColor.primarygray.withOpacity(0.1),
                                                elevation: 0,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20), topRight: Radius.circular(20),
                                                    //  bottomLeft:, bottom left
                                                    // bottomRight: bottom right
                                                  ),
                                                ),
                                                side: BorderSide(width: 2.0, color: TColor.black),
                                              ),
                                              onPressed: () async {
                                                // 인터넷 연결상태인지 확인 한 후에 바꾸기

                                                var connectivityResult = await (Connectivity().checkConnectivity());

                                                if (isSelectedYoutube == true) {
                                                  isSelectedYoutube = false;
                                                  setState(() {
                                                    //
                                                  });
                                                } else {
                                                  if (connectivityResult == ConnectivityResult.mobile) {
                                                    // I am connected to a mobile network.
                                                    // print('I am connected to a mobile network.');
                                                    //
                                                    isSelectedYoutube = true;
                                                    setState(() {
                                                      //
                                                    });
                                                  } else if (connectivityResult == ConnectivityResult.wifi) {
                                                    // I am connected to a wifi network.
                                                    // print('I am connected to a wifi network.');
                                                    //
                                                    isSelectedYoutube = true;
                                                    setState(() {
                                                      //
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: "❗인터넷 연결을 확인해보세요❗",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.TOP,
                                                      backgroundColor: TColor.black,
                                                      textColor: TColor.white,
                                                    );
                                                  }
                                                }
                                              },
                                              child: (isSelectedYoutube == true)
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          // Icons.play_arrow_rounded,
                                                          Icons.cached_rounded,
                                                          color: TColor.black,
                                                        ),
                                                        Text(
                                                          ' Workout',
                                                          style: TextStyle(color: TColor.black),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(
                                                      width: 87,
                                                      child: Image.asset(
                                                        'assets/img/yt_logo_mono_light.png',
                                                        scale: 0.1,
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          AppImagePicker(source: ImageSource.gallery).pick(
                                            onPick: (File? image) {
                                              Uint8List bytes;
                                              Uint8List uint8List;

                                              (image != null)
                                                  ? {
                                                      // 파일의 내용 읽기
                                                      bytes = image.readAsBytesSync(),
                                                      // `Uint8List`로 변환
                                                      uint8List = Uint8List.fromList(bytes),
                                                      imageProvider.changeImage(image),
                                                      if (ximgs.isEmpty)
                                                        {
                                                          HiveHelper().createXimg(
                                                            Ximg(
                                                              date: todaydate.subtract(const Duration(days: 0)), //1:어제날짜, 테스트할때 첫번째 사진은 이부분에서 들어감
                                                              image: uint8List,
                                                            ),
                                                          ),
                                                          setState(() {
                                                            todayaddimgcount++; //테스트일때 주석
                                                          }),
                                                          // print("1비어있음 오늘날짜 이미지 개수는  $todayaddimgcount"),
                                                        }
                                                      else
                                                        {
                                                          if (todayaddimgcount > 0)
                                                            {
                                                              tempximg.image = uint8List,
                                                              HiveHelper().updateXimg(tempximgindex, tempximg),
                                                              setState(() {}),
                                                              // print("2기존이미지있음 오늘날짜 이미지가 이미 있어 교체합니다.  $todayaddimgcount"),
                                                            }
                                                          else
                                                            {
                                                              HiveHelper().createXimg(
                                                                Ximg(
                                                                  date: todaydate.subtract(const Duration(days: 0)), //1:어제날짜 테스트할때, 과거사진이 있으면 이부분을 수정해서 넣어줘야함
                                                                  image: uint8List,
                                                                ),
                                                              ),
                                                              setState(() {
                                                                todayaddimgcount++; //테스트할때 주석,
                                                              }),
                                                              // print("3기존이미지있음 오늘날짜 이미지가 없어 새로 생성합니다.   $todayaddimgcount"),
                                                            }
                                                        }
                                                    }
                                                  : null;
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.photo_outlined,
                                          color: TColor.black,
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        AppImagePicker(source: ImageSource.camera).pick(onPick: (File? image) {
                                          Uint8List bytes;
                                          Uint8List uint8List;

                                          (image != null)
                                              ? {
                                                  // 파일의 내용 읽기
                                                  bytes = image.readAsBytesSync(),
                                                  // `Uint8List`로 변환
                                                  uint8List = Uint8List.fromList(bytes),
                                                  imageProvider.changeImage(image),
                                                  //이미지 저장
                                                  if (ximgs.isEmpty)
                                                    {
                                                      HiveHelper().createXimg(
                                                        Ximg(
                                                          date: todaydate,
                                                          image: uint8List,
                                                        ),
                                                      ),
                                                      setState(() {
                                                        todayaddimgcount++;
                                                      }),
                                                      // print("1비어있음 오늘날짜 이미지 개수는  $todayaddimgcount"),
                                                    }
                                                  else
                                                    {
                                                      if (todayaddimgcount > 0)
                                                        {
                                                          tempximg.image = uint8List,
                                                          HiveHelper().updateXimg(tempximgindex, tempximg),
                                                          setState(() {}),
                                                          // print("2기존이미지있음 오늘날짜 이미지가 이미 있어 교체합니다.  $todayaddimgcount"),
                                                        }
                                                      else
                                                        {
                                                          HiveHelper().createXimg(
                                                            Ximg(
                                                              date: todaydate,
                                                              image: uint8List,
                                                            ),
                                                          ),
                                                          setState(() {
                                                            todayaddimgcount++;
                                                          }),
                                                          // print("3기존이미지있음 오늘날짜 이미지가 없어 새로 생성합니다.   $todayaddimgcount"),
                                                        }
                                                    }
                                                }
                                              : null;
                                          // Navigator.of(context).pushReplacementNamed('/');
                                        });
                                      },
                                      icon: Icon(
                                        Icons.camera_alt_outlined,
                                        color: TColor.black,
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _timeformat++;
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.timer,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 6,
                                            right: 6,
                                            child: Text(
                                              "${_timeformat % 3 + 1}",
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isSelectedkg == true) {
                                      isSelectedkg = false;
                                      selectedWeighUnint = 'lb';
                                    } else {
                                      isSelectedkg = true;
                                      selectedWeighUnint = 'kg';
                                    }
                                  });
                                },
                                icon: Image.asset(
                                  (isSelectedkg == true) ? 'assets/img/weight_kg.png' : 'assets/img/weight_lb.png',
                                  scale: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
                                child: Container(
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    // gradient:
                                    //     LinearGradient(colors: TColor.secondaryG),
                                    borderRadius: BorderRadius.only(
                                      // topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // 위젯이미지 캡처 및 공유
                                      IconButton(
                                          onPressed: () async {
                                            final screenshotimage = await screenshotController.capture(); //화면캡쳐 및 공유

                                            // 이미지 저장 버튼
                                            if (screenshotimage == null) return;
                                            saveAndShare(screenshotimage);
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            color: TColor.white,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            showToastMessage("저장 중!! ⏳");
                                            final screenshotimage = await screenshotController.capture();
                                            if (screenshotimage == null) return;

                                            await saveImage(screenshotimage);

                                            showToastMessage("저장 성공 😘");
                                          },
                                          icon: Icon(
                                            Icons.download_rounded,
                                            color: TColor.white,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    (isselectedWritting == false)
                        ? Container(
                            height: media.height * 0.9,
                            color: TColor.white,
                          )
                        : Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 0.2,
                                width: media.width * 0.98,
                                decoration: BoxDecoration(
                                  color: TColor.primarygray.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 8),
                              //이미지 자료 추가영역
                              Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.zero,
                                    padding: EdgeInsets.zero,
                                    color: TColor.white,
                                    height: media.width / 16 * 9, //이미지의 1400*800
                                    width: media.width,
                                    child:
                                        // 이미지
                                        (isSelectedYoutube == false)
                                            ? Image.asset(
                                                selectedxTypeImgpath,
                                                height: media.width / 16 * 9, //이미지의 비율이 1400*800
                                                width: media.width,
                                                fit: BoxFit.contain,
                                              )
                                            :
                                            //유튜브

                                            CustomYoutubePlayer(videoURL: videoURL),
                                  ),
                                  SizedBox(
                                    //유튜브를 가져오면 위아래 검은줄을 안보이도록 하는 프레임
                                    height: media.width / 16 * 9, //이미지의 1400*800
                                    width: media.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 1.2,
                                          color: TColor.white,
                                        ),
                                        Container(
                                          height: 1.2,
                                          color: TColor.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              // 장비에 따라서 하체 운동 추가
                              const SizedBox(height: 8),
                              // 004. Exercise part selection tab
                              SizedBox(
                                height: bodypartselectzoneheight,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 4),
                                      for (final bodyPart in BodyPart.values)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            width: bodypartbuttonwidth,
                                            height: bodypartbuttonheight,
                                            child: RoundButton(
                                              title: " ${bodyPart.koreanName}",
                                              type: (_isbodypartcontroller == bodyPart.koreanName) ? RoundButtonType.bgSGradient : RoundButtonType.textGradient,
                                              fontSize: bodypartbuttonfontSize,
                                              fontWeight: FontWeight.w700,
                                              onPressed: () {
                                                setState(() {
                                                  //Adjust the controller to the selected bodyPart
                                                  _isbodypartcontroller = bodyPart.koreanName;

                                                  switch (_isbodypartcontroller) {
                                                    case '하체':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.legs]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < legsBabel.length; i++) {
                                                          exerciseList[BodyPart.legs]?.add(legsBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < legsDumbbell.length; i++) {
                                                          exerciseList[BodyPart.legs]?.add(legsDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < legsMachine.length; i++) {
                                                          exerciseList[BodyPart.legs]?.add(legsMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < legsBodyweight.length; i++) {
                                                          exerciseList[BodyPart.legs]?.add(legsBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.legs]!;

                                                      break;
                                                    case '어깨':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.shoulders]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < shouldersBabel.length; i++) {
                                                          exerciseList[BodyPart.shoulders]?.add(shouldersBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < shouldersDumbbell.length; i++) {
                                                          exerciseList[BodyPart.shoulders]?.add(shouldersDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < shouldersMachine.length; i++) {
                                                          exerciseList[BodyPart.shoulders]?.add(shouldersMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < shouldersBodyweight.length; i++) {
                                                          exerciseList[BodyPart.shoulders]?.add(shouldersBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.shoulders]!;

                                                      break;
                                                    case '가슴':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.chest]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < chestBabel.length; i++) {
                                                          exerciseList[BodyPart.chest]?.add(chestBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < chestDumbbell.length; i++) {
                                                          exerciseList[BodyPart.chest]?.add(chestDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < chestMachine.length; i++) {
                                                          exerciseList[BodyPart.chest]?.add(chestMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < chestBodyweight.length; i++) {
                                                          exerciseList[BodyPart.chest]?.add(chestBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.chest]!;

                                                      break;
                                                    case '팔':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.arms]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < armsBabel.length; i++) {
                                                          exerciseList[BodyPart.arms]?.add(armsBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < armsDumbbell.length; i++) {
                                                          exerciseList[BodyPart.arms]?.add(armsDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < armsMachine.length; i++) {
                                                          exerciseList[BodyPart.arms]?.add(armsMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < armsBodyweight.length; i++) {
                                                          exerciseList[BodyPart.arms]?.add(armsBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.arms]!;

                                                      break;
                                                    case '등':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.back]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < backBabel.length; i++) {
                                                          exerciseList[BodyPart.back]?.add(backBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < backDumbbell.length; i++) {
                                                          exerciseList[BodyPart.back]?.add(backDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < backMachine.length; i++) {
                                                          exerciseList[BodyPart.back]?.add(backMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < backBodyweight.length; i++) {
                                                          exerciseList[BodyPart.back]?.add(backBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.back]!;

                                                      break;
                                                    case '복근':
                                                      //필터 확인 후 운동 추가
                                                      //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
                                                      exerciseList[BodyPart.abs]?.clear();
                                                      //[바벨]필터
                                                      if (isSelectedBabel == true) {
                                                        for (int i = 0; i < absBabel.length; i++) {
                                                          exerciseList[BodyPart.abs]?.add(absBabel[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedDumbbell == true) {
                                                        for (int i = 0; i < absDumbbell.length; i++) {
                                                          exerciseList[BodyPart.abs]?.add(absDumbbell[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedMachine == true) {
                                                        for (int i = 0; i < absMachine.length; i++) {
                                                          exerciseList[BodyPart.abs]?.add(absMachine[i]);
                                                        }
                                                      }
                                                      //[덤벨]필터
                                                      if (isSelectedBodyweight == true) {
                                                        for (int i = 0; i < absBodyweight.length; i++) {
                                                          exerciseList[BodyPart.abs]?.add(absBodyweight[i]);
                                                        }
                                                      }
                                                      //
                                                      exerciseItems = exerciseList[BodyPart.abs]!;

                                                      break;
                                                  }

                                                  if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                    selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                    selectedxTypeIndex = exerciseItems.length - 1;
                                                  } else {
                                                    selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 005. Easy workout dial selector
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //1. exercise
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: (media.width * selectedXtypewidth),
                                              height: 50,
                                            ),

                                            SizedBox(
                                              height: cupertinoPickerHeight,
                                              width: media.width * selectedXtypewidth,
                                              child: Builder(builder: (context) {
                                                return CupertinoPicker(
                                                  // hasSuitableHapticHardware = false로 내부 위젯 수정
                                                  looping: false,
                                                  //처음나오는 운동으로 변경 필요
                                                  scrollController: FixedExtentScrollController(initialItem: selectedxTypeIndex),
                                                  selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                    background: cupertinoPickercolor,
                                                  ),
                                                  //Specify the height of lxsetItem
                                                  itemExtent: cupertinoPickeritemExtent,
                                                  //Enter a list of exerciseItems to select

                                                  children: List.generate(
                                                    exerciseItems.length,
                                                    (xTypeIndex) {
                                                      final isSelected = this.xTypeIndex == xTypeIndex;
                                                      final lxsetItem = exerciseItems[xTypeIndex];

                                                      final color = isSelected ? TColor.black : TColor.primarygray;

                                                      return Center(
                                                        child: FittedBox(
                                                          child: Text(
                                                            lxsetItem,
                                                            style: TextStyle(color: color, fontSize: 20),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),

                                                  onSelectedItemChanged: (xTypeIndex) async {
                                                    setState(
                                                      () {
                                                        this.xTypeIndex = xTypeIndex;
                                                        if (isSelectedYoutube == true) {
                                                          isSelectedYoutube = false;
                                                        }
                                                      },
                                                    );

                                                    final lxsetItem = exerciseItems[xTypeIndex];

                                                    selectedxTypeItem = lxsetItem;
                                                    selectedxTypeIndex = xTypeIndex;

                                                    // debugPrint(lxsetItem);
                                                  },
                                                );
                                              }),
                                            ),
                                            // SizedBox(height: logbottomHeight)
                                          ],
                                        ),

                                        //2. input weight when exercising---------------------------
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: logheightmargin,
                                              width: media.width * selectedXweight,
                                            ),
                                            SizedBox(
                                              height: cupertinoPickerHeight,
                                              width: media.width * selectedXweight,
                                              child: CupertinoPicker(
                                                looping: false,
                                                scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxweightItems)),
                                                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                  background: cupertinoPickercolor,
                                                ),
                                                //Specify the height of lxsetItem
                                                itemExtent: cupertinoPickeritemExtent,
                                                //Enter a list of lxweightItems to select

                                                children: List.generate(lxweightItems.length, (lxweightIndex) {
                                                  final isSelected = this.lxweightIndex == lxweightIndex;
                                                  final lxsetItem = lxweightItems[lxweightIndex];
                                                  final color = isSelected ? TColor.black : TColor.primarygray;

                                                  return Center(
                                                    child: FittedBox(
                                                      child: Text(
                                                        '${lxsetItem * 0.5}',
                                                        style: TextStyle(color: color, fontSize: 20),
                                                      ),
                                                    ),
                                                  );
                                                }),

                                                onSelectedItemChanged: (lxweightIndex) {
                                                  setState(() => this.lxweightIndex = lxweightIndex);

                                                  final lxsetItem = lxweightItems[lxweightIndex];

                                                  selectedlxweightItems = '$lxsetItem';
                                                },
                                              ),
                                            ),
                                            // SizedBox(height: logbottomHeight)
                                          ],
                                        ),

                                        //3. Number of repetitions per exercise---------------------
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: logheightmargin,
                                              width: media.width * selectedXnumber,
                                            ),
                                            SizedBox(
                                              height: cupertinoPickerHeight,
                                              width: media.width * selectedXnumber,
                                              child: CupertinoPicker(
                                                looping: false,
                                                scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxnumberItem) - 1),
                                                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                  background: cupertinoPickercolor,
                                                ),
                                                //Specify the height of lxsetItem
                                                itemExtent: cupertinoPickeritemExtent,
                                                //Enter a list of lxnumberItems to select

                                                children: List.generate(lxnumberItems.length, (lxnumberIndex) {
                                                  final isSelected = this.lxnumberIndex == lxnumberIndex;
                                                  final lxsetItem = lxnumberItems[lxnumberIndex];
                                                  final color = isSelected ? TColor.black : TColor.primarygray;

                                                  return Center(
                                                    child: FittedBox(
                                                      child: Text(
                                                        '$lxsetItem',
                                                        style: TextStyle(color: color, fontSize: 20),
                                                      ),
                                                    ),
                                                  );
                                                }),

                                                onSelectedItemChanged: (lxnumberIndex) {
                                                  setState(() => this.lxnumberIndex = lxnumberIndex);

                                                  final lxsetItem = lxnumberItems[lxnumberIndex];

                                                  selectedlxnumberItem = '$lxsetItem';
                                                },
                                              ),
                                            ),
                                            // SizedBox(height: logbottomHeight)
                                          ],
                                        ),

                                        //4. input number of sets-----------------------------------
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: logheightmargin,
                                                  width: media.width * selectedXset,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: cupertinoPickerHeight,
                                              width: media.width * selectedXset,
                                              child: CupertinoPicker(
                                                looping: false,
                                                scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxsetItem) - 1),
                                                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                  background: cupertinoPickercolor,
                                                ),
                                                //Specify the height of lxsetItem
                                                itemExtent: cupertinoPickeritemExtent,
                                                //Enter a list of lxsetItems to select

                                                children: List.generate(lxsetItems.length, (lxsetIndex) {
                                                  final isSelected = this.lxsetIndex == lxsetIndex;
                                                  final lxsetItem = lxsetItems[lxsetIndex];
                                                  final color = isSelected ? TColor.black : TColor.primarygray;

                                                  return Center(
                                                    child: FittedBox(
                                                      child: Text(
                                                        "$lxsetItem",
                                                        style: TextStyle(color: color, fontSize: 20),
                                                      ),
                                                    ),
                                                  );
                                                }),

                                                onSelectedItemChanged: (lxsetIndex) {
                                                  setState(() => this.lxsetIndex = lxsetIndex);

                                                  final lxsetItem = lxsetItems[lxsetIndex];

                                                  selectedlxsetItem = '$lxsetItem';
                                                },
                                              ),
                                            ),
                                            // SizedBox(height: logbottomHeight)
                                          ],
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    height: addXlogoutlinebuttonheight,
                                    width: media.width * addXlogoutlinebuttonwidth,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(width: 1.0, color: TColor.secondaryColor1),
                                        backgroundColor: TColor.secondaryColor1,
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        if (todayaddcount < 15) {
                                          setState(
                                            () {
                                              HiveHelper().createXlog(
                                                Xlog(
                                                  finished: true,
                                                  lxdate:
                                                      // todaydate //지금시간 넣기

                                                      todaydate.subtract(const Duration(days: 0)) //1:어제날짜 //테스트,
                                                  ,
                                                  xbodypart: _isbodypartcontroller,
                                                  xType: selectedxTypeItem,
                                                  lxweight: double.parse(selectedlxweightItems),
                                                  lxweightUnit: selectedWeighUnint,
                                                  lxnumber: int.parse(selectedlxnumberItem),
                                                  lxset: int.parse(selectedlxsetItem),
                                                ),
                                              );
                                              //
                                              todayaddcount++;
                                            },
                                          );
                                        } else {
                                          showToastMessage("등록가능 최대개수 15개를 넘었어요! 대단해요👍");
                                        }
                                      },
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // 추가 버튼
                                            // //운동종류
                                            Container(
                                              width: (media.width * selectedXtypewidth),
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                child: Text(
                                                  selectedxTypeItem,
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: logTextSizeselected,
                                                    fontWeight: logTextFontselectedWeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // //운동 중량
                                            Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerRight,
                                                  height: logheightmargin,
                                                  width: media.width * selectedXweight - selectedXweightUnit,
                                                  child: Text(
                                                    (selectedlxweightItems == '0') ? ' ' : '${int.parse(selectedlxweightItems) * 0.5}',
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSizeselected,
                                                      fontWeight: logTextFontselectedWeight,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: selectedXweightUnit,
                                                  child: Text(
                                                    (selectedlxweightItems == '0') ? ' ' : selectedWeighUnint,
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSize,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // //운동횟수
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: media.width * selectedXnumber - selectedXnumberUnit,
                                                  child: Text(
                                                    selectedlxnumberItem,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSizeselected,
                                                      fontWeight: logTextFontselectedWeight,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: selectedXnumberUnit,
                                                  child: Text(
                                                    '회',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSize,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // //운동세트수
                                            Row(
                                              children: [
                                                Container(
                                                  height: logheightmargin,
                                                  alignment: Alignment.centerRight,
                                                  width: media.width * selectedXset - selectedXsetUnit,
                                                  child: Text(
                                                    selectedlxsetItem,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSizeselected,
                                                      fontWeight: logTextFontselectedWeight,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: selectedXsetUnit,
                                                  child: Text(
                                                    '세트',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: logTextSize,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 기록추가부분
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 2.0),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       color: TColor.secondaryColor1,
                                  //       borderRadius: const BorderRadius.only(
                                  //         topLeft: Radius.circular(4),
                                  //         bottomLeft: Radius.circular(4),
                                  //       ),
                                  //     ),
                                  //     height: 50,
                                  //     width: media.width * 0.03,
                                  //     child: FittedBox(
                                  //       child: Icon(
                                  //         Icons.add,
                                  //         color: TColor.white,
                                  //         size: 36,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 8),
                                  SizedBox(
                                    height: 36,
                                    width: media.width * selectedXtypewidth,
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 2),
                                          Icon(
                                            Icons.filter_alt,
                                            size: 16,
                                            color: TColor.secondarygray,
                                          ),
                                          SizedBox(
                                            width: media.width * selectedXtypewidth - 20,
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (isSelectedBabel == true) {
                                                      if (isSelectedDumbbell == false && isSelectedMachine == false && isSelectedBodyweight == false) {
                                                        showToastMessage('1가지 이상 선택해주세요~');
                                                      } else {
                                                        isSelectedBabel = false;
                                                        //
                                                        bodyexerciseListUpdate(
                                                          legsBabel,
                                                          legsDumbbell,
                                                          legsMachine,
                                                          legsBodyweight,
                                                          shouldersBabel,
                                                          shouldersDumbbell,
                                                          shouldersMachine,
                                                          shouldersBodyweight,
                                                          chestBabel,
                                                          chestDumbbell,
                                                          chestMachine,
                                                          chestBodyweight,
                                                          armsBabel,
                                                          armsDumbbell,
                                                          armsMachine,
                                                          armsBodyweight,
                                                          backBabel,
                                                          backDumbbell,
                                                          backMachine,
                                                          backBodyweight,
                                                          absBabel,
                                                          absDumbbell,
                                                          absMachine,
                                                          absBodyweight,
                                                        );
                                                        if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                          selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                          selectedxTypeIndex = exerciseItems.length - 1;
                                                        } else {
                                                          selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                        }
                                                        //
                                                      }
                                                    } else {
                                                      isSelectedBabel = true;
                                                      //
                                                      bodyexerciseListUpdate(
                                                        legsBabel,
                                                        legsDumbbell,
                                                        legsMachine,
                                                        legsBodyweight,
                                                        shouldersBabel,
                                                        shouldersDumbbell,
                                                        shouldersMachine,
                                                        shouldersBodyweight,
                                                        chestBabel,
                                                        chestDumbbell,
                                                        chestMachine,
                                                        chestBodyweight,
                                                        armsBabel,
                                                        armsDumbbell,
                                                        armsMachine,
                                                        armsBodyweight,
                                                        backBabel,
                                                        backDumbbell,
                                                        backMachine,
                                                        backBodyweight,
                                                        absBabel,
                                                        absDumbbell,
                                                        absMachine,
                                                        absBodyweight,
                                                      );
                                                      if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                        selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                        selectedxTypeIndex = exerciseItems.length - 1;
                                                      } else {
                                                        selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                      }
                                                      //
                                                    }
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: (isSelectedBabel == true) ? BorderSide(width: 2.0, color: TColor.black) : null,
                                                  backgroundColor: (isSelectedBabel == true) ? TColor.primarygray.withOpacity(0.1) : null,
                                                  minimumSize: Size.zero,
                                                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Text(
                                                  '바벨',
                                                  style: TextStyle(fontSize: 14, color: TColor.black),
                                                ),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (isSelectedDumbbell == true) {
                                                      if (isSelectedBabel == false && isSelectedMachine == false && isSelectedBodyweight == false) {
                                                        showToastMessage('1가지 이상 선택해주세요~');
                                                      } else {
                                                        isSelectedDumbbell = false;
                                                        //
                                                        bodyexerciseListUpdate(
                                                          legsBabel,
                                                          legsDumbbell,
                                                          legsMachine,
                                                          legsBodyweight,
                                                          shouldersBabel,
                                                          shouldersDumbbell,
                                                          shouldersMachine,
                                                          shouldersBodyweight,
                                                          chestBabel,
                                                          chestDumbbell,
                                                          chestMachine,
                                                          chestBodyweight,
                                                          armsBabel,
                                                          armsDumbbell,
                                                          armsMachine,
                                                          armsBodyweight,
                                                          backBabel,
                                                          backDumbbell,
                                                          backMachine,
                                                          backBodyweight,
                                                          absBabel,
                                                          absDumbbell,
                                                          absMachine,
                                                          absBodyweight,
                                                        );
                                                        if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                          selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                          selectedxTypeIndex = exerciseItems.length - 1;
                                                        } else {
                                                          selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                        }
                                                        //
                                                      }
                                                    } else {
                                                      isSelectedDumbbell = true;
                                                      //
                                                      bodyexerciseListUpdate(
                                                        legsBabel,
                                                        legsDumbbell,
                                                        legsMachine,
                                                        legsBodyweight,
                                                        shouldersBabel,
                                                        shouldersDumbbell,
                                                        shouldersMachine,
                                                        shouldersBodyweight,
                                                        chestBabel,
                                                        chestDumbbell,
                                                        chestMachine,
                                                        chestBodyweight,
                                                        armsBabel,
                                                        armsDumbbell,
                                                        armsMachine,
                                                        armsBodyweight,
                                                        backBabel,
                                                        backDumbbell,
                                                        backMachine,
                                                        backBodyweight,
                                                        absBabel,
                                                        absDumbbell,
                                                        absMachine,
                                                        absBodyweight,
                                                      );
                                                      if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                        selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                        selectedxTypeIndex = exerciseItems.length - 1;
                                                      } else {
                                                        selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                      }
                                                      //
                                                    }
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: (isSelectedDumbbell == true) ? BorderSide(width: 2.0, color: TColor.black) : null,
                                                  backgroundColor: (isSelectedDumbbell == true) ? TColor.primarygray.withOpacity(0.1) : null,
                                                  minimumSize: Size.zero,
                                                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Text(
                                                  '덤벨',
                                                  style: TextStyle(fontSize: 14, color: TColor.black),
                                                ),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (isSelectedMachine == true) {
                                                      if (isSelectedBabel == false && isSelectedDumbbell == false && isSelectedBodyweight == false) {
                                                        showToastMessage('1가지 이상 선택해주세요~');
                                                      } else {
                                                        isSelectedMachine = false;
                                                        //
                                                        bodyexerciseListUpdate(
                                                          legsBabel,
                                                          legsDumbbell,
                                                          legsMachine,
                                                          legsBodyweight,
                                                          shouldersBabel,
                                                          shouldersDumbbell,
                                                          shouldersMachine,
                                                          shouldersBodyweight,
                                                          chestBabel,
                                                          chestDumbbell,
                                                          chestMachine,
                                                          chestBodyweight,
                                                          armsBabel,
                                                          armsDumbbell,
                                                          armsMachine,
                                                          armsBodyweight,
                                                          backBabel,
                                                          backDumbbell,
                                                          backMachine,
                                                          backBodyweight,
                                                          absBabel,
                                                          absDumbbell,
                                                          absMachine,
                                                          absBodyweight,
                                                        );
                                                        if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                          selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                          selectedxTypeIndex = exerciseItems.length - 1;
                                                        } else {
                                                          selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                        }
                                                        //
                                                      }
                                                    } else {
                                                      isSelectedMachine = true;
                                                      //
                                                      bodyexerciseListUpdate(
                                                        legsBabel,
                                                        legsDumbbell,
                                                        legsMachine,
                                                        legsBodyweight,
                                                        shouldersBabel,
                                                        shouldersDumbbell,
                                                        shouldersMachine,
                                                        shouldersBodyweight,
                                                        chestBabel,
                                                        chestDumbbell,
                                                        chestMachine,
                                                        chestBodyweight,
                                                        armsBabel,
                                                        armsDumbbell,
                                                        armsMachine,
                                                        armsBodyweight,
                                                        backBabel,
                                                        backDumbbell,
                                                        backMachine,
                                                        backBodyweight,
                                                        absBabel,
                                                        absDumbbell,
                                                        absMachine,
                                                        absBodyweight,
                                                      );
                                                      if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                        selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                        selectedxTypeIndex = exerciseItems.length - 1;
                                                      } else {
                                                        selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                      }
                                                      //
                                                    }
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: (isSelectedMachine == true) ? BorderSide(width: 2.0, color: TColor.black) : null,
                                                  backgroundColor: (isSelectedMachine == true) ? TColor.primarygray.withOpacity(0.1) : null,
                                                  minimumSize: Size.zero,
                                                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Text(
                                                  '머신',
                                                  style: TextStyle(fontSize: 14, color: TColor.black),
                                                ),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (isSelectedBodyweight == true) {
                                                      if (isSelectedBabel == false && isSelectedDumbbell == false && isSelectedMachine == false) {
                                                        showToastMessage('1가지 이상 선택해주세요~');
                                                      } else {
                                                        isSelectedBodyweight = false;
                                                        //
                                                        bodyexerciseListUpdate(
                                                          legsBabel,
                                                          legsDumbbell,
                                                          legsMachine,
                                                          legsBodyweight,
                                                          shouldersBabel,
                                                          shouldersDumbbell,
                                                          shouldersMachine,
                                                          shouldersBodyweight,
                                                          chestBabel,
                                                          chestDumbbell,
                                                          chestMachine,
                                                          chestBodyweight,
                                                          armsBabel,
                                                          armsDumbbell,
                                                          armsMachine,
                                                          armsBodyweight,
                                                          backBabel,
                                                          backDumbbell,
                                                          backMachine,
                                                          backBodyweight,
                                                          absBabel,
                                                          absDumbbell,
                                                          absMachine,
                                                          absBodyweight,
                                                        );
                                                        if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                          selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                          selectedxTypeIndex = exerciseItems.length - 1;
                                                        } else {
                                                          selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                        }
                                                        //
                                                      }
                                                    } else {
                                                      isSelectedBodyweight = true;
                                                      //
                                                      bodyexerciseListUpdate(
                                                        legsBabel,
                                                        legsDumbbell,
                                                        legsMachine,
                                                        legsBodyweight,
                                                        shouldersBabel,
                                                        shouldersDumbbell,
                                                        shouldersMachine,
                                                        shouldersBodyweight,
                                                        chestBabel,
                                                        chestDumbbell,
                                                        chestMachine,
                                                        chestBodyweight,
                                                        armsBabel,
                                                        armsDumbbell,
                                                        armsMachine,
                                                        armsBodyweight,
                                                        backBabel,
                                                        backDumbbell,
                                                        backMachine,
                                                        backBodyweight,
                                                        absBabel,
                                                        absDumbbell,
                                                        absMachine,
                                                        absBodyweight,
                                                      );
                                                      if (selectedxTypeIndex > exerciseItems.length - 1) {
                                                        selectedxTypeItem = exerciseItems[exerciseItems.length - 1];
                                                        selectedxTypeIndex = exerciseItems.length - 1;
                                                      } else {
                                                        selectedxTypeItem = exerciseItems[selectedxTypeIndex];
                                                      }
                                                      //
                                                    }
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: (isSelectedBodyweight == true) ? BorderSide(width: 2.0, color: TColor.black) : null,
                                                  backgroundColor: (isSelectedBodyweight == true) ? TColor.primarygray.withOpacity(0.1) : null,
                                                  minimumSize: Size.zero,
                                                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Text(
                                                  '맨몸',
                                                  style: TextStyle(fontSize: 14, color: TColor.black),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //
                                  Container(
                                    height: 40,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 0.5,
                                width: media.width * 0.98,
                                decoration: BoxDecoration(
                                  color: TColor.primarygray.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                              Container(
                                // color: Colors.black.withOpacity(0.2),
                                height: media.height * 32 / 844, //아이폰13을 기준으로 맞춤
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //--------------------<<  image wiget for screenshot  >>--------------------

  //1. 캡처한 이미지를 갤러리에 저장할 메서드
  Future saveImage(Uint8List bytes) async {
    //이미지 갤러리 보호기는 이미지를 저장할 수 있도록 저장 권한을 요청해야한다
    await [Permission.storage].request();

    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
    final name = 'screenshot_$time';
    //갤러리 저장 메서드를 호출하고 그 안에 바이트를 넣는다
    final result = await ImageGallerySaver.saveImage(bytes, quality: 100, name: name);
    //갤러리 내 이미지가 저장된 위치로 파일을 전달

    return result['filePath'];
  }

  //2. 이미지 공유하기
  Future saveAndShare(Uint8List bytes) async {
    // 문서 디렉토리에 이미지 파일을 저장합니다.
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);

    // 이미지 파일을 공유합니다.
    const text = 'Shared From title';
    await Share.shareFiles([image.path], text: text);
    // await Share.shareXFiles([image], text: text);
  }

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;
  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isIOS ? 'ca-app-pub-9398946924743018/6574107704' : 'ca-app-pub-9398946924743018/8074891633',
        // 테스트 데모 https://developers.google.com/admob/ios/test-ads?hl=ko#demo_ad_units

        // 'ios': 'ca-app-pub-9398946924743018/6574107704', //my ios key
        // 'android': 'ca-app-pub-9398946924743018/8074891633', //my android key
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            debugPrint('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      debugPrint('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('$ad onAdShowedFullScreenContent.');
        isselectedlog = false;
        setState(() {
          Navigator.pop(context);
        });
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');

        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedInterstitialAd = null;
  }

  void bodyexerciseListUpdate(
    // 2. [하체]운동목록
    List legsBabel,
    List legsDumbbell,
    List legsMachine,
    List legsBodyweight,

    // 2. [어깨]운동목록
    List shouldersBabel,
    List shouldersDumbbell,
    List shouldersMachine,
    List shouldersBodyweight,

    // 3. [가슴]운동목록
    List chestBabel,
    List chestDumbbell,
    List chestMachine,
    List chestBodyweight,

    // 4. [팔]운동목록
    List armsBabel,
    List armsDumbbell,
    List armsMachine,
    List armsBodyweight,

    // 5. [등]운동목록
    List backBabel,
    List backDumbbell,
    List backMachine,
    List backBodyweight,

    // 6. [복근]운동목록
    List absBabel,
    List absDumbbell,
    List absMachine,
    List absBodyweight,
  ) {
    switch (_isbodypartcontroller) {
      case '하체':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.legs]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < legsBabel.length; i++) {
            exerciseList[BodyPart.legs]?.add(legsBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < legsDumbbell.length; i++) {
            exerciseList[BodyPart.legs]?.add(legsDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < legsMachine.length; i++) {
            exerciseList[BodyPart.legs]?.add(legsMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < legsBodyweight.length; i++) {
            exerciseList[BodyPart.legs]?.add(legsBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.legs]!;

        break;
      case '어깨':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.shoulders]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < shouldersBabel.length; i++) {
            exerciseList[BodyPart.shoulders]?.add(shouldersBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < shouldersDumbbell.length; i++) {
            exerciseList[BodyPart.shoulders]?.add(shouldersDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < shouldersMachine.length; i++) {
            exerciseList[BodyPart.shoulders]?.add(shouldersMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < shouldersBodyweight.length; i++) {
            exerciseList[BodyPart.shoulders]?.add(shouldersBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.shoulders]!;

        break;
      case '가슴':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.chest]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < chestBabel.length; i++) {
            exerciseList[BodyPart.chest]?.add(chestBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < chestDumbbell.length; i++) {
            exerciseList[BodyPart.chest]?.add(chestDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < chestMachine.length; i++) {
            exerciseList[BodyPart.chest]?.add(chestMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < chestBodyweight.length; i++) {
            exerciseList[BodyPart.chest]?.add(chestBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.chest]!;

        break;
      case '팔':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.arms]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < armsBabel.length; i++) {
            exerciseList[BodyPart.arms]?.add(armsBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < armsDumbbell.length; i++) {
            exerciseList[BodyPart.arms]?.add(armsDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < armsMachine.length; i++) {
            exerciseList[BodyPart.arms]?.add(armsMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < armsBodyweight.length; i++) {
            exerciseList[BodyPart.arms]?.add(armsBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.arms]!;

        break;
      case '등':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.back]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < backBabel.length; i++) {
            exerciseList[BodyPart.back]?.add(backBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < backDumbbell.length; i++) {
            exerciseList[BodyPart.back]?.add(backDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < backMachine.length; i++) {
            exerciseList[BodyPart.back]?.add(backMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < backBodyweight.length; i++) {
            exerciseList[BodyPart.back]?.add(backBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.back]!;

        break;
      case '복근':
        //필터 확인 후 운동 추가
        //리스트 초기화 후 생성을 통해 정렬 및 제거기능 생략
        exerciseList[BodyPart.abs]?.clear();
        //[바벨]필터
        if (isSelectedBabel == true) {
          for (int i = 0; i < absBabel.length; i++) {
            exerciseList[BodyPart.abs]?.add(absBabel[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedDumbbell == true) {
          for (int i = 0; i < absDumbbell.length; i++) {
            exerciseList[BodyPart.abs]?.add(absDumbbell[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedMachine == true) {
          for (int i = 0; i < absMachine.length; i++) {
            exerciseList[BodyPart.abs]?.add(absMachine[i]);
          }
        }
        //[덤벨]필터
        if (isSelectedBodyweight == true) {
          for (int i = 0; i < absBodyweight.length; i++) {
            exerciseList[BodyPart.abs]?.add(absBodyweight[i]);
          }
        }
        //
        exerciseItems = exerciseList[BodyPart.abs]!;

        break;
    }
  }
}

const int maxFailedLoadAttempts = 3;

// --------------북마크(운동 종류 즐겨찾기) 작업 중인 코드
// OutlinedButton(
//                                               onPressed: () {},
//                                               style: OutlinedButton.styleFrom(
//                                                 minimumSize: Size.zero,
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 2.0,
//                                                         horizontal: 4.0),
//                                                 tapTargetSize:
//                                                     MaterialTapTargetSize
//                                                         .shrinkWrap,
//                                               ),
//                                               child: Text(
//                                                 '북마크',
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: TColor.primarygray),
//                                               ),
//                                             ),

//                                             Icon(
//                                               Icons.bookmark,
//                                               size: 18,
//                                               color: TColor.secondarygray,
//                                             ),
//                                             OutlinedButton(
//                                               onPressed: () {},
//                                               style: OutlinedButton.styleFrom(
//                                                 backgroundColor: TColor.white,
//                                                 minimumSize: Size.zero,
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 2.0,
//                                                         horizontal: 4.0),
//                                                 tapTargetSize:
//                                                     MaterialTapTargetSize
//                                                         .shrinkWrap,
//                                               ),
//                                               child: Text(
//                                                 '북마크 등록',
//                                                 style: TextStyle(
//                                                     height: 1.2,
//                                                     fontSize: 14,
//                                                     color: TColor.primarygray),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8)
