import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:workoutdiary/analytics/ga_event.dart';

import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/common/hive_helper.dart';
import 'package:workoutdiary/exercise_date/ximg_saved_tile.dart';
import 'package:workoutdiary/exercise_date/xlog_ximg_date_calendar_view.dart';
import 'package:workoutdiary/exercise_log/text_add_view.dart';
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

  //context를 반환하는 함수 'of'를 static으로 생성한다.
  static XlogCreateViewState? of(BuildContext context) => context.findAncestorStateOfType<XlogCreateViewState>();
}

class XlogCreateViewState extends State<XlogCreateView> {
  //
  late Xlog recentLog;
  int recentLogcount = 0;

  bool isSelectedRecentLog = false;
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

  @override
  void initState() {
    super.initState();
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
    setState(() {});
  }

  //--------------------<<  Variable  >>--------------------
  int _timeformat = 0;
  int _styleformat = 0;
  int _xlogformat = 0;
  Color stylefontColor = Colors.white;
  Color stylebackgroundColor = Colors.black;

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
  late String selectedxTypeItem = LocaleData.L_B_Barbell_Glute_Bridge;
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

  double cupertinoPickeritemExtent = 44;

  //스크린샷 컨트롤러
  final screenshotController = ScreenshotController();
  //장비 선택 유무
  bool isSelectedBabel = true;
  bool isSelectedDumbbell = true;
  bool isSelectedMachine = true;
  bool isSelectedBodyweight = true;
  //
  bool isSelected = true;
  //
  @override
  Widget build(BuildContext context) {
    switch (_styleformat) {
      case 0:
        stylefontColor = Colors.white;
        stylebackgroundColor = Colors.black.withOpacity(0.25);
        break;
      case 1:
        stylefontColor = Colors.white;
        stylebackgroundColor = Colors.black.withOpacity(0);
        break;
      case 2:
        stylefontColor = Colors.black;
        stylebackgroundColor = Colors.white.withOpacity(0.25);
        break;
      case 3:
        stylefontColor = Colors.black;
        stylebackgroundColor = Colors.white.withOpacity(0);
        break;
    }
    // 아이패드일때 시작화면비는 1:1
    if (MediaQuery.sizeOf(context).height / MediaQuery.sizeOf(context).width < 1.5) {
      _ratio = 0;
    }

    //날짜 포멧을 자국어로 생성한다
    initializeDateFormatting(LocaleData.language.getString(context));
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
    // ios 5.5에서는 158, ios 6.5에서는 180 사용, 5.5 : 414*736, 6.5 : 414*896

    double cupertinoPickerHeight = 158;

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
              LocaleData.L_B_Barbell_Glute_Bridge,
              LocaleData.L_B_Sumo_Deadlift,
              LocaleData.L_B_Barbell_Back_Squat,
              LocaleData.L_B_Barbell_Bulgarian_Split_Squat,
              LocaleData.L_B_Barbell_Front_Squat,
              LocaleData.L_B_Barbell_Hack_Squat,
              LocaleData.L_B_Barbell_Lateral_Lunge,
              LocaleData.L_B_Barbell_Lunge,
              LocaleData.L_B_Conventional_Deadlift,
              LocaleData.L_B_Deficit_Deadlift,
              LocaleData.L_B_Romanian_Deadlift,
              LocaleData.L_B_Barbell_Front_Rack_Lunge,
              LocaleData.L_B_Barbell_Hip_Thrust,
              LocaleData.L_B_Barbell_Jump_Squat,
              LocaleData.L_B_Barbell_One_Leg_Deadlift,
              LocaleData.L_B_Barbell_Split_Squat,
              LocaleData.L_B_Barbell_Standing_Calf_Raise,
              LocaleData.L_B_Barbell_Sumo_Squat,
              LocaleData.L_B_Trap_Bar_Deadlift,
              LocaleData.L_B_Zercher_Squat,
            ];
            // // [덤벨]
            List legsDumbbell = [
              LocaleData.L_D_Dumbbell_Lateral_Lunge,
              LocaleData.L_D_Dumbbell_Sumo_Deadlift,
              LocaleData.L_D_Dumbbell_Bulgarian_Split_Squat,
              LocaleData.L_D_Dumbbell_Goblet_Squat,
              LocaleData.L_D_Dumbbell_Lunge,
              LocaleData.L_D_Dumbbell_Squat,
              LocaleData.L_D_Dumbbell_Sumo_Squat,
              LocaleData.L_D_Dumbbell_Romanian_Deadlift,
              LocaleData.L_D_Dumbbell_Calf_Raise,
              LocaleData.L_D_Dumbbell_Leg_Curl,
              LocaleData.L_D_Dumbbell_One_Leg_Deadlift,
              LocaleData.L_D_Dumbbell_Split_Squat,
              LocaleData.L_D_Dumbbell_Stiff_Leg_Deadlift,
              LocaleData.L_D_Weight_Step_Up,
            ];
            // // [머신]
            List legsMachine = [
              LocaleData.L_M_Glute_Kickback_Machine,
              LocaleData.L_M_Leg_Extension,
              LocaleData.L_M_Leg_Press,
              LocaleData.L_M_Leg_Curl,
              LocaleData.L_M_Cable_Donkey_Kick,
              LocaleData.L_M_Cable_Hip_Abduction,
              LocaleData.L_M_Cable_Hip_Adduction,
              LocaleData.L_M_Cable_Pull_Through,
              LocaleData.L_M_Hack_Squat_Machine,
              LocaleData.L_M_Hip_Abduction_Machine,
              LocaleData.L_M_Hip_Thrust_Machine,
              LocaleData.L_M_Horizontal_Leg_Press,
              LocaleData.L_M_Horizontal_One_Leg_Press,
              LocaleData.L_M_Inner_Cy_Machine,
              LocaleData.L_M_Monster_Glute_Machine,
              LocaleData.L_M_One_Leg_Curl,
              LocaleData.L_M_One_Leg_Extension,
              LocaleData.L_M_One_Leg_Press,
              LocaleData.L_M_Reverse_V_Squat,
              LocaleData.L_M_Seated_Calf_Raises,
              LocaleData.L_M_Seated_Leg_Curl,
              LocaleData.L_M_Seated_One_Leg_Curl,
              LocaleData.L_M_Smith_Machine_Deadlift,
              LocaleData.L_M_Smith_Machine_Split_Squat,
              LocaleData.L_M_Smith_Machine_Squat,
              LocaleData.L_M_Standing_Calf_Raise,
              LocaleData.L_M_V_Squat,
            ];
            // // [맨몸]
            List legsBodyweight = [
              LocaleData.L_B_Donkey_Kick,
              LocaleData.L_B_Lunge,
              LocaleData.L_B_Glute_Bridge,
              LocaleData.L_B_Nordic_Hamstring_Curl,
              LocaleData.L_B_Air_Squat,
              LocaleData.L_B_Body_Calf_Raise,
              LocaleData.L_B_Bodyweight_Lateral_Lunge,
              LocaleData.L_B_Bodyweight_One_Leg_Deadlift,
              LocaleData.L_B_Bodyweight_Overhead_Squat,
              LocaleData.L_B_Bodyweight_Split_Squat,
              LocaleData.L_B_Hip_Thrust,
              LocaleData.L_B_Jump_Squat,
              LocaleData.L_B_Lunge_Twist,
              LocaleData.L_B_Lying_Hip_Abduction,
              LocaleData.L_B_Pistol_Squat,
              LocaleData.L_B_Side_Lying_Clam,
              LocaleData.L_B_Single_Leg_Glute_Bridge,
              LocaleData.L_B_Step_Up,
              LocaleData.L_B_Sumo_Air_Squat,
            ];

            // 2. [어깨]운동목록
            // // [바벨]
            List shouldersBabel = [
              LocaleData.S_B_Barbell_Overhead_Press,
              LocaleData.S_B_Barbell_Front_Raise,
              LocaleData.S_B_Barbell_Shrug,
              LocaleData.S_B_Barbell_Upright_Row,
              LocaleData.S_B_Easy_Bar_Front_Raise,
              LocaleData.S_B_Easy_Bar_Upright_Row,
              LocaleData.S_B_Plate_Shoulder_Press,
              LocaleData.S_B_Push_Press,
              LocaleData.S_B_Seated_Barbell_Shoulder_Press,
            ];
            // // [덤벨]
            List shouldersDumbbell = [
              LocaleData.S_D_Arnold_Dumbbell_Press,
              LocaleData.S_D_Bentover_Dumbbell_Lateral_Raise,
              LocaleData.S_D_Dumbbell_Front_Raise,
              LocaleData.S_D_Dumbbell_Lateral_Raise,
              LocaleData.S_D_Dumbbell_Shoulder_Press,
              LocaleData.S_D_Dumbbell_Shrug,
              LocaleData.S_D_Dumbbell_Upright_Row,
              LocaleData.S_D_Dumbbell_Y_Raise,
              LocaleData.S_D_Seated_Dumbbell_Rear_Lateral_Raise,
              LocaleData.S_D_Seated_Dumbbell_Shoulder_Press,
            ];
            // // [머신]
            List shouldersMachine = [
              LocaleData.S_M_Behind_Neck_Press,
              LocaleData.S_M_Cable_External_Rotation,
              LocaleData.S_M_Cable_Front_Raise,
              LocaleData.S_M_Cable_Internal_Rotation,
              LocaleData.S_M_Cable_Lateral_Raise,
              LocaleData.S_M_Cable_Reverse_Fly,
              LocaleData.S_M_Cable_Shrug,
              LocaleData.S_M_Faithfull,
              LocaleData.S_M_Landmine_Press,
              LocaleData.S_M_Lateral_Raise_Machine,
              LocaleData.S_M_One_Arm_Cable_Lateral_Raise,
              LocaleData.S_M_Rear_Deltoid_Fly_Machine,
              LocaleData.S_M_Shoulder_Press_Machine,
              LocaleData.S_M_Shrug_Machine,
              LocaleData.S_M_Smith_Machine_Overhead_Press,
              LocaleData.S_M_Smith_Machine_Shrug,
              LocaleData.S_M_Wonam_Landmine_Press,
            ];
            // // [맨몸]
            List shouldersBodyweight = [
              LocaleData.S_B_Handstand,
              LocaleData.S_B_Handstand_Push_Up,
              LocaleData.S_B_Shoulder_Tab,
              LocaleData.S_B_Y_Raise,
            ];

            // 3. [가슴]운동목록
            // // [바벨]
            List chestBabel = [
              LocaleData.C_B_Barbell_Floor_Press,
              LocaleData.C_B_Bench_Press,
              LocaleData.C_B_Decline_Bench_Press,
              LocaleData.C_B_Incline_Bench_Press,
              LocaleData.C_B_Spoto_Bench_Press,
            ];
            // // [덤벨]
            List chestDumbbell = [
              LocaleData.C_D_Decline_Dumbbell_Bench_Press,
              LocaleData.C_D_Decline_Dumbbell_Fly,
              LocaleData.C_D_Dumbbell_Bench_Press,
              LocaleData.C_D_Dumbbell_Fly,
              LocaleData.C_D_Dumbbell_Pullover,
              LocaleData.C_D_Dumbbell_Squeeze_Press,
              LocaleData.C_D_Incline_Dumbbell_Bench_Press,
              LocaleData.C_D_Incline_Dumbbell_Flyes,
              LocaleData.C_D_Incline_Dumbbell_Twist_Press,
              LocaleData.C_D_Weighted_Dips,
            ];
            // // [머신]
            List chestMachine = [
              LocaleData.C_M_Assist_Dips_Machine,
              LocaleData.C_M_Cable_Crossover,
              LocaleData.C_M_Chest_Press_Machine,
              LocaleData.C_M_Decline_Chest_Press_Machine,
              LocaleData.C_M_Hammer_Bench_Press,
              LocaleData.C_M_Incline_Bench_Press_Machine,
              LocaleData.C_M_Incline_Cable_Fly,
              LocaleData.C_M_Incline_Chest_Press_Machine,
              LocaleData.C_M_Low_Pulley_Cable_Fly,
              LocaleData.C_M_Peck_Deck_Fly_Machine,
              LocaleData.C_M_Seated_Dips_Machine,
              LocaleData.C_M_Smith_Machine_Bench_Press,
              LocaleData.C_M_Smith_Machine_Inline_Bench_Press,
              LocaleData.C_M_Standing_Cable_Fly,
            ];
            // // [맨몸]
            List chestBodyweight = [
              LocaleData.C_B_Archer_Push_Up,
              LocaleData.C_B_Clap_Push_Up,
              LocaleData.C_B_Close_Grip_Push_Up,
              LocaleData.C_B_Dips,
              LocaleData.C_B_Hindu_Push_Up,
              LocaleData.C_B_Pike_Push_Up,
              LocaleData.C_B_Push_Up,
              LocaleData.C_B_Weighted_Push_Ups,
            ];

            // 4. [팔]운동목록
            // // [바벨]
            List armsBabel = [
              LocaleData.R_B_Barbell_Curl,
              LocaleData.R_B_Barbell_Lying_Tricep_Extension,
              LocaleData.R_B_Barbell_Preacher_Curl,
              LocaleData.R_B_Barbell_Wrist_Curl,
              LocaleData.R_B_Close_Grip_Bench_Press,
              LocaleData.R_B_Easy_Bar_Curl,
              LocaleData.R_B_Easy_Bar_Preacher_Curl,
              LocaleData.R_B_Easy_Bar_Wrist_Curl,
              LocaleData.R_B_List_Roller,
              LocaleData.R_B_Reverse_Barbell_Curl,
              LocaleData.R_B_Reverse_Barbell_Wrist_Curl,
              LocaleData.R_B_Skull_Crusher,
            ];
            // // [덤벨]
            List armsDumbbell = [
              LocaleData.R_D_Dembel_Preacher_Curl,
              LocaleData.R_D_Dumbbell_Curl,
              LocaleData.R_D_Dumbbell_Hammer_Curl,
              LocaleData.R_D_Dumbbell_Kickback,
              LocaleData.R_D_Dumbbell_Tricep_Extension,
              LocaleData.R_D_Dumbbell_Wrist_Curl,
              LocaleData.R_D_Incline_Dumbbell_Curl,
              LocaleData.R_D_Reverse_Dumbbell_Wrist_Curl,
              LocaleData.R_D_Seated_Dumbbell_Tricep_Extension,
            ];
            // // [머신]
            List armsMachine = [
              LocaleData.R_M_Arm_Curl_Machine,
              LocaleData.R_M_Cable_Curl,
              LocaleData.R_M_Cable_Hammer_Curl,
              LocaleData.R_M_Cable_Lying_Tricep_Extension,
              LocaleData.R_M_Cable_Overhead_Tricep_Extension,
              LocaleData.R_M_Cable_Push_Down,
              LocaleData.R_M_Cable_Tricep_Extension,
              LocaleData.R_M_Preacher_Curl_Machine,
              LocaleData.R_M_Tricep_Extension_Machine,
            ];
            // // [맨몸]
            List armsBodyweight = [
              LocaleData.R_B_Bench_Dips,
            ];

            // 5. [등]운동목록
            // // [바벨]
            List backBabel = [
              LocaleData.B_B_Barbell_Pullover,
              LocaleData.B_B_Barbell_Row,
              LocaleData.B_B_Good_Morning_Exercise,
              LocaleData.B_B_Incline_Barbell_Row,
              LocaleData.B_B_Lying_Barbell_Row,
              LocaleData.B_B_Pendlay_Row,
              LocaleData.B_B_Undergrip_Barbell_Row,
            ];
            // // [덤벨]
            List backDumbbell = [
              LocaleData.B_D_Dumbbell_Row,
              LocaleData.B_D_Incline_Dumbbell_Row,
              LocaleData.B_D_One_Arm_Dumbbell_Row,
              LocaleData.B_D_Weighted_Chin_Up,
              LocaleData.B_D_Weighted_Pull_Ups,
            ];
            // // [머신]
            List backMachine = [
              LocaleData.B_M_Assist_Pull_Up_Machine,
              LocaleData.B_M_Behind_The_Neck_Pulldown,
              LocaleData.B_M_Cable_Arm_Pulldown,
              LocaleData.B_M_Floor_Seated_Cable_Row,
              LocaleData.B_M_Heavy_Hyperextension,
              LocaleData.B_M_High_Low_Machine,
              LocaleData.B_M_Inverted_Row,
              LocaleData.B_M_Lat_Pulldown,
              LocaleData.B_M_Lateral_Wide_Pulldown,
              LocaleData.B_M_Mcgrip_Lat_Pulldown,
              LocaleData.B_M_One_Arm_Cable_Pull_Down,
              LocaleData.B_M_One_Arm_High_Low_Machine,
              LocaleData.B_M_One_Arm_Lateral_Wide_Pulldown,
              LocaleData.B_M_One_Arm_Seated_Cable_Row,
              LocaleData.B_M_One_Arm_Row_Machine,
              LocaleData.B_M_Parallel_Grip_Lat_Pulldown,
              LocaleData.B_M_Row_Machine,
              LocaleData.B_M_Seated_Cable_Row,
              LocaleData.B_M_Seated_Row_Machine,
              LocaleData.B_M_Smith_Machine_Row,
              LocaleData.B_M_T_Bar_Row_Machine,
              LocaleData.B_M_Undergrab_Lat_Pulldown,
              LocaleData.B_M_Undergrip_High_Low_Machine,
            ];
            // // [맨몸]
            List backBodyweight = [
              LocaleData.B_B_Back_Extension,
              LocaleData.B_B_Chin_Up,
              LocaleData.B_B_Hyper_Extension,
              LocaleData.B_B_Pull_Up,
            ];

            // 6. [복근]운동목록
            // // [바벨]
            List absBabel = [
              LocaleData.A_B_Abs_Rollout,
            ];
            // // [덤벨]
            List absDumbbell = [
              LocaleData.A_D_Dumbbell_Side_Bend,
              LocaleData.A_D_Heavy_Decline_Sit_Up,
              LocaleData.A_D_Heavy_Updominal_Hip_Thrust,
              LocaleData.A_D_Russian_Twist,
              LocaleData.A_D_Weighted_Decline_Crunch,
            ];
            // // [머신]
            List absMachine = [
              LocaleData.A_M_Abdominal_Crunch_Machine,
              LocaleData.A_M_Cable_Side_Bend,
              LocaleData.A_M_Cable_Twist,
              LocaleData.A_M_Hanging_Knee_Raise,
              LocaleData.A_M_Hanging_Leg_Raise,
              LocaleData.A_M_Tods_To_Bar,
            ];
            // // [맨몸]
            List absBodyweight = [
              LocaleData.A_B_45_Degree_Side_Bend,
              LocaleData.A_B_Abs_Air_Bike,
              LocaleData.A_B_Crunch,
              LocaleData.A_B_Decline_Crunch,
              LocaleData.A_B_Decline_Reverse_Crunch,
              LocaleData.A_B_Decline_Sit_Up,
              LocaleData.A_B_Heel_Touch,
              LocaleData.A_B_Hollow_Position,
              LocaleData.A_B_Hollow_Rock,
              LocaleData.A_B_Leg_Raise,
              LocaleData.A_B_Pilates_Jackknife,
              LocaleData.A_B_Plank,
              LocaleData.A_B_Reverse_Crunch,
              LocaleData.A_B_Side_Crunches,
              LocaleData.A_B_Side_Plank,
              LocaleData.A_B_Sit_Up,
              LocaleData.A_B_Updominal_Hip_Thrust,
              LocaleData.A_B_V_Up,
            ];
            //
            if (selectedxTypeItem == LocaleData.L_B_Barbell_Glute_Bridge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Glute_Bridge.png';
              videoURL = 'https://youtu.be/coDVXIpfhhI';
            } else if (selectedxTypeItem == LocaleData.L_B_Sumo_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Sumo_Deadlift.png';
              videoURL = 'https://youtu.be/ZPcy5aDBbr4';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Back_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Back_Squat.png';
              videoURL = 'https://youtu.be/0tYihRsCHOM';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Bulgarian_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Bulgarian_Split_Squat.png';
              videoURL = 'https://youtu.be/IFK5auzHY4c';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Front_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Front_Squat.png';
              videoURL = 'https://youtu.be/WRoThcAqqNI';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Hack_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Hack_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Lateral_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Lateral_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Lunge.png';
              videoURL = 'https://youtu.be/iHWygRKZp3g';
            } else if (selectedxTypeItem == LocaleData.L_B_Conventional_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Conventional_Deadlift.png';
              videoURL = 'https://youtu.be/lqmyZhUK30M';
            } else if (selectedxTypeItem == LocaleData.L_B_Deficit_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Deficit_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Romanian_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Romanian_Deadlift.png';
              videoURL = 'https://youtu.be/0toNMnclnUg';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Front_Rack_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Front_Rack_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Hip_Thrust) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Hip_Thrust.png';
              videoURL = 'https://youtu.be/5U0GW8Kohys';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Jump_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Jump_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_One_Leg_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_One_Leg_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Split_Squat.png';
              videoURL = 'https://youtu.be/jgn5wz322p0';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Standing_Calf_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Standing_Calf_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Barbell_Sumo_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Barbell_Sumo_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Trap_Bar_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Trap_Bar_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Zercher_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Zercher_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Lateral_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Lateral_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Sumo_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Sumo_Deadlift.png';
              videoURL = 'https://youtu.be/2Qwpr8vUkIM';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Bulgarian_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Bulgarian_Split_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Goblet_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Goblet_Squat.png';
              videoURL = 'https://youtu.be/wJWiYBE9Kc0';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Squat.png';
              videoURL = 'https://youtu.be/DpRSG07VqUU';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Sumo_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Sumo_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Romanian_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Romanian_Deadlift.png';
              videoURL = 'https://youtu.be/cwpKQJ4XvT4';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Calf_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Calf_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Leg_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Leg_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_One_Leg_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_One_Leg_Deadlift.png';
              videoURL = 'https://youtu.be/Qmp606CgBMU';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Split_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Dumbbell_Stiff_Leg_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Dumbbell_Stiff_Leg_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_D_Weight_Step_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_D_Weight_Step_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Glute_Kickback_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Glute_Kickback_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Leg_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Leg_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Leg_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Leg_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Cable_Donkey_Kick) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Donkey_Kick.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Cable_Hip_Abduction) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Hip_Abduction.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Cable_Hip_Adduction) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Hip_Adduction.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Cable_Pull_Through) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Cable_Pull_Through.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Hack_Squat_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hack_Squat_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Hip_Abduction_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hip_Abduction_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Hip_Thrust_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Hip_Thrust_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Horizontal_Leg_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Horizontal_Leg_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Horizontal_One_Leg_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Horizontal_One_Leg_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Inner_Cy_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Inner_Cy_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Monster_Glute_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Monster_Glute_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_One_Leg_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_One_Leg_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_One_Leg_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_One_Leg_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Reverse_V_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Reverse_V_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Seated_Calf_Raises) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_Calf_Raises.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Seated_Leg_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_Leg_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Seated_One_Leg_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Seated_One_Leg_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Smith_Machine_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Smith_Machine_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Split_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Smith_Machine_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Smith_Machine_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_Standing_Calf_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_Standing_Calf_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_M_V_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_M_V_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Donkey_Kick) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Donkey_Kick.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Glute_Bridge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Glute_Bridge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Nordic_Hamstring_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Nordic_Hamstring_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Air_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Air_Squat.png';
              videoURL = 'https://youtu.be/Dp2PXU7RSHs';
            } else if (selectedxTypeItem == LocaleData.L_B_Body_Calf_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Body_Calf_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Bodyweight_Lateral_Lunge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Lateral_Lunge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Bodyweight_One_Leg_Deadlift) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_One_Leg_Deadlift.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Bodyweight_Overhead_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Overhead_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Bodyweight_Split_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Bodyweight_Split_Squat.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Hip_Thrust) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Hip_Thrust.png';
              videoURL = 'https://youtu.be/h3Y_3kH8GYU';
            } else if (selectedxTypeItem == LocaleData.L_B_Jump_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Jump_Squat.png';
              videoURL = 'https://youtu.be/xc-S57DdON8';
            } else if (selectedxTypeItem == LocaleData.L_B_Lunge_Twist) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lunge_Twist.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Lying_Hip_Abduction) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Lying_Hip_Abduction.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Pistol_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Pistol_Squat.png';
              videoURL = 'https://youtu.be/6nrJQNFqXSY';
            } else if (selectedxTypeItem == LocaleData.L_B_Side_Lying_Clam) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Side_Lying_Clam.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Single_Leg_Glute_Bridge) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Single_Leg_Glute_Bridge.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Step_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Step_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.L_B_Sumo_Air_Squat) {
              selectedxTypeImgpath = 'assets/img/workoutType/L_B_Sumo_Air_Squat.png';
              videoURL = 'https://youtu.be/m2R7LTY_CMY';
            } else if (selectedxTypeItem == LocaleData.S_B_Barbell_Overhead_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Overhead_Press.png';
              videoURL = 'https://youtu.be/lK3SQiEC2JE';
            } else if (selectedxTypeItem == LocaleData.S_B_Barbell_Front_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Front_Raise.png';
              videoURL = 'https://youtu.be/Ajzr2ISl-x8';
            } else if (selectedxTypeItem == LocaleData.S_B_Barbell_Shrug) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Shrug.png';
              videoURL = 'https://youtu.be/6cIl7Qcx61c';
            } else if (selectedxTypeItem == LocaleData.S_B_Barbell_Upright_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Barbell_Upright_Row.png';
              videoURL = 'https://youtu.be/iSytfNPQJhY';
            } else if (selectedxTypeItem == LocaleData.S_B_Easy_Bar_Front_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Easy_Bar_Front_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Easy_Bar_Upright_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Easy_Bar_Upright_Row.png';
              videoURL = 'https://youtu.be/cxsrYqQ4nfg';
            } else if (selectedxTypeItem == LocaleData.S_B_Plate_Shoulder_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Plate_Shoulder_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Push_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Push_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Seated_Barbell_Shoulder_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Seated_Barbell_Shoulder_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Arnold_Dumbbell_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Arnold_Dumbbell_Press.png';
              videoURL = 'https://youtu.be/kTS24mrinwk';
            } else if (selectedxTypeItem == LocaleData.S_D_Bentover_Dumbbell_Lateral_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Bentover_Dumbbell_Lateral_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Front_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Front_Raise.png';
              videoURL = 'https://youtu.be/UCQGQ_QnQ5A';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Lateral_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Lateral_Raise.png';
              videoURL = 'https://youtu.be/tI0mXXyfIYI';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Shoulder_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Shoulder_Press.png';
              videoURL = 'https://youtu.be/hat7My5Sdx4';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Shrug) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Shrug.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Upright_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Upright_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Dumbbell_Y_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Dumbbell_Y_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Seated_Dumbbell_Rear_Lateral_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Seated_Dumbbell_Rear_Lateral_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_D_Seated_Dumbbell_Shoulder_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_D_Seated_Dumbbell_Shoulder_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Behind_Neck_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Behind_Neck_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_External_Rotation) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_External_Rotation.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_Front_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Front_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_Internal_Rotation) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Internal_Rotation.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_Lateral_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Lateral_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_Reverse_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Reverse_Fly.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Cable_Shrug) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Cable_Shrug.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Faithfull) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Faithfull.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Landmine_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Landmine_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Lateral_Raise_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Lateral_Raise_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_One_Arm_Cable_Lateral_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_One_Arm_Cable_Lateral_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Rear_Deltoid_Fly_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Rear_Deltoid_Fly_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Shoulder_Press_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Shoulder_Press_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Shrug_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Shrug_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Smith_Machine_Overhead_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Smith_Machine_Overhead_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Smith_Machine_Shrug) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Smith_Machine_Shrug.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_M_Wonam_Landmine_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_M_Wonam_Landmine_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Handstand) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Handstand.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Handstand_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Handstand_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Shoulder_Tab) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Shoulder_Tab.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.S_B_Y_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/S_B_Y_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Barbell_Floor_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Barbell_Floor_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Bench_Press.png';
              videoURL = 'https://youtu.be/ot21xT-iHLg';
            } else if (selectedxTypeItem == LocaleData.C_B_Decline_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Decline_Bench_Press.png';
              videoURL = 'https://youtu.be/UaKvRJOZEzU';
            } else if (selectedxTypeItem == LocaleData.C_B_Incline_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Incline_Bench_Press.png';
              videoURL = 'https://youtu.be/xsWYKRz2uBA';
            } else if (selectedxTypeItem == LocaleData.C_B_Spoto_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Spoto_Bench_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_D_Decline_Dumbbell_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Decline_Dumbbell_Bench_Press.png';
              videoURL = 'https://youtu.be/_Y2PEyAdoMM';
            } else if (selectedxTypeItem == LocaleData.C_D_Decline_Dumbbell_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Decline_Dumbbell_Fly.png';
              videoURL = 'https://youtu.be/PFEM97UIRHo';
            } else if (selectedxTypeItem == LocaleData.C_D_Dumbbell_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Bench_Press.png';
              videoURL = 'https://youtu.be/78trrdwb0QM';
            } else if (selectedxTypeItem == LocaleData.C_D_Dumbbell_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Fly.png';
              videoURL = 'https://youtu.be/AtF9dS1KoyE';
            } else if (selectedxTypeItem == LocaleData.C_D_Dumbbell_Pullover) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Pullover.png';
              videoURL = 'https://youtu.be/sJ7kkU4Y59Y';
            } else if (selectedxTypeItem == LocaleData.C_D_Dumbbell_Squeeze_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Dumbbell_Squeeze_Press.png';
              videoURL = 'https://youtu.be/dL9errKGTos';
            } else if (selectedxTypeItem == LocaleData.C_D_Incline_Dumbbell_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Bench_Press.png';
              videoURL = 'https://youtu.be/1hPqxOOw0cQ';
            } else if (selectedxTypeItem == LocaleData.C_D_Incline_Dumbbell_Flyes) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Flyes.png';
              videoURL = 'https://youtu.be/n6kM4d_j-sY';
            } else if (selectedxTypeItem == LocaleData.C_D_Incline_Dumbbell_Twist_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Incline_Dumbbell_Twist_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_D_Weighted_Dips) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_D_Weighted_Dips.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Assist_Dips_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Assist_Dips_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Cable_Crossover) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Cable_Crossover.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Chest_Press_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Chest_Press_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Decline_Chest_Press_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Decline_Chest_Press_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Hammer_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Hammer_Bench_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Incline_Bench_Press_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Bench_Press_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Incline_Cable_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Cable_Fly.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Incline_Chest_Press_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Incline_Chest_Press_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Low_Pulley_Cable_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Low_Pulley_Cable_Fly.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Peck_Deck_Fly_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Peck_Deck_Fly_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Seated_Dips_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Seated_Dips_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Smith_Machine_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Smith_Machine_Bench_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Smith_Machine_Inline_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Smith_Machine_Inline_Bench_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_M_Standing_Cable_Fly) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_M_Standing_Cable_Fly.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Archer_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Archer_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Clap_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Clap_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Close_Grip_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Close_Grip_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Dips) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Dips.png';
              videoURL = 'https://youtu.be/Aca7f32SWYU';
            } else if (selectedxTypeItem == LocaleData.C_B_Hindu_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Hindu_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Pike_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Pike_Push_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.C_B_Push_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Push_Up.png';
              videoURL = 'https://youtu.be/1Ih3_2cmqgo';
            } else if (selectedxTypeItem == LocaleData.C_B_Weighted_Push_Ups) {
              selectedxTypeImgpath = 'assets/img/workoutType/C_B_Weighted_Push_Ups.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_B_Barbell_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Curl.png';
              videoURL = 'https://youtu.be/fcpf89fwj78';
            } else if (selectedxTypeItem == LocaleData.R_B_Barbell_Lying_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Lying_Tricep_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_B_Barbell_Preacher_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Preacher_Curl.png';
              videoURL = 'https://youtu.be/Rca1MXVcbxw';
            } else if (selectedxTypeItem == LocaleData.R_B_Barbell_Wrist_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Barbell_Wrist_Curl.png';
              videoURL = 'https://youtu.be/71LgWfyUBss';
            } else if (selectedxTypeItem == LocaleData.R_B_Close_Grip_Bench_Press) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Close_Grip_Bench_Press.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_B_Easy_Bar_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Curl.png';
              videoURL = 'https://youtu.be/jAUbcb2kPCo';
            } else if (selectedxTypeItem == LocaleData.R_B_Easy_Bar_Preacher_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Preacher_Curl.png';
              videoURL = 'https://youtu.be/MuSjk76sncM';
            } else if (selectedxTypeItem == LocaleData.R_B_Easy_Bar_Wrist_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Easy_Bar_Wrist_Curl.png';
              videoURL = 'https://youtu.be/dsYYN44U4mk';
            } else if (selectedxTypeItem == LocaleData.R_B_List_Roller) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_List_Roller.png';
              videoURL = 'https://youtu.be/6RXLZRgWoxY';
            } else if (selectedxTypeItem == LocaleData.R_B_Reverse_Barbell_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Reverse_Barbell_Curl.png';
              videoURL = 'https://youtu.be/yptPNjn_Yos';
            } else if (selectedxTypeItem == LocaleData.R_B_Reverse_Barbell_Wrist_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Reverse_Barbell_Wrist_Curl.png';
              videoURL = 'https://youtu.be/AOR1OXuTryY';
            } else if (selectedxTypeItem == LocaleData.R_B_Skull_Crusher) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Skull_Crusher.png';
              videoURL = 'https://youtu.be/MGTeyqavy50';
            } else if (selectedxTypeItem == LocaleData.R_D_Dembel_Preacher_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dembel_Preacher_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_D_Dumbbell_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_D_Dumbbell_Hammer_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Hammer_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_D_Dumbbell_Kickback) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Kickback.png';
              videoURL = 'https://youtu.be/x8aNnHma5NM';
            } else if (selectedxTypeItem == LocaleData.R_D_Dumbbell_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Tricep_Extension.png';
              videoURL = 'https://youtu.be/JBgK6Preqks';
            } else if (selectedxTypeItem == LocaleData.R_D_Dumbbell_Wrist_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Dumbbell_Wrist_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_D_Incline_Dumbbell_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Incline_Dumbbell_Curl.png';
              videoURL = 'https://youtu.be/TnZXYJa6W38';
            } else if (selectedxTypeItem == LocaleData.R_D_Reverse_Dumbbell_Wrist_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Reverse_Dumbbell_Wrist_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_D_Seated_Dumbbell_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_D_Seated_Dumbbell_Tricep_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Arm_Curl_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Arm_Curl_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Hammer_Curl) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Hammer_Curl.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Lying_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Lying_Tricep_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Overhead_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Overhead_Tricep_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Push_Down) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Push_Down.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Cable_Tricep_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Cable_Tricep_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Preacher_Curl_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Preacher_Curl_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_M_Tricep_Extension_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_M_Tricep_Extension_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.R_B_Bench_Dips) {
              selectedxTypeImgpath = 'assets/img/workoutType/R_B_Bench_Dips.png';
              videoURL = 'https://youtu.be/28Bdr_SVvmw';
            } else if (selectedxTypeItem == LocaleData.B_B_Barbell_Pullover) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Barbell_Pullover.png';
              videoURL = 'https://youtu.be/hi94Tw2HuoY';
            } else if (selectedxTypeItem == LocaleData.B_B_Barbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Barbell_Row.png';
              videoURL = 'https://youtu.be/ECda9GHJw4g';
            } else if (selectedxTypeItem == LocaleData.B_B_Good_Morning_Exercise) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Good_Morning_Exercise.png';
              videoURL = 'https://youtu.be/2__DMFtag7A';
            } else if (selectedxTypeItem == LocaleData.B_B_Incline_Barbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Incline_Barbell_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_B_Lying_Barbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Lying_Barbell_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_B_Pendlay_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Pendlay_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_B_Undergrip_Barbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Undergrip_Barbell_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_D_Dumbbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_D_Dumbbell_Row.png';
              videoURL = 'https://youtu.be/ErAy1GVVZ-M';
            } else if (selectedxTypeItem == LocaleData.B_D_Incline_Dumbbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_D_Incline_Dumbbell_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_D_One_Arm_Dumbbell_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_D_One_Arm_Dumbbell_Row.png';
              videoURL = 'https://youtu.be/vciXM0GnkmI';
            } else if (selectedxTypeItem == LocaleData.B_D_Weighted_Chin_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_D_Weighted_Chin_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_D_Weighted_Pull_Ups) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_D_Weighted_Pull_Ups.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Assist_Pull_Up_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Assist_Pull_Up_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Behind_The_Neck_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Behind_The_Neck_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Cable_Arm_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Cable_Arm_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Floor_Seated_Cable_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Floor_Seated_Cable_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Heavy_Hyperextension) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Heavy_Hyperextension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_High_Low_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_High_Low_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Inverted_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Inverted_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Lat_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Lat_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Lateral_Wide_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Lateral_Wide_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Mcgrip_Lat_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Mcgrip_Lat_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_One_Arm_Cable_Pull_Down) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Cable_Pull_Down.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_One_Arm_High_Low_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_High_Low_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_One_Arm_Lateral_Wide_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Lateral_Wide_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_One_Arm_Seated_Cable_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Seated_Cable_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_One_Arm_Row_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_One_Arm_Row_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Parallel_Grip_Lat_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Parallel_Grip_Lat_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Row_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Row_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Seated_Cable_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Seated_Cable_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Seated_Row_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Seated_Row_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Smith_Machine_Row) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Smith_Machine_Row.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_T_Bar_Row_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_T_Bar_Row_Machine.png';
              videoURL = 'https://youtu.be/y1GrFDU5et4';
            } else if (selectedxTypeItem == LocaleData.B_M_Undergrab_Lat_Pulldown) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Undergrab_Lat_Pulldown.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_M_Undergrip_High_Low_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_M_Undergrip_High_Low_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_B_Back_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Back_Extension.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.B_B_Chin_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Chin_Up.png';
              videoURL = 'https://youtu.be/24CixqZA-8k';
            } else if (selectedxTypeItem == LocaleData.B_B_Hyper_Extension) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Hyper_Extension.png';
              videoURL = 'https://youtu.be/N2I6X1bwZaA';
            } else if (selectedxTypeItem == LocaleData.B_B_Pull_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/B_B_Pull_Up.png';
              videoURL = 'https://youtu.be/nSUyfgWzc9M';
            } else if (selectedxTypeItem == LocaleData.A_B_Abs_Rollout) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Abs_Rollout.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_D_Dumbbell_Side_Bend) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_D_Dumbbell_Side_Bend.png';
              videoURL = 'https://youtu.be/u2bMCVbcQqc';
            } else if (selectedxTypeItem == LocaleData.A_D_Heavy_Decline_Sit_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_D_Heavy_Decline_Sit_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_D_Heavy_Updominal_Hip_Thrust) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_D_Heavy_Updominal_Hip_Thrust.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_D_Russian_Twist) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_D_Russian_Twist.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_D_Weighted_Decline_Crunch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_D_Weighted_Decline_Crunch.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_M_Abdominal_Crunch_Machine) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Abdominal_Crunch_Machine.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_M_Cable_Side_Bend) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Cable_Side_Bend.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_M_Cable_Twist) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Cable_Twist.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_M_Hanging_Knee_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Hanging_Knee_Raise.png';
              videoURL = 'https://youtu.be/XZQzqapu-DE';
            } else if (selectedxTypeItem == LocaleData.A_M_Hanging_Leg_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Hanging_Leg_Raise.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_M_Tods_To_Bar) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_M_Tods_To_Bar.png';
              videoURL = 'https://youtu.be/uGIXMOHc2Sg';
            } else if (selectedxTypeItem == LocaleData.A_B_45_Degree_Side_Bend) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_45_Degree_Side_Bend.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Abs_Air_Bike) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Abs_Air_Bike.png';
              videoURL = 'https://youtu.be/7k-GKzeiMmk';
            } else if (selectedxTypeItem == LocaleData.A_B_Crunch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Crunch.png';
              videoURL = 'https://youtu.be/G3cc4LdZwhg';
            } else if (selectedxTypeItem == LocaleData.A_B_Decline_Crunch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Crunch.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Decline_Reverse_Crunch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Reverse_Crunch.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Decline_Sit_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Decline_Sit_Up.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Heel_Touch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Heel_Touch.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Hollow_Position) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Hollow_Position.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Hollow_Rock) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Hollow_Rock.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Leg_Raise) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Leg_Raise.png';
              videoURL = 'https://youtu.be/5RHqSaab9RA';
            } else if (selectedxTypeItem == LocaleData.A_B_Pilates_Jackknife) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Pilates_Jackknife.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Plank) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Plank.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Reverse_Crunch) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Reverse_Crunch.png';
              videoURL = 'https://youtu.be/pVwPV9z8A44';
            } else if (selectedxTypeItem == LocaleData.A_B_Side_Crunches) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Side_Crunches.png';
              videoURL = 'https://youtu.be/M9404UBHLSE';
            } else if (selectedxTypeItem == LocaleData.A_B_Side_Plank) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Side_Plank.png';
              videoURL = '';
            } else if (selectedxTypeItem == LocaleData.A_B_Sit_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Sit_Up.png';
              videoURL = 'https://youtu.be/HDrWX5_JSzM';
            } else if (selectedxTypeItem == LocaleData.A_B_Updominal_Hip_Thrust) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_Updominal_Hip_Thrust.png';
              videoURL = 'https://youtu.be/uENEi455Ozo';
            } else if (selectedxTypeItem == LocaleData.A_B_V_Up) {
              selectedxTypeImgpath = 'assets/img/workoutType/A_B_V_Up.png';
              videoURL = '';
            } else {
              videoURL = 'default';
            }

            if (videoURL == '') {
              videoURL = 'default';
            }

            for (int countindex = xlogs.length - 1; countindex >= 0; countindex--) {
              if (xlogs[countindex].finished == true) {
                if (xlogs[countindex].xType == selectedxTypeItem) {
                  recentLog = xlogs[countindex];
                  recentLogcount = 1;

                  break;
                }
              }
            }

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 0.1,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: Stack(
                children: [
                  // 추가된 운동 목록 지우기쉽게(완료) + 위치 바꾸기(미구현)
                  (todayaddcount >= 1)
                      ? Align(
                          alignment: Alignment(Alignment.bottomCenter.x + 0.95, Alignment.bottomCenter.y),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Badge(
                              alignment: Alignment.topCenter,
                              label: Text(
                                '$todayaddcountComplete/$todayaddcount',
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: FloatingActionButton(
                                heroTag: "btn3",

                                elevation: 2,

                                // label: Text(
                                //   LocaleData.toDo.getString((context)),
                                // ),
                                child: const Icon(Icons.checklist_outlined),
                                onPressed: () async {
                                  //
                                  if (isSelectedYoutube == true) {
                                    isSelectedYoutube = false;
                                    setState(() {});
                                  }
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) => StatefulBuilder(
                                      builder: (context, setState) => Wrap(
                                        // spacing: 60, // Add spacing between the child widgets.
                                        children: <Widget>[
                                          // Add a container with height to create some space.

                                          // Add a text widget with a title for the sheet.
                                          Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    (todayaddcount <= 5)
                                                        ? ClipRRect(borderRadius: BorderRadius.circular(15.0), child: Image.asset('./assets/img/womanTodo.gif'))
                                                        : Container(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
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
                                                        Text(
                                                          "${todaydate.month}/${todaydate.day} ${LocaleData.toDo.getString((context))}",
                                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(),
                                                        const SizedBox(),
                                                        const SizedBox(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Container(height: 2), // Add some more space.

                                          // Add a text widget with a long description for the sheet.
                                          // 타일 추가할 공간
                                          SizedBox(
                                            height: (todayaddcount <= 5) ? media.height * 0.770 - media.width : media.height * 0.770,
                                            child: ListView(
                                              // physics: const NeverScrollableScrollPhysics(),
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

                                          Container(
                                            height: 100,
                                            width: double.infinity,
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0, left: 8.0, right: 8.0),
                                              child: FloatingActionButton.extended(
                                                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                                heroTag: 'btn3',
                                                elevation: 1,
                                                label: Text(
                                                  LocaleData.close.getString((context)),
                                                ),
                                                icon: const Icon(Icons.close),
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
                        )
                      : Container(),

                  (isselectedWritting == false)
                      ? Align(
                          alignment: Alignment(Alignment.bottomCenter.x - 0.95, Alignment.bottomCenter.y),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              heroTag: 'btn2',
                              elevation: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  ratios[_ratio]!,
                                ),
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    setState(() {
                                      _ratio = (_ratio + 1) % 3;
                                    });
                                  },
                                );
                                _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
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
                              clipBehavior: Clip.antiAlias,
                              heroTag: 'btn1',
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              elevation: 2,
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  LocaleData.add.getString((context)),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: () async {
                                if (isSelectedYoutube == true) {
                                  isSelectedYoutube = false;
                                  setState(() {});
                                }
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
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              heroTag: 'btn1',
                              elevation: 1,
                              label: Text(
                                LocaleData.close.getString((context)),
                              ),
                              icon: const Icon(Icons.close),
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
              body: SingleChildScrollView(
                physics: (isselectedWritting == false)
                    ? (_ratio == 2)
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics()
                    :
                    //const ScrollPhysics(),
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
                              '  ${LocaleData.workoutdiary.getString(context)}',
                              style: TextStyle(
                                fontSize: xlogcreateviewtitlefontSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            FlutterSwitch(
                              // active
                              activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
                              activeTextColor: Theme.of(context).colorScheme.primaryContainer,
                              toggleColor: Theme.of(context).colorScheme.primaryContainer,
                              // inactive
                              inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
                              inactiveToggleColor: Theme.of(context).colorScheme.outline,
                              inactiveTextColor: Theme.of(context).colorScheme.outline,
                              inactiveSwitchBorder: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),

                              width: 68,
                              height: 42,
                              showOnOff: true,
                              activeText: LocaleData.LOGO.getString(context),
                              inactiveText: LocaleData.logo.getString(context),
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
                                          SizedBox(
                                            height: 48,
                                            width: double.infinity,
                                            child: RoundButton(
                                              type: RoundButtonType.textGradient,
                                              onPressed: () {
                                                showRewardedInterstitialAd();
                                                setState(() {});
                                              },
                                              title: LocaleData.seeAds.getString((context)),
                                            ),
                                          ),
                                          Container(height: 8),
                                          SizedBox(
                                            height: 48,
                                            width: double.infinity,
                                            child: RoundButton(
                                              type: RoundButtonType.textGradient,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: LocaleData.back_button_text.getString((context)),
                                            ),
                                          ),
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
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                color: Theme.of(context).colorScheme.onPrimary,
                                onPressed: (() {
                                  gaEvent('click_CalendarScreen', {
                                    'color': 'purple',
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => XlogXimgDateCalendarView(
                                                xlogs: xlogs,
                                                ximgs: ximgs,
                                                weightUnits: selectedWeighUnint,
                                              ))).then((value) {
                                    _update();
                                  });
                                }),
                                icon: const Icon(Icons.date_range_rounded),
                              ),
                            ),
                            IconButton(
                                onPressed: (() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingView(
                                                weightUnits: selectedWeighUnint,
                                              ))).then((value) {
                                    _update();
                                  });
                                }),
                                icon: const Icon(Icons.settings)),
                          ],
                        )
                      ],
                    ),

                    //002. photo view zone
                    Screenshot(
                      controller: screenshotController,
                      child: SizedBox(
                        height: media.width * ratiosMultiply[_ratio]!,
                        width: media.width * 1.00,
                        child: Stack(alignment: Alignment.center, children: [
                          if (todayaddimgcount == 0)
                            Container(
                              height: media.width * ratiosMultiply[_ratio]!,
                              width: media.width * 1.00,
                              color: Colors.black,
                              child: Image.asset(
                                ('./assets/img/manIntro.gif'),
                                fit: BoxFit.fill,
                              ),
                            ),
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
                                decoration: BoxDecoration(
                                  color: stylebackgroundColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: FittedBox(
                                  child: ((_timeformat % 3) + 1 == 1)
                                      ? TimerBuilder.periodic(
                                          (const Duration(seconds: 1)),
                                          builder: (context) => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat((' M/ d ')).format(DateTime.now()),
                                                    style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                  ),
                                                  Text(
                                                    DateFormat.E('${LocaleData.locale.getString(context)}').format(DateTime.now()),
                                                    style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                  ),
                                                  const Text(" "),
                                                ],
                                              ),
                                              Text(
                                                DateFormat((' a hh:mm:ss ')).format(DateTime.now()),
                                                style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ((_timeformat % 3) + 1 == 2)
                                          ? TimerBuilder.periodic(
                                              (const Duration(minutes: 1)),
                                              builder: (context) => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        DateFormat((' M/ d ')).format(DateTime.now()),
                                                        style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                      ),
                                                      Text(
                                                        DateFormat.E('${LocaleData.locale.getString(context)}').format(DateTime.now()),
                                                        style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                      ),
                                                      const Text(" "),
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat((' a hh:mm ')).format(DateTime.now()),
                                                    style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : TimerBuilder.periodic(
                                              (const Duration(days: 1)),
                                              builder: (context) => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        DateFormat((' M/ d ')).format(DateTime.now()),
                                                        style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                      ),
                                                      Text(
                                                        DateFormat.E('${LocaleData.locale.getString(context)}').format(DateTime.now()),
                                                        style: TextStyle(color: stylefontColor, fontSize: 16, fontWeight: FontWeight.w700),
                                                      ),
                                                      const Text(" "),
                                                    ],
                                                  ),
                                                  // Text(
                                                  //   DateFormat((' a hh:mm:ss ')).format(DateTime.now()),
                                                  //   style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
                                                  // ),
                                                ],
                                              ),
                                            ), //((_timeformat%3)+1==3)일 때
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
                                        decoration: BoxDecoration(
                                          color: stylebackgroundColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            ' ${LocaleData.workoutdiary.getString(context)} ',
                                            style: TextStyle(
                                              color: stylefontColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
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
                                      (_xlogformat >= 0)
                                          ? XlogCreateTile(
                                              xlog: xlogs[index],
                                              selectedweightUnit: selectedWeighUnint,
                                              xlogformat: _xlogformat,
                                              styleformat: _styleformat,
                                              onDeleted: () {
                                                setState(() {
                                                  xlogs.removeAt(index);
                                                  todayaddcount--;
                                                  todayaddcountComplete--;
                                                });
                                              },
                                            )
                                          : Container(),
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),

                    //003. photo edit tools
                    SizedBox(
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
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20), topRight: Radius.circular(20),
                                                    //  bottomLeft:, bottom left
                                                    // bottomRight: bottom right
                                                  ),
                                                ),
                                                side: BorderSide(
                                                  width: 2.0,
                                                  color: Theme.of(context).colorScheme.scrim,
                                                ),
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
                                                      msg: LocaleData.toastmessage_internetconnect.getString((context)),
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.TOP,
                                                      backgroundColor: Theme.of(context).colorScheme.error,
                                                      textColor: Theme.of(context).colorScheme.onError,
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
                                                          color: Theme.of(context).colorScheme.scrim,
                                                        ),
                                                        Text(
                                                          ' Workout',
                                                          style: TextStyle(
                                                            color: Theme.of(context).colorScheme.scrim,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(
                                                      width: 87,
                                                      child: Image.asset(
                                                        'assets/img/yt_logo_mono_light.png',
                                                        scale: 0.1,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
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
                                            icon: Icon(Icons.photo_outlined)),
                                        IconButton(
                                          onPressed: () async {
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
                                                            Ximg(date: todaydate, image: uint8List),
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
                                          icon: const Icon(Icons.camera_alt_outlined),
                                        ),

                                        // 텍스트 스티커 추가 기능
                                        (todayaddimgcount == 0)
                                            ? Container()
                                            : IconButton(
                                                onPressed: () {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          fullscreenDialog: true,
                                                          builder: (context) => TextAddView(
                                                                tempximgindex: tempximgindex,
                                                                image: tempximg.image,
                                                                tempximg: tempximg,
                                                                onSave: () async {
                                                                  {
                                                                    setState(() {});
                                                                  }
                                                                },
                                                              ))).then((value) {
                                                    _update();
                                                  });
                                                },
                                                icon: const Icon(Icons.text_fields_outlined),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                          Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                child: IconButton(
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
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // 위젯이미지 캡처 및 공유
                                      IconButton(
                                          color: Theme.of(context).colorScheme.surface,
                                          onPressed: () async {
                                            //화면캡쳐 및 공유
                                            final screenshotimage = await screenshotController.capture();
                                            // 이미지 저장 버튼
                                            if (screenshotimage == null) return;
                                            saveAndShare(screenshotimage);
                                          },
                                          icon: const Icon(Icons.share)),
                                      IconButton(
                                          color: Theme.of(context).colorScheme.surface,
                                          onPressed: () async {
                                            showToastMessage(LocaleData.toastmessage_imgsaveing.getString((context)));
                                            final screenshotimage = await screenshotController.capture();
                                            if (screenshotimage == null) return;

                                            await saveImage(screenshotimage);

                                            showToastMessage(LocaleData.toastmessage_imgsavesuccess.getString((context)));
                                          },
                                          icon: const Icon(Icons.download_rounded)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    (isselectedWritting == true) //기록중이라면 사진앨범,카메라,이미지비율조정 버튼 비활성화(안보임)
                        ? Container()
                        : SizedBox(
                            width: media.width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        IconButton.filledTonal(
                                          padding: EdgeInsets.all(12.0),
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
                                  ),
                                  //스크린샷 위의 오브젝트 스타일 변경
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        IconButton.filledTonal(
                                          padding: EdgeInsets.all(12.0),
                                          onPressed: () {
                                            if (_styleformat < 3) {
                                              _styleformat++;
                                            } else {
                                              _styleformat = 0;
                                            }

                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.font_download,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 6,
                                            right: 6,
                                            child: Text(
                                              "${_styleformat % 4 + 1}",
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ))
                                      ],
                                    ),
                                  ),
                                  //운동기록 형태 변경
                                  (todayaddcount >= 1)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              IconButton.filledTonal(
                                                padding: EdgeInsets.all(12.0),
                                                onPressed: () {
                                                  if (_xlogformat > 1) {
                                                    _xlogformat = 0;
                                                  } else {
                                                    _xlogformat++;
                                                  }
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.edit_document,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 6,
                                                right: 6,
                                                child: Text(
                                                  (_xlogformat != 2) ? "${_xlogformat % 3 + 1}" : "x",
                                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),

                    (isselectedWritting == false)
                        ? Container(height: media.height * 0.8)
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
                                  (isSelectedYoutube == false)
                                      ?
                                      //이미지
                                      SizedBox(
                                          //유튜브를 가져오면 위아래 검은줄을 안보이도록 하는 프레임
                                          height: media.width / 16 * 9, //이미지의 1400*800
                                          width: media.width,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              (recentLogcount != 1)
                                                  ? Container()
                                                  : (recentLog.xType != selectedxTypeItem)
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () async {
                                                            selectedlxweightItems = "${recentLog.lxweight.ceil()}";
                                                            selectedWeighUnint = recentLog.lxweightUnit;
                                                            if (selectedWeighUnint == 'kg') {
                                                              isSelectedkg = true;
                                                            } else {
                                                              isSelectedkg = false;
                                                            }
                                                            selectedlxnumberItem = "${recentLog.lxnumber}";
                                                            selectedlxsetItem = "${recentLog.lxset}";

                                                            lxweightIndex = recentLog.lxweight.ceil();
                                                            lxnumberIndex = recentLog.lxnumber - 1;
                                                            lxsetIndex = recentLog.lxset - 1;

                                                            isSelectedRecentLog = true;
                                                            setState(() {});
                                                            Future.delayed(const Duration(milliseconds: 50), () {
                                                              isSelectedRecentLog = false;
                                                              setState(() {});
                                                            });
                                                          },
                                                          child: SizedBox(
                                                            height: 20,
                                                            width: media.width,
                                                            // color: Colors.black.withOpacity(0.5),
                                                            child: Row(
                                                              children: [
                                                                // //운동종류
                                                                const SizedBox(width: 12.0),
                                                                Container(
                                                                  width: (media.width * selectedXtypewidth),
                                                                  alignment: Alignment.centerRight,
                                                                  child: FittedBox(
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.date_range_rounded,
                                                                          size: 16.0,
                                                                        ),
                                                                        Text(
                                                                          ' ${recentLog.lxdate.year}/${recentLog.lxdate.month}/${recentLog.lxdate.day}',
                                                                          style: TextStyle(
                                                                            color: Colors.black,
                                                                            // fontSize: logTextSizeselected,
                                                                            fontWeight: logTextFontselectedWeight,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                // //운동 중량
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  width: media.width * selectedXweight,
                                                                  child: Text(
                                                                    '   ${recentLog.lxweight * 0.5}${recentLog.lxweightUnit}',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      // fontSize: logTextSizeselected,
                                                                      fontWeight: logTextFontselectedWeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // //운동횟수
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  width: media.width * selectedXnumber,
                                                                  child: Text(
                                                                    '${recentLog.lxnumber} ',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      // fontSize: logTextSizeselected,
                                                                      fontWeight: logTextFontselectedWeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // //운동세트수
                                                                Container(
                                                                  alignment: Alignment.centerLeft,
                                                                  width: media.width * selectedXset,
                                                                  child: Text(
                                                                    'x     ${recentLog.lxset}',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      // fontSize: logTextSizeselected,
                                                                      fontWeight: logTextFontselectedWeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                            ],
                                          ),
                                        )
                                      :
                                      //유튜브
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
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: RoundButton(
                                            title: (bodyPart.koreanName == '하체')
                                                ? LocaleData.legs.getString((context))
                                                : (bodyPart.koreanName == '어깨')
                                                    ? LocaleData.shoulders.getString((context))
                                                    : (bodyPart.koreanName == '가슴')
                                                        ? LocaleData.chest.getString((context))
                                                        : (bodyPart.koreanName == '팔')
                                                            ? LocaleData.arms.getString((context))
                                                            : (bodyPart.koreanName == '등')
                                                                ? LocaleData.back.getString((context))
                                                                : LocaleData.abs.getString((context)),
                                            type: (_isbodypartcontroller == bodyPart.koreanName) ? RoundButtonType.selected : RoundButtonType.textGradient,
                                            fontWeight: FontWeight.w700,
                                            onPressed: () {
                                              if (isSelectedYoutube == true) {
                                                isSelectedYoutube = false;
                                                setState(() {});
                                              }
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
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 005. Easy workout dial selector
                              Builder(builder: (context) {
                                return Stack(
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
                                                height: logheightmargin,
                                              ),
                                              SizedBox(
                                                height: 20,
                                                child: Text(
                                                  LocaleData.workOut.getString((context)),
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: logTextSize,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
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
                                                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                                                    //Specify the height of lxsetItem
                                                    itemExtent: cupertinoPickeritemExtent,
                                                    //Enter a list of exerciseItems to select

                                                    children: List.generate(
                                                      exerciseItems.length,
                                                      (xTypeIndex) {
                                                        final isSelected = this.xTypeIndex == xTypeIndex;
                                                        // 번역 된 운동으로 보여주기
                                                        final lxsetItem = exerciseItems[xTypeIndex].getString(context);

                                                        final color = isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.outline;

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
                                                height: 20,
                                                child: Text(
                                                  (selectedlxweightItems == '0') ? ' ' : selectedWeighUnint,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: logTextSize,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height: cupertinoPickerHeight,
                                                width: media.width * selectedXweight,
                                                child: (isSelectedRecentLog == true)
                                                    ? Container()
                                                    : CupertinoPicker(
                                                        looping: false,
                                                        scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxweightItems)),
                                                        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                                                        //Specify the height of lxsetItem
                                                        itemExtent: cupertinoPickeritemExtent,
                                                        //Enter a list of lxweightItems to select

                                                        children: List.generate(lxweightItems.length, (lxweightIndex) {
                                                          final isSelected = this.lxweightIndex == lxweightIndex;
                                                          final lxsetItem = lxweightItems[lxweightIndex];
                                                          final color = isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.outline;

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
                                                height: 20,
                                                child: Text(
                                                  (LocaleData.reps.getString((context)).length < 4)
                                                      ? LocaleData.reps.getString((context))
                                                      : LocaleData.reps.getString((context)).substring(0, 3),
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: logTextSize,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: cupertinoPickerHeight,
                                                width: media.width * selectedXnumber,
                                                child: (isSelectedRecentLog == true)
                                                    ? Container()
                                                    : CupertinoPicker(
                                                        looping: false,
                                                        scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxnumberItem) - 1),
                                                        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(),
                                                        //Specify the height of lxsetItem
                                                        itemExtent: cupertinoPickeritemExtent,
                                                        //Enter a list of lxnumberItems to select

                                                        children: List.generate(lxnumberItems.length, (lxnumberIndex) {
                                                          final isSelected = this.lxnumberIndex == lxnumberIndex;
                                                          final lxsetItem = lxnumberItems[lxnumberIndex];
                                                          final color = isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.outline;

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
                                              SizedBox(
                                                height: logheightmargin,
                                                width: media.width * selectedXset,
                                              ),
                                              SizedBox(
                                                height: 20,
                                                child: Text(
                                                  (LocaleData.sets.getString((context)).length < 4)
                                                      ? LocaleData.sets.getString((context))
                                                      : LocaleData.sets.getString((context)).substring(0, 3),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: logTextSize,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: cupertinoPickerHeight,
                                                width: media.width * selectedXset,
                                                child: (isSelectedRecentLog == true)
                                                    ? Container()
                                                    : CupertinoPicker(
                                                        looping: false,
                                                        scrollController: FixedExtentScrollController(initialItem: int.parse(selectedlxsetItem) - 1),
                                                        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(),
                                                        //Specify the height of lxsetItem
                                                        itemExtent: cupertinoPickeritemExtent,
                                                        //Enter a list of lxsetItems to select

                                                        children: List.generate(lxsetItems.length, (lxsetIndex) {
                                                          final isSelected = this.lxsetIndex == lxsetIndex;
                                                          final lxsetItem = lxsetItems[lxsetIndex];
                                                          final color = isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.outline;

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
                                          backgroundColor: Theme.of(context).colorScheme.primary,
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
                                                        //1:어제날짜 //테스트,
                                                        todaydate.subtract(const Duration(days: 0)),
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
                                            showToastMessage(LocaleData.toastmessage_registernumberexceeded.getString((context)));
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
                                                    selectedxTypeItem.getString(context),
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                      fontSize: logTextSizeselected,
                                                      fontWeight: logTextFontselectedWeight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // //운동 중량
                                              Container(
                                                alignment: Alignment.center,
                                                width: media.width * selectedXweight,
                                                child: Text(
                                                  (selectedlxweightItems == '0') ? ' ' : '${int.parse(selectedlxweightItems) * 0.5}',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    fontSize: logTextSizeselected,
                                                    fontWeight: logTextFontselectedWeight,
                                                  ),
                                                ),
                                              ),
                                              // //운동횟수
                                              Container(
                                                alignment: Alignment.center,
                                                width: media.width * selectedXnumber,
                                                child: Text(
                                                  selectedlxnumberItem,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    fontSize: logTextSizeselected,
                                                    fontWeight: logTextFontselectedWeight,
                                                  ),
                                                ),
                                              ),
                                              // //운동세트수
                                              Container(
                                                alignment: Alignment.center,
                                                width: media.width * selectedXset,
                                                child: Text(
                                                  selectedlxsetItem,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    fontSize: logTextSizeselected,
                                                    fontWeight: logTextFontselectedWeight,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // 기록추가부분
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 8),
                                  SizedBox(
                                    height: 30,
                                    // width: media.width * selectedXtypewidth,
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.filter_alt,
                                            size: 16,
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              if (isSelectedYoutube == true) {
                                                isSelectedYoutube = false;
                                                setState(() {});
                                              }
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
                                              side: (isSelectedBabel == true)
                                                  ? BorderSide(
                                                      width: 2.0,
                                                      color: Theme.of(context).colorScheme.inverseSurface,
                                                    )
                                                  : null,
                                              backgroundColor: (isSelectedBabel == true) ? Theme.of(context).colorScheme.secondaryContainer : null,
                                              minimumSize: Size.zero,
                                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: Text(
                                              LocaleData.babel.getString((context)),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          OutlinedButton(
                                            onPressed: () {
                                              if (isSelectedYoutube == true) {
                                                isSelectedYoutube = false;
                                                setState(() {});
                                              }
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
                                              side: (isSelectedDumbbell == true)
                                                  ? BorderSide(
                                                      width: 2.0,
                                                      color: Theme.of(context).colorScheme.inverseSurface,
                                                    )
                                                  : null,
                                              backgroundColor: (isSelectedDumbbell == true) ? Theme.of(context).colorScheme.secondaryContainer : null,
                                              minimumSize: Size.zero,
                                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: Text(
                                              LocaleData.dumbbell.getString((context)),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          OutlinedButton(
                                            onPressed: () {
                                              if (isSelectedYoutube == true) {
                                                isSelectedYoutube = false;
                                                setState(() {});
                                              }
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
                                              side: (isSelectedMachine == true)
                                                  ? BorderSide(
                                                      width: 2.0,
                                                      color: Theme.of(context).colorScheme.inverseSurface,
                                                    )
                                                  : null,
                                              backgroundColor: (isSelectedMachine == true) ? Theme.of(context).colorScheme.secondaryContainer : null,
                                              minimumSize: Size.zero,
                                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: Text(
                                              LocaleData.machine.getString((context)),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          OutlinedButton(
                                            onPressed: () {
                                              if (isSelectedYoutube == true) {
                                                isSelectedYoutube = false;
                                                setState(() {});
                                              }
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
                                              side: (isSelectedBodyweight == true)
                                                  ? BorderSide(
                                                      width: 2.0,
                                                      color: Theme.of(context).colorScheme.inverseSurface,
                                                    )
                                                  : null,
                                              backgroundColor: (isSelectedBodyweight == true) ? Theme.of(context).colorScheme.secondaryContainer : null,
                                              minimumSize: Size.zero,
                                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: Text(
                                              LocaleData.bodyweight.getString((context)),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                              ),
                                            ),
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
                                height: media.height * 72 / 844, //아이폰13을 기준으로 맞춤
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
        adUnitId: Platform.isIOS
            ?
            // // 배포용
            'ca-app-pub-9398946924743018/6574107704' //my ios key
            : 'ca-app-pub-9398946924743018/8074891633', //my android key

        //테스트용
        // 'ca-app-pub-3940256099942544/6978759866'
        // : 'ca-app-pub-3940256099942544/6978759866',
        // 테스트 데모 https://developers.google.com/admob/ios/test-ads?hl=ko#demo_ad_units

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

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      debugPrint('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('$ad onAdShowedFullScreenContent.');

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
      isselectedlog = false;
      setState(() {});
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
