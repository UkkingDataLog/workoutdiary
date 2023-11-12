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
  // define
  // setting
  static const String locale = 'locale';
  static const String workoutdiary = 'workoutdiary';
  static const String LOGO = 'LOGO';
  static const String logo = 'logo';
  static const String setting = 'setting';
  static const String usersetting = 'usersetting';
  static const String language = 'language';
  static const String selectedLanguage = 'selectedLanguage';
  static const String units = 'units';
  static const String more = 'more';
  static const String dataInitialization = 'dataInitialization';
  static const String dataInitializationBody = 'dataInitializationBody';
  static const String deleteButtonText = 'deleteButtonText';
  static const String dataInitializationToastmessage = 'dataInitializationToastmessage';
  static const String dataInitializationNotToastmessage = 'dataInitializationNotToastmessage';
  static const String termsOfUse = 'termsOfUse';
  static const String toDevelopers = 'toDevelopers';
  static const String feedback = 'feedback';
  static const String version = 'version';
  static const String feedbackEmailBody = 'feedbackEmailBody';
  static const String back_button_text = 'back_button_text';
  static const String sendEmailButtonText = 'sendEmailButtonText';
  static const String Inquiry = 'Inquiry';
  static const String InquiryEmailBody = 'InquiryEmailBody';
  static const String screenRatio = 'screenRatio';
  static const String title = 'title';
  static const String body = 'body';
  // ximg, xlog home
  static const String seeAds = 'seeAds';
  static const String add = 'add';
  static const String toDo = 'toDo';
  static const String workOut = 'workOut';
  static const String reps = 'reps';
  static const String sets = 'sets';
  static const String close = 'close';
  static const String legs = 'legs';
  static const String shoulders = 'shoulders';
  static const String chest = 'chest';
  static const String arms = 'arms';
  static const String back = 'back';
  static const String abs = 'abs';
  static const String babel = 'babel';
  static const String dumbbell = 'dumbbell';
  static const String machine = 'machine';
  static const String bodyweight = 'bodyweight';
  static const String toastmessage_imgsaveing = 'toastmessage_imgsaveing';
  static const String toastmessage_imgsavesuccess = 'toastmessage_imgsavesuccess';
  static const String toastmessage_registernumberexceeded = 'toastmessage_registernumberexceeded';
  static const String toastmessage_internetconnect = 'toastmessage_internetconnect';
  static const String viewtitle_calendar = 'viewtitle_calendar';
  static const String slogan = 'slogan';
  //
  static const String L_B_Barbell_Glute_Bridge = 'L_B_Barbell_Glute_Bridge';
  static const String L_B_Sumo_Deadlift = 'L_B_Sumo_Deadlift';
  static const String L_B_Barbell_Back_Squat = 'L_B_Barbell_Back_Squat';
  static const String L_B_Barbell_Bulgarian_Split_Squat = 'L_B_Barbell_Bulgarian_Split_Squat';
  static const String L_B_Barbell_Front_Squat = 'L_B_Barbell_Front_Squat';
  static const String L_B_Barbell_Hack_Squat = 'L_B_Barbell_Hack_Squat';
  static const String L_B_Barbell_Lateral_Lunge = 'L_B_Barbell_Lateral_Lunge';
  static const String L_B_Barbell_Lunge = 'L_B_Barbell_Lunge';
  static const String L_B_Conventional_Deadlift = 'L_B_Conventional_Deadlift';
  static const String L_B_Deficit_Deadlift = 'L_B_Deficit_Deadlift';
  static const String L_B_Romanian_Deadlift = 'L_B_Romanian_Deadlift';
  static const String L_B_Barbell_Front_Rack_Lunge = 'L_B_Barbell_Front_Rack_Lunge';
  static const String L_B_Barbell_Hip_Thrust = 'L_B_Barbell_Hip_Thrust';
  static const String L_B_Barbell_Jump_Squat = 'L_B_Barbell_Jump_Squat';
  static const String L_B_Barbell_One_Leg_Deadlift = 'L_B_Barbell_One_Leg_Deadlift';
  static const String L_B_Barbell_Split_Squat = 'L_B_Barbell_Split_Squat';
  static const String L_B_Barbell_Standing_Calf_Raise = 'L_B_Barbell_Standing_Calf_Raise';
  static const String L_B_Barbell_Sumo_Squat = 'L_B_Barbell_Sumo_Squat';
  static const String L_B_Trap_Bar_Deadlift = 'L_B_Trap_Bar_Deadlift';
  static const String L_B_Zercher_Squat = 'L_B_Zercher_Squat';
  static const String L_D_Dumbbell_Lateral_Lunge = 'L_D_Dumbbell_Lateral_Lunge';
  static const String L_D_Dumbbell_Sumo_Deadlift = 'L_D_Dumbbell_Sumo_Deadlift';
  static const String L_D_Dumbbell_Bulgarian_Split_Squat = 'L_D_Dumbbell_Bulgarian_Split_Squat';
  static const String L_D_Dumbbell_Goblet_Squat = 'L_D_Dumbbell_Goblet_Squat';
  static const String L_D_Dumbbell_Lunge = 'L_D_Dumbbell_Lunge';
  static const String L_D_Dumbbell_Squat = 'L_D_Dumbbell_Squat';
  static const String L_D_Dumbbell_Sumo_Squat = 'L_D_Dumbbell_Sumo_Squat';
  static const String L_D_Dumbbell_Romanian_Deadlift = 'L_D_Dumbbell_Romanian_Deadlift';
  static const String L_D_Dumbbell_Calf_Raise = 'L_D_Dumbbell_Calf_Raise';
  static const String L_D_Dumbbell_Leg_Curl = 'L_D_Dumbbell_Leg_Curl';
  static const String L_D_Dumbbell_One_Leg_Deadlift = 'L_D_Dumbbell_One_Leg_Deadlift';
  static const String L_D_Dumbbell_Split_Squat = 'L_D_Dumbbell_Split_Squat';
  static const String L_D_Dumbbell_Stiff_Leg_Deadlift = 'L_D_Dumbbell_Stiff_Leg_Deadlift';
  static const String L_D_Weight_Step_Up = 'L_D_Weight_Step_Up';
  static const String L_M_Glute_Kickback_Machine = 'L_M_Glute_Kickback_Machine';
  static const String L_M_Leg_Extension = 'L_M_Leg_Extension';
  static const String L_M_Leg_Press = 'L_M_Leg_Press';
  static const String L_M_Leg_Curl = 'L_M_Leg_Curl';
  static const String L_M_Cable_Donkey_Kick = 'L_M_Cable_Donkey_Kick';
  static const String L_M_Cable_Hip_Abduction = 'L_M_Cable_Hip_Abduction';
  static const String L_M_Cable_Hip_Adduction = 'L_M_Cable_Hip_Adduction';
  static const String L_M_Cable_Pull_Through = 'L_M_Cable_Pull_Through';
  static const String L_M_Hack_Squat_Machine = 'L_M_Hack_Squat_Machine';
  static const String L_M_Hip_Abduction_Machine = 'L_M_Hip_Abduction_Machine';
  static const String L_M_Hip_Thrust_Machine = 'L_M_Hip_Thrust_Machine';
  static const String L_M_Horizontal_Leg_Press = 'L_M_Horizontal_Leg_Press';
  static const String L_M_Horizontal_One_Leg_Press = 'L_M_Horizontal_One_Leg_Press';
  static const String L_M_Inner_Cy_Machine = 'L_M_Inner_Cy_Machine';
  static const String L_M_Monster_Glute_Machine = 'L_M_Monster_Glute_Machine';
  static const String L_M_One_Leg_Curl = 'L_M_One_Leg_Curl';
  static const String L_M_One_Leg_Extension = 'L_M_One_Leg_Extension';
  static const String L_M_One_Leg_Press = 'L_M_One_Leg_Press';
  static const String L_M_Reverse_V_Squat = 'L_M_Reverse_V_Squat';
  static const String L_M_Seated_Calf_Raises = 'L_M_Seated_Calf_Raises';
  static const String L_M_Seated_Leg_Curl = 'L_M_Seated_Leg_Curl';
  static const String L_M_Seated_One_Leg_Curl = 'L_M_Seated_One_Leg_Curl';
  static const String L_M_Smith_Machine_Deadlift = 'L_M_Smith_Machine_Deadlift';
  static const String L_M_Smith_Machine_Split_Squat = 'L_M_Smith_Machine_Split_Squat';
  static const String L_M_Smith_Machine_Squat = 'L_M_Smith_Machine_Squat';
  static const String L_M_Standing_Calf_Raise = 'L_M_Standing_Calf_Raise';
  static const String L_M_V_Squat = 'L_M_V_Squat';
  static const String L_B_Donkey_Kick = 'L_B_Donkey_Kick';
  static const String L_B_Lunge = 'L_B_Lunge';
  static const String L_B_Glute_Bridge = 'L_B_Glute_Bridge';
  static const String L_B_Nordic_Hamstring_Curl = 'L_B_Nordic_Hamstring_Curl';
  static const String L_B_Air_Squat = 'L_B_Air_Squat';
  static const String L_B_Body_Calf_Raise = 'L_B_Body_Calf_Raise';
  static const String L_B_Bodyweight_Lateral_Lunge = 'L_B_Bodyweight_Lateral_Lunge';
  static const String L_B_Bodyweight_One_Leg_Deadlift = 'L_B_Bodyweight_One_Leg_Deadlift';
  static const String L_B_Bodyweight_Overhead_Squat = 'L_B_Bodyweight_Overhead_Squat';
  static const String L_B_Bodyweight_Split_Squat = 'L_B_Bodyweight_Split_Squat';
  static const String L_B_Hip_Thrust = 'L_B_Hip_Thrust';
  static const String L_B_Jump_Squat = 'L_B_Jump_Squat';
  static const String L_B_Lunge_Twist = 'L_B_Lunge_Twist';
  static const String L_B_Lying_Hip_Abduction = 'L_B_Lying_Hip_Abduction';
  static const String L_B_Pistol_Squat = 'L_B_Pistol_Squat';
  static const String L_B_Side_Lying_Clam = 'L_B_Side_Lying_Clam';
  static const String L_B_Single_Leg_Glute_Bridge = 'L_B_Single_Leg_Glute_Bridge';
  static const String L_B_Step_Up = 'L_B_Step_Up';
  static const String L_B_Sumo_Air_Squat = 'L_B_Sumo_Air_Squat';
  static const String S_B_Barbell_Overhead_Press = 'S_B_Barbell_Overhead_Press';
  static const String S_B_Barbell_Front_Raise = 'S_B_Barbell_Front_Raise';
  static const String S_B_Barbell_Shrug = 'S_B_Barbell_Shrug';
  static const String S_B_Barbell_Upright_Row = 'S_B_Barbell_Upright_Row';
  static const String S_B_Easy_Bar_Front_Raise = 'S_B_Easy_Bar_Front_Raise';
  static const String S_B_Easy_Bar_Upright_Row = 'S_B_Easy_Bar_Upright_Row';
  static const String S_B_Plate_Shoulder_Press = 'S_B_Plate_Shoulder_Press';
  static const String S_B_Push_Press = 'S_B_Push_Press';
  static const String S_B_Seated_Barbell_Shoulder_Press = 'S_B_Seated_Barbell_Shoulder_Press';
  static const String S_D_Arnold_Dumbbell_Press = 'S_D_Arnold_Dumbbell_Press';
  static const String S_D_Bentover_Dumbbell_Lateral_Raise = 'S_D_Bentover_Dumbbell_Lateral_Raise';
  static const String S_D_Dumbbell_Front_Raise = 'S_D_Dumbbell_Front_Raise';
  static const String S_D_Dumbbell_Lateral_Raise = 'S_D_Dumbbell_Lateral_Raise';
  static const String S_D_Dumbbell_Shoulder_Press = 'S_D_Dumbbell_Shoulder_Press';
  static const String S_D_Dumbbell_Shrug = 'S_D_Dumbbell_Shrug';
  static const String S_D_Dumbbell_Upright_Row = 'S_D_Dumbbell_Upright_Row';
  static const String S_D_Dumbbell_Y_Raise = 'S_D_Dumbbell_Y_Raise';
  static const String S_D_Seated_Dumbbell_Rear_Lateral_Raise = 'S_D_Seated_Dumbbell_Rear_Lateral_Raise';
  static const String S_D_Seated_Dumbbell_Shoulder_Press = 'S_D_Seated_Dumbbell_Shoulder_Press';
  static const String S_M_Behind_Neck_Press = 'S_M_Behind_Neck_Press';
  static const String S_M_Cable_External_Rotation = 'S_M_Cable_External_Rotation';
  static const String S_M_Cable_Front_Raise = 'S_M_Cable_Front_Raise';
  static const String S_M_Cable_Internal_Rotation = 'S_M_Cable_Internal_Rotation';
  static const String S_M_Cable_Lateral_Raise = 'S_M_Cable_Lateral_Raise';
  static const String S_M_Cable_Reverse_Fly = 'S_M_Cable_Reverse_Fly';
  static const String S_M_Cable_Shrug = 'S_M_Cable_Shrug';
  static const String S_M_Faithfull = 'S_M_Faithfull';
  static const String S_M_Landmine_Press = 'S_M_Landmine_Press';
  static const String S_M_Lateral_Raise_Machine = 'S_M_Lateral_Raise_Machine';
  static const String S_M_One_Arm_Cable_Lateral_Raise = 'S_M_One_Arm_Cable_Lateral_Raise';
  static const String S_M_Rear_Deltoid_Fly_Machine = 'S_M_Rear_Deltoid_Fly_Machine';
  static const String S_M_Shoulder_Press_Machine = 'S_M_Shoulder_Press_Machine';
  static const String S_M_Shrug_Machine = 'S_M_Shrug_Machine';
  static const String S_M_Smith_Machine_Overhead_Press = 'S_M_Smith_Machine_Overhead_Press';
  static const String S_M_Smith_Machine_Shrug = 'S_M_Smith_Machine_Shrug';
  static const String S_M_Wonam_Landmine_Press = 'S_M_Wonam_Landmine_Press';
  static const String S_B_Handstand = 'S_B_Handstand';
  static const String S_B_Handstand_Push_Up = 'S_B_Handstand_Push_Up';
  static const String S_B_Shoulder_Tab = 'S_B_Shoulder_Tab';
  static const String S_B_Y_Raise = 'S_B_Y_Raise';
  static const String C_B_Barbell_Floor_Press = 'C_B_Barbell_Floor_Press';
  static const String C_B_Bench_Press = 'C_B_Bench_Press';
  static const String C_B_Decline_Bench_Press = 'C_B_Decline_Bench_Press';
  static const String C_B_Incline_Bench_Press = 'C_B_Incline_Bench_Press';
  static const String C_B_Spoto_Bench_Press = 'C_B_Spoto_Bench_Press';
  static const String C_D_Decline_Dumbbell_Bench_Press = 'C_D_Decline_Dumbbell_Bench_Press';
  static const String C_D_Decline_Dumbbell_Fly = 'C_D_Decline_Dumbbell_Fly';
  static const String C_D_Dumbbell_Bench_Press = 'C_D_Dumbbell_Bench_Press';
  static const String C_D_Dumbbell_Fly = 'C_D_Dumbbell_Fly';
  static const String C_D_Dumbbell_Pullover = 'C_D_Dumbbell_Pullover';
  static const String C_D_Dumbbell_Squeeze_Press = 'C_D_Dumbbell_Squeeze_Press';
  static const String C_D_Incline_Dumbbell_Bench_Press = 'C_D_Incline_Dumbbell_Bench_Press';
  static const String C_D_Incline_Dumbbell_Flyes = 'C_D_Incline_Dumbbell_Flyes';
  static const String C_D_Incline_Dumbbell_Twist_Press = 'C_D_Incline_Dumbbell_Twist_Press';
  static const String C_D_Weighted_Dips = 'C_D_Weighted_Dips';
  static const String C_M_Assist_Dips_Machine = 'C_M_Assist_Dips_Machine';
  static const String C_M_Cable_Crossover = 'C_M_Cable_Crossover';
  static const String C_M_Chest_Press_Machine = 'C_M_Chest_Press_Machine';
  static const String C_M_Decline_Chest_Press_Machine = 'C_M_Decline_Chest_Press_Machine';
  static const String C_M_Hammer_Bench_Press = 'C_M_Hammer_Bench_Press';
  static const String C_M_Incline_Bench_Press_Machine = 'C_M_Incline_Bench_Press_Machine';
  static const String C_M_Incline_Cable_Fly = 'C_M_Incline_Cable_Fly';
  static const String C_M_Incline_Chest_Press_Machine = 'C_M_Incline_Chest_Press_Machine';
  static const String C_M_Low_Pulley_Cable_Fly = 'C_M_Low_Pulley_Cable_Fly';
  static const String C_M_Peck_Deck_Fly_Machine = 'C_M_Peck_Deck_Fly_Machine';
  static const String C_M_Seated_Dips_Machine = 'C_M_Seated_Dips_Machine';
  static const String C_M_Smith_Machine_Bench_Press = 'C_M_Smith_Machine_Bench_Press';
  static const String C_M_Smith_Machine_Inline_Bench_Press = 'C_M_Smith_Machine_Inline_Bench_Press';
  static const String C_M_Standing_Cable_Fly = 'C_M_Standing_Cable_Fly';
  static const String C_B_Archer_Push_Up = 'C_B_Archer_Push_Up';
  static const String C_B_Clap_Push_Up = 'C_B_Clap_Push_Up';
  static const String C_B_Close_Grip_Push_Up = 'C_B_Close_Grip_Push_Up';
  static const String C_B_Dips = 'C_B_Dips';
  static const String C_B_Hindu_Push_Up = 'C_B_Hindu_Push_Up';
  static const String C_B_Pike_Push_Up = 'C_B_Pike_Push_Up';
  static const String C_B_Push_Up = 'C_B_Push_Up';
  static const String C_B_Weighted_Push_Ups = 'C_B_Weighted_Push_Ups';
  static const String R_B_Barbell_Curl = 'R_B_Barbell_Curl';
  static const String R_B_Barbell_Lying_Tricep_Extension = 'R_B_Barbell_Lying_Tricep_Extension';
  static const String R_B_Barbell_Preacher_Curl = 'R_B_Barbell_Preacher_Curl';
  static const String R_B_Barbell_Wrist_Curl = 'R_B_Barbell_Wrist_Curl';
  static const String R_B_Close_Grip_Bench_Press = 'R_B_Close_Grip_Bench_Press';
  static const String R_B_Easy_Bar_Curl = 'R_B_Easy_Bar_Curl';
  static const String R_B_Easy_Bar_Preacher_Curl = 'R_B_Easy_Bar_Preacher_Curl';
  static const String R_B_Easy_Bar_Wrist_Curl = 'R_B_Easy_Bar_Wrist_Curl';
  static const String R_B_List_Roller = 'R_B_List_Roller';
  static const String R_B_Reverse_Barbell_Curl = 'R_B_Reverse_Barbell_Curl';
  static const String R_B_Reverse_Barbell_Wrist_Curl = 'R_B_Reverse_Barbell_Wrist_Curl';
  static const String R_B_Skull_Crusher = 'R_B_Skull_Crusher';
  static const String R_D_Dembel_Preacher_Curl = 'R_D_Dembel_Preacher_Curl';
  static const String R_D_Dumbbell_Curl = 'R_D_Dumbbell_Curl';
  static const String R_D_Dumbbell_Hammer_Curl = 'R_D_Dumbbell_Hammer_Curl';
  static const String R_D_Dumbbell_Kickback = 'R_D_Dumbbell_Kickback';
  static const String R_D_Dumbbell_Tricep_Extension = 'R_D_Dumbbell_Tricep_Extension';
  static const String R_D_Dumbbell_Wrist_Curl = 'R_D_Dumbbell_Wrist_Curl';
  static const String R_D_Incline_Dumbbell_Curl = 'R_D_Incline_Dumbbell_Curl';
  static const String R_D_Reverse_Dumbbell_Wrist_Curl = 'R_D_Reverse_Dumbbell_Wrist_Curl';
  static const String R_D_Seated_Dumbbell_Tricep_Extension = 'R_D_Seated_Dumbbell_Tricep_Extension';
  static const String R_M_Arm_Curl_Machine = 'R_M_Arm_Curl_Machine';
  static const String R_M_Cable_Curl = 'R_M_Cable_Curl';
  static const String R_M_Cable_Hammer_Curl = 'R_M_Cable_Hammer_Curl';
  static const String R_M_Cable_Lying_Tricep_Extension = 'R_M_Cable_Lying_Tricep_Extension';
  static const String R_M_Cable_Overhead_Tricep_Extension = 'R_M_Cable_Overhead_Tricep_Extension';
  static const String R_M_Cable_Push_Down = 'R_M_Cable_Push_Down';
  static const String R_M_Cable_Tricep_Extension = 'R_M_Cable_Tricep_Extension';
  static const String R_M_Preacher_Curl_Machine = 'R_M_Preacher_Curl_Machine';
  static const String R_M_Tricep_Extension_Machine = 'R_M_Tricep_Extension_Machine';
  static const String R_B_Bench_Dips = 'R_B_Bench_Dips';
  static const String B_B_Barbell_Pullover = 'B_B_Barbell_Pullover';
  static const String B_B_Barbell_Row = 'B_B_Barbell_Row';
  static const String B_B_Good_Morning_Exercise = 'B_B_Good_Morning_Exercise';
  static const String B_B_Incline_Barbell_Row = 'B_B_Incline_Barbell_Row';
  static const String B_B_Lying_Barbell_Row = 'B_B_Lying_Barbell_Row';
  static const String B_B_Pendlay_Row = 'B_B_Pendlay_Row';
  static const String B_B_Undergrip_Barbell_Row = 'B_B_Undergrip_Barbell_Row';
  static const String B_D_Dumbbell_Row = 'B_D_Dumbbell_Row';
  static const String B_D_Incline_Dumbbell_Row = 'B_D_Incline_Dumbbell_Row';
  static const String B_D_One_Arm_Dumbbell_Row = 'B_D_One_Arm_Dumbbell_Row';
  static const String B_D_Weighted_Chin_Up = 'B_D_Weighted_Chin_Up';
  static const String B_D_Weighted_Pull_Ups = 'B_D_Weighted_Pull_Ups';
  static const String B_M_Assist_Pull_Up_Machine = 'B_M_Assist_Pull_Up_Machine';
  static const String B_M_Behind_The_Neck_Pulldown = 'B_M_Behind_The_Neck_Pulldown';
  static const String B_M_Cable_Arm_Pulldown = 'B_M_Cable_Arm_Pulldown';
  static const String B_M_Floor_Seated_Cable_Row = 'B_M_Floor_Seated_Cable_Row';
  static const String B_M_Heavy_Hyperextension = 'B_M_Heavy_Hyperextension';
  static const String B_M_High_Low_Machine = 'B_M_High_Low_Machine';
  static const String B_M_Inverted_Row = 'B_M_Inverted_Row';
  static const String B_M_Lat_Pulldown = 'B_M_Lat_Pulldown';
  static const String B_M_Lateral_Wide_Pulldown = 'B_M_Lateral_Wide_Pulldown';
  static const String B_M_Mcgrip_Lat_Pulldown = 'B_M_Mcgrip_Lat_Pulldown';
  static const String B_M_One_Arm_Cable_Pull_Down = 'B_M_One_Arm_Cable_Pull_Down';
  static const String B_M_One_Arm_High_Low_Machine = 'B_M_One_Arm_High_Low_Machine';
  static const String B_M_One_Arm_Lateral_Wide_Pulldown = 'B_M_One_Arm_Lateral_Wide_Pulldown';
  static const String B_M_One_Arm_Seated_Cable_Row = 'B_M_One_Arm_Seated_Cable_Row';
  static const String B_M_One_Arm_Row_Machine = 'B_M_One_Arm_Row_Machine';
  static const String B_M_Parallel_Grip_Lat_Pulldown = 'B_M_Parallel_Grip_Lat_Pulldown';
  static const String B_M_Row_Machine = 'B_M_Row_Machine';
  static const String B_M_Seated_Cable_Row = 'B_M_Seated_Cable_Row';
  static const String B_M_Seated_Row_Machine = 'B_M_Seated_Row_Machine';
  static const String B_M_Smith_Machine_Row = 'B_M_Smith_Machine_Row';
  static const String B_M_T_Bar_Row_Machine = 'B_M_T_Bar_Row_Machine';
  static const String B_M_Undergrab_Lat_Pulldown = 'B_M_Undergrab_Lat_Pulldown';
  static const String B_M_Undergrip_High_Low_Machine = 'B_M_Undergrip_High_Low_Machine';
  static const String B_B_Back_Extension = 'B_B_Back_Extension';
  static const String B_B_Chin_Up = 'B_B_Chin_Up';
  static const String B_B_Hyper_Extension = 'B_B_Hyper_Extension';
  static const String B_B_Pull_Up = 'B_B_Pull_Up';
  static const String A_B_Abs_Rollout = 'A_B_Abs_Rollout';
  static const String A_D_Dumbbell_Side_Bend = 'A_D_Dumbbell_Side_Bend';
  static const String A_D_Heavy_Decline_Sit_Up = 'A_D_Heavy_Decline_Sit_Up';
  static const String A_D_Heavy_Updominal_Hip_Thrust = 'A_D_Heavy_Updominal_Hip_Thrust';
  static const String A_D_Russian_Twist = 'A_D_Russian_Twist';
  static const String A_D_Weighted_Decline_Crunch = 'A_D_Weighted_Decline_Crunch';
  static const String A_M_Abdominal_Crunch_Machine = 'A_M_Abdominal_Crunch_Machine';
  static const String A_M_Cable_Side_Bend = 'A_M_Cable_Side_Bend';
  static const String A_M_Cable_Twist = 'A_M_Cable_Twist';
  static const String A_M_Hanging_Knee_Raise = 'A_M_Hanging_Knee_Raise';
  static const String A_M_Hanging_Leg_Raise = 'A_M_Hanging_Leg_Raise';
  static const String A_M_Tods_To_Bar = 'A_M_Tods_To_Bar';
  static const String A_B_45_Degree_Side_Bend = 'A_B_45_Degree_Side_Bend';
  static const String A_B_Abs_Air_Bike = 'A_B_Abs_Air_Bike';
  static const String A_B_Crunch = 'A_B_Crunch';
  static const String A_B_Decline_Crunch = 'A_B_Decline_Crunch';
  static const String A_B_Decline_Reverse_Crunch = 'A_B_Decline_Reverse_Crunch';
  static const String A_B_Decline_Sit_Up = 'A_B_Decline_Sit_Up';
  static const String A_B_Heel_Touch = 'A_B_Heel_Touch';
  static const String A_B_Hollow_Position = 'A_B_Hollow_Position';
  static const String A_B_Hollow_Rock = 'A_B_Hollow_Rock';
  static const String A_B_Leg_Raise = 'A_B_Leg_Raise';
  static const String A_B_Pilates_Jackknife = 'A_B_Pilates_Jackknife';
  static const String A_B_Plank = 'A_B_Plank';
  static const String A_B_Reverse_Crunch = 'A_B_Reverse_Crunch';
  static const String A_B_Side_Crunches = 'A_B_Side_Crunches';
  static const String A_B_Side_Plank = 'A_B_Side_Plank';
  static const String A_B_Sit_Up = 'A_B_Sit_Up';
  static const String A_B_Updominal_Hip_Thrust = 'A_B_Updominal_Hip_Thrust';
  static const String A_B_V_Up = 'A_B_V_Up';

  // 영어 (English)
  static const Map<String, dynamic> EN = {
    locale: 'en',
    workoutdiary: 'Workout Diary',
    LOGO: 'LOGO',
    logo: 'logo',
    setting: 'Setting',
    usersetting: 'You',
    language: 'Language',
    selectedLanguage: 'English',
    units: 'Units',
    more: 'More',
    dataInitialization: 'Data initialization',
    dataInitializationBody: 'Delete all records stored on the device.',
    deleteButtonText: 'Yes, delete',
    dataInitializationToastmessage: 'Data has been initialized.',
    dataInitializationNotToastmessage: 'There is no data to initialize.',
    termsOfUse: 'Terms of Use',
    toDevelopers: 'To developers',
    feedback: 'Feedback',
    version: 'version',
    feedbackEmailBody: 'If you have any questions, please contact us.\nIf you let us know about improvements to the app, we will begin development immediately.',
    back_button_text: 'Back',
    sendEmailButtonText: 'Send Email',
    Inquiry: 'Inquiry',
    InquiryEmailBody:
        '---- << Inquiry >> ----\n😀 Please write in detail along with the situation. It will help us understand the content\n\n\n\n\n\n\n\n\n-- -- << Device Details >> ----',
    screenRatio: 'screen ratio',
    title: 'Localization',
    body: 'Welcome to this localized Flutter app',
    seeAds: 'see Ads',
    add: 'Add',
    toDo: 'To Do',
    workOut: 'work out',
    reps: 'rep',
    sets: 'set',
    close: 'close',
    legs: 'Legs',
    shoulders: 'Shoulders',
    chest: 'Chest',
    arms: 'Arms',
    back: 'Back',
    abs: 'Abs',
    babel: 'Babel',
    dumbbell: 'Dumbbell',
    machine: 'Machine',
    bodyweight: 'Bodyweight',
    toastmessage_imgsaveing: 'Saving!! ⏳',
    toastmessage_imgsavesuccess: 'Save success 😘',
    toastmessage_registernumberexceeded: 'Maximum exceeded 15! It\'s amazing👍',
    toastmessage_internetconnect: '❗Check your internet connection❗',
    viewtitle_calendar: 'workout calendar',
    slogan: 'Habit make me',
    //
    L_B_Barbell_Glute_Bridge: 'Barbell Glute Bridge',
    L_B_Sumo_Deadlift: 'Sumo Deadlift',
    L_B_Barbell_Back_Squat: 'Barbell Back Squat',
    L_B_Barbell_Bulgarian_Split_Squat: 'Barbell Bulgarian Split Squat',
    L_B_Barbell_Front_Squat: 'Barbell Front Squat',
    L_B_Barbell_Hack_Squat: 'Barbell Hack Squat',
    L_B_Barbell_Lateral_Lunge: 'Barbell Lateral Lunge',
    L_B_Barbell_Lunge: 'Barbell Lunge',
    L_B_Conventional_Deadlift: 'Conventional Deadlift',
    L_B_Deficit_Deadlift: 'Deficit Deadlift',
    L_B_Romanian_Deadlift: 'Romanian Deadlift',
    L_B_Barbell_Front_Rack_Lunge: 'Barbell Front Rack Lunge',
    L_B_Barbell_Hip_Thrust: 'Barbell Hip Thrust',
    L_B_Barbell_Jump_Squat: 'Barbell Jump Squat',
    L_B_Barbell_One_Leg_Deadlift: 'Barbell One Leg Deadlift',
    L_B_Barbell_Split_Squat: 'Barbell Split Squat',
    L_B_Barbell_Standing_Calf_Raise: 'Barbell Standing Calf Raise',
    L_B_Barbell_Sumo_Squat: 'Barbell Sumo Squat',
    L_B_Trap_Bar_Deadlift: 'Trap Bar Deadlift',
    L_B_Zercher_Squat: 'Zercher Squat',
    L_D_Dumbbell_Lateral_Lunge: 'Dumbbell Lateral Lunge',
    L_D_Dumbbell_Sumo_Deadlift: 'Dumbbell Sumo Deadlift',
    L_D_Dumbbell_Bulgarian_Split_Squat: 'Dumbbell Bulgarian Split Squat',
    L_D_Dumbbell_Goblet_Squat: 'Dumbbell Goblet Squat',
    L_D_Dumbbell_Lunge: 'Dumbbell Lunge',
    L_D_Dumbbell_Squat: 'Dumbbell Squat',
    L_D_Dumbbell_Sumo_Squat: 'Dumbbell Sumo Squat',
    L_D_Dumbbell_Romanian_Deadlift: 'Dumbbell Romanian Deadlift',
    L_D_Dumbbell_Calf_Raise: 'Dumbbell Calf Raise',
    L_D_Dumbbell_Leg_Curl: 'Dumbbell Leg Curl',
    L_D_Dumbbell_One_Leg_Deadlift: 'Dumbbell One Leg Deadlift',
    L_D_Dumbbell_Split_Squat: 'Dumbbell Split Squat',
    L_D_Dumbbell_Stiff_Leg_Deadlift: 'Dumbbell Stiff Leg Deadlift',
    L_D_Weight_Step_Up: 'Weight Step Up',
    L_M_Glute_Kickback_Machine: 'Glute Kickback Machine',
    L_M_Leg_Extension: 'Leg Extension',
    L_M_Leg_Press: 'Leg Press',
    L_M_Leg_Curl: 'Leg Curl',
    L_M_Cable_Donkey_Kick: 'Cable Donkey Kick',
    L_M_Cable_Hip_Abduction: 'Cable Hip Abduction',
    L_M_Cable_Hip_Adduction: 'Cable Hip Adduction',
    L_M_Cable_Pull_Through: 'Cable Pull Through',
    L_M_Hack_Squat_Machine: 'Hack Squat Machine',
    L_M_Hip_Abduction_Machine: 'Hip Abduction Machine',
    L_M_Hip_Thrust_Machine: 'Hip Thrust Machine',
    L_M_Horizontal_Leg_Press: 'Horizontal Leg Press',
    L_M_Horizontal_One_Leg_Press: 'Horizontal One Leg Press',
    L_M_Inner_Cy_Machine: 'Inner Cy Machine',
    L_M_Monster_Glute_Machine: 'Monster Glute Machine',
    L_M_One_Leg_Curl: 'One Leg Curl',
    L_M_One_Leg_Extension: 'One Leg Extension',
    L_M_One_Leg_Press: 'One Leg Press',
    L_M_Reverse_V_Squat: 'Reverse V Squat',
    L_M_Seated_Calf_Raises: 'Seated Calf Raises',
    L_M_Seated_Leg_Curl: 'Seated Leg Curl',
    L_M_Seated_One_Leg_Curl: 'Seated One Leg Curl',
    L_M_Smith_Machine_Deadlift: 'Smith Machine Deadlift',
    L_M_Smith_Machine_Split_Squat: 'Smith Machine Split Squat',
    L_M_Smith_Machine_Squat: 'Smith Machine Squat',
    L_M_Standing_Calf_Raise: 'Standing Calf Raise',
    L_M_V_Squat: 'V Squat',
    L_B_Donkey_Kick: 'Donkey Kick',
    L_B_Lunge: 'Lunge',
    L_B_Glute_Bridge: 'Glute Bridge',
    L_B_Nordic_Hamstring_Curl: 'Nordic Hamstring Curl',
    L_B_Air_Squat: 'Air Squat',
    L_B_Body_Calf_Raise: 'Body Calf Raise',
    L_B_Bodyweight_Lateral_Lunge: 'Bodyweight Lateral Lunge',
    L_B_Bodyweight_One_Leg_Deadlift: 'Bodyweight One Leg Deadlift',
    L_B_Bodyweight_Overhead_Squat: 'Bodyweight Overhead Squat',
    L_B_Bodyweight_Split_Squat: 'Bodyweight Split Squat',
    L_B_Hip_Thrust: 'Hip Thrust',
    L_B_Jump_Squat: 'Jump Squat',
    L_B_Lunge_Twist: 'Lunge Twist',
    L_B_Lying_Hip_Abduction: 'Lying Hip Abduction',
    L_B_Pistol_Squat: 'Pistol Squat',
    L_B_Side_Lying_Clam: 'Side Lying Clam',
    L_B_Single_Leg_Glute_Bridge: 'Single Leg Glute Bridge',
    L_B_Step_Up: 'Step Up',
    L_B_Sumo_Air_Squat: 'Sumo Air Squat',
    S_B_Barbell_Overhead_Press: 'Barbell Overhead Press',
    S_B_Barbell_Front_Raise: 'Barbell Front Raise',
    S_B_Barbell_Shrug: 'Barbell Shrug',
    S_B_Barbell_Upright_Row: 'Barbell Upright Row',
    S_B_Easy_Bar_Front_Raise: 'Easy Bar Front Raise',
    S_B_Easy_Bar_Upright_Row: 'Easy Bar Upright Row',
    S_B_Plate_Shoulder_Press: 'Plate Shoulder Press',
    S_B_Push_Press: 'Push Press',
    S_B_Seated_Barbell_Shoulder_Press: 'Seated Barbell Shoulder Press',
    S_D_Arnold_Dumbbell_Press: 'Arnold Dumbbell Press',
    S_D_Bentover_Dumbbell_Lateral_Raise: 'Bentover Dumbbell Lateral Raise',
    S_D_Dumbbell_Front_Raise: 'Dumbbell Front Raise',
    S_D_Dumbbell_Lateral_Raise: 'Dumbbell Lateral Raise',
    S_D_Dumbbell_Shoulder_Press: 'Dumbbell Shoulder Press',
    S_D_Dumbbell_Shrug: 'Dumbbell Shrug',
    S_D_Dumbbell_Upright_Row: 'Dumbbell Upright Row',
    S_D_Dumbbell_Y_Raise: 'Dumbbell Y Raise',
    S_D_Seated_Dumbbell_Rear_Lateral_Raise: 'Seated Dumbbell Rear Lateral Raise',
    S_D_Seated_Dumbbell_Shoulder_Press: 'Seated Dumbbell Shoulder Press',
    S_M_Behind_Neck_Press: 'Behind Neck Press',
    S_M_Cable_External_Rotation: 'Cable External Rotation',
    S_M_Cable_Front_Raise: 'Cable Front Raise',
    S_M_Cable_Internal_Rotation: 'Cable Internal Rotation',
    S_M_Cable_Lateral_Raise: 'Cable Lateral Raise',
    S_M_Cable_Reverse_Fly: 'Cable Reverse Fly',
    S_M_Cable_Shrug: 'Cable Shrug',
    S_M_Faithfull: 'Faithfull',
    S_M_Landmine_Press: 'Landmine Press',
    S_M_Lateral_Raise_Machine: 'Lateral Raise Machine',
    S_M_One_Arm_Cable_Lateral_Raise: 'One Arm Cable Lateral Raise',
    S_M_Rear_Deltoid_Fly_Machine: 'Rear Deltoid Fly Machine',
    S_M_Shoulder_Press_Machine: 'Shoulder Press Machine',
    S_M_Shrug_Machine: 'Shrug Machine',
    S_M_Smith_Machine_Overhead_Press: 'Smith Machine Overhead Press',
    S_M_Smith_Machine_Shrug: 'Smith Machine Shrug',
    S_M_Wonam_Landmine_Press: 'Wonam Landmine Press',
    S_B_Handstand: 'Handstand',
    S_B_Handstand_Push_Up: 'Handstand Push Up',
    S_B_Shoulder_Tab: 'Shoulder Tab',
    S_B_Y_Raise: 'Y Raise',
    C_B_Barbell_Floor_Press: 'Barbell Floor Press',
    C_B_Bench_Press: 'Bench Press',
    C_B_Decline_Bench_Press: 'Decline Bench Press',
    C_B_Incline_Bench_Press: 'Incline Bench Press',
    C_B_Spoto_Bench_Press: 'Spoto Bench Press',
    C_D_Decline_Dumbbell_Bench_Press: 'Decline Dumbbell Bench Press',
    C_D_Decline_Dumbbell_Fly: 'Decline Dumbbell Fly',
    C_D_Dumbbell_Bench_Press: 'Dumbbell Bench Press',
    C_D_Dumbbell_Fly: 'Dumbbell Fly',
    C_D_Dumbbell_Pullover: 'Dumbbell Pullover',
    C_D_Dumbbell_Squeeze_Press: 'Dumbbell Squeeze Press',
    C_D_Incline_Dumbbell_Bench_Press: 'Incline Dumbbell Bench Press',
    C_D_Incline_Dumbbell_Flyes: 'Incline Dumbbell Flyes',
    C_D_Incline_Dumbbell_Twist_Press: 'Incline Dumbbell Twist Press',
    C_D_Weighted_Dips: 'Weighted Dips',
    C_M_Assist_Dips_Machine: 'Assist Dips Machine',
    C_M_Cable_Crossover: 'Cable Crossover',
    C_M_Chest_Press_Machine: 'Chest Press Machine',
    C_M_Decline_Chest_Press_Machine: 'Decline Chest Press Machine',
    C_M_Hammer_Bench_Press: 'Hammer Bench Press',
    C_M_Incline_Bench_Press_Machine: 'Incline Bench Press Machine',
    C_M_Incline_Cable_Fly: 'Incline Cable Fly',
    C_M_Incline_Chest_Press_Machine: 'Incline Chest Press Machine',
    C_M_Low_Pulley_Cable_Fly: 'Low Pulley Cable Fly',
    C_M_Peck_Deck_Fly_Machine: 'Peck Deck Fly Machine',
    C_M_Seated_Dips_Machine: 'Seated Dips Machine',
    C_M_Smith_Machine_Bench_Press: 'Smith Machine Bench Press',
    C_M_Smith_Machine_Inline_Bench_Press: 'Smith Machine Inline Bench Press',
    C_M_Standing_Cable_Fly: 'Standing Cable Fly',
    C_B_Archer_Push_Up: 'Archer Push Up',
    C_B_Clap_Push_Up: 'Clap Push Up',
    C_B_Close_Grip_Push_Up: 'Close Grip Push Up',
    C_B_Dips: 'Dips',
    C_B_Hindu_Push_Up: 'Hindu Push Up',
    C_B_Pike_Push_Up: 'Pike Push Up',
    C_B_Push_Up: 'Push Up',
    C_B_Weighted_Push_Ups: 'Weighted Push Ups',
    R_B_Barbell_Curl: 'Barbell Curl',
    R_B_Barbell_Lying_Tricep_Extension: 'Barbell Lying Tricep Extension',
    R_B_Barbell_Preacher_Curl: 'Barbell Preacher Curl',
    R_B_Barbell_Wrist_Curl: 'Barbell Wrist Curl',
    R_B_Close_Grip_Bench_Press: 'Close Grip Bench Press',
    R_B_Easy_Bar_Curl: 'Easy Bar Curl',
    R_B_Easy_Bar_Preacher_Curl: 'Easy Bar Preacher Curl',
    R_B_Easy_Bar_Wrist_Curl: 'Easy Bar Wrist Curl',
    R_B_List_Roller: 'List Roller',
    R_B_Reverse_Barbell_Curl: 'Reverse Barbell Curl',
    R_B_Reverse_Barbell_Wrist_Curl: 'Reverse Barbell Wrist Curl',
    R_B_Skull_Crusher: 'Skull Crusher',
    R_D_Dembel_Preacher_Curl: 'Dembel Preacher Curl',
    R_D_Dumbbell_Curl: 'Dumbbell Curl',
    R_D_Dumbbell_Hammer_Curl: 'Dumbbell Hammer Curl',
    R_D_Dumbbell_Kickback: 'Dumbbell Kickback',
    R_D_Dumbbell_Tricep_Extension: 'Dumbbell Tricep Extension',
    R_D_Dumbbell_Wrist_Curl: 'Dumbbell Wrist Curl',
    R_D_Incline_Dumbbell_Curl: 'Incline Dumbbell Curl',
    R_D_Reverse_Dumbbell_Wrist_Curl: 'Reverse Dumbbell Wrist Curl',
    R_D_Seated_Dumbbell_Tricep_Extension: 'Seated Dumbbell Tricep Extension',
    R_M_Arm_Curl_Machine: 'Arm Curl Machine',
    R_M_Cable_Curl: 'Cable Curl',
    R_M_Cable_Hammer_Curl: 'Cable Hammer Curl',
    R_M_Cable_Lying_Tricep_Extension: 'Cable Lying Tricep Extension',
    R_M_Cable_Overhead_Tricep_Extension: 'Cable Overhead Tricep Extension',
    R_M_Cable_Push_Down: 'Cable Push Down',
    R_M_Cable_Tricep_Extension: 'Cable Tricep Extension',
    R_M_Preacher_Curl_Machine: 'Preacher Curl Machine',
    R_M_Tricep_Extension_Machine: 'Tricep Extension Machine',
    R_B_Bench_Dips: 'Bench Dips',
    B_B_Barbell_Pullover: 'Barbell Pullover',
    B_B_Barbell_Row: 'Barbell Row',
    B_B_Good_Morning_Exercise: 'Good Morning Exercise',
    B_B_Incline_Barbell_Row: 'Incline Barbell Row',
    B_B_Lying_Barbell_Row: 'Lying Barbell Row',
    B_B_Pendlay_Row: 'Pendlay Row',
    B_B_Undergrip_Barbell_Row: 'Undergrip Barbell Row',
    B_D_Dumbbell_Row: 'Dumbbell Row',
    B_D_Incline_Dumbbell_Row: 'Incline Dumbbell Row',
    B_D_One_Arm_Dumbbell_Row: 'One Arm Dumbbell Row',
    B_D_Weighted_Chin_Up: 'Weighted Chin Up',
    B_D_Weighted_Pull_Ups: 'Weighted Pull Ups',
    B_M_Assist_Pull_Up_Machine: 'Assist Pull_Up Machine',
    B_M_Behind_The_Neck_Pulldown: 'Behind The Neck Pulldown',
    B_M_Cable_Arm_Pulldown: 'Cable Arm Pulldown',
    B_M_Floor_Seated_Cable_Row: 'Floor Seated Cable Row',
    B_M_Heavy_Hyperextension: 'Heavy Hyperextension',
    B_M_High_Low_Machine: 'High Low Machine',
    B_M_Inverted_Row: 'Inverted Row',
    B_M_Lat_Pulldown: 'Lat Pulldown',
    B_M_Lateral_Wide_Pulldown: 'Lateral Wide Pulldown',
    B_M_Mcgrip_Lat_Pulldown: 'Mcgrip Lat Pulldown',
    B_M_One_Arm_Cable_Pull_Down: 'One Arm Cable Pull Down',
    B_M_One_Arm_High_Low_Machine: 'One Arm High Low Machine',
    B_M_One_Arm_Lateral_Wide_Pulldown: 'One Arm Lateral Wide Pulldown',
    B_M_One_Arm_Seated_Cable_Row: 'One Arm Seated Cable Row',
    B_M_One_Arm_Row_Machine: 'One Arm Row Machine',
    B_M_Parallel_Grip_Lat_Pulldown: 'Parallel Grip Lat Pulldown',
    B_M_Row_Machine: 'Row Machine',
    B_M_Seated_Cable_Row: 'Seated Cable Row',
    B_M_Seated_Row_Machine: 'Seated Row Machine',
    B_M_Smith_Machine_Row: 'Smith Machine Row',
    B_M_T_Bar_Row_Machine: 'T Bar Row Machine',
    B_M_Undergrab_Lat_Pulldown: 'Undergrab Lat Pulldown',
    B_M_Undergrip_High_Low_Machine: 'Undergrip High Low Machine',
    B_B_Back_Extension: 'Back Extension',
    B_B_Chin_Up: 'Chin Up',
    B_B_Hyper_Extension: 'Hyper Extension',
    B_B_Pull_Up: 'Pull Up',
    A_B_Abs_Rollout: 'Abs Rollout',
    A_D_Dumbbell_Side_Bend: 'Dumbbell Side Bend',
    A_D_Heavy_Decline_Sit_Up: 'Heavy Decline Sit Up',
    A_D_Heavy_Updominal_Hip_Thrust: 'Heavy Updominal Hip Thrust',
    A_D_Russian_Twist: 'Russian Twist',
    A_D_Weighted_Decline_Crunch: 'Weighted Decline Crunch',
    A_M_Abdominal_Crunch_Machine: 'Abdominal Crunch Machine',
    A_M_Cable_Side_Bend: 'Cable Side Bend',
    A_M_Cable_Twist: 'Cable Twist',
    A_M_Hanging_Knee_Raise: 'Hanging Knee Raise',
    A_M_Hanging_Leg_Raise: 'Hanging Leg Raise',
    A_M_Tods_To_Bar: 'Tods To Bar',
    A_B_45_Degree_Side_Bend: '45 Degree Side Bend',
    A_B_Abs_Air_Bike: 'Abs Air Bike',
    A_B_Crunch: 'Crunch',
    A_B_Decline_Crunch: 'Decline Crunch',
    A_B_Decline_Reverse_Crunch: 'Decline Reverse Crunch',
    A_B_Decline_Sit_Up: 'Decline Sit-Up',
    A_B_Heel_Touch: 'Heel Touch',
    A_B_Hollow_Position: 'Hollow Position',
    A_B_Hollow_Rock: 'Hollow Rock',
    A_B_Leg_Raise: 'Leg Raise',
    A_B_Pilates_Jackknife: 'Pilates Jackknife',
    A_B_Plank: 'Plank',
    A_B_Reverse_Crunch: 'Reverse Crunch',
    A_B_Side_Crunches: 'Side Crunches',
    A_B_Side_Plank: 'Side Plank',
    A_B_Sit_Up: 'Sit Up',
    A_B_Updominal_Hip_Thrust: 'Updominal Hip Thrust',
    A_B_V_Up: 'V Up',
  };
  // 한국어 (Korean)
  static const Map<String, dynamic> KO = {
    locale: 'ko',
    workoutdiary: 'Workout Diary',
    LOGO: 'LOGO',
    logo: 'logo',
    setting: '설정',
    usersetting: '사용자 설정',
    language: '언어',
    selectedLanguage: '한국어',
    units: '단위',
    more: '기타',
    dataInitialization: '데이터 초기화',
    dataInitializationBody: '디바이스에 저장된 모든 기록을 삭제합니다.',
    dataInitializationNotToastmessage: '초기화할 데이터가 없습니다.',
    deleteButtonText: '네, 삭제합니다',
    dataInitializationToastmessage: '데이터를 초기화했습니다.',
    termsOfUse: '이용약관',
    toDevelopers: '개발자에게',
    feedback: '피드백',
    version: '버전',
    feedbackEmailBody: '궁금한 점이 있으시다면, 연락해주세요.\n앱의 개선사항을 알려주시면 즉시 개발에 착수합니다.',
    back_button_text: '뒤로가기',
    sendEmailButtonText: '메일쓰기',
    Inquiry: '문의사항',
    InquiryEmailBody: '---- << 문의사항 >> ----\n😀 상황과 함께 구체적으로 적어주시면 내용파악에 도움이 됩니다\n\n\n\n\n\n\n\n\n---- << 디바이스사항 >> ----',
    screenRatio: '화면비',
    title: '로컬라이제이션',
    body: '이 로컬라이즈된 Flutter 앱에 오신 것을 환영합니다.',
    seeAds: '광고보기',
    add: '추가',
    toDo: '할 일',
    workOut: '운동',
    reps: '회',
    sets: '세트',
    close: '닫기',
    legs: '하체',
    shoulders: '어깨',
    chest: '가슴',
    arms: '팔',
    back: '등',
    abs: '복근',
    babel: '바벨',
    dumbbell: '덤벨',
    machine: '머신',
    bodyweight: '맨몸',
    toastmessage_imgsaveing: '저장 중!! ⏳',
    toastmessage_imgsavesuccess: '저장 성공 😘',
    toastmessage_registernumberexceeded: '등록가능 최대개수 15개를 넘었어요! 대단해요👍',
    toastmessage_internetconnect: '❗인터넷 연결을 확인해보세요❗',
    viewtitle_calendar: '운동 달력',
    slogan: 'Habit make me',
    //
    L_B_Barbell_Glute_Bridge: '바벨 글루트 브릿지',
    L_B_Sumo_Deadlift: '스모 데드리프트',
    L_B_Barbell_Back_Squat: '바벨 백 스쿼트',
    L_B_Barbell_Bulgarian_Split_Squat: '바벨 불가리안 스플릿 스쿼트',
    L_B_Barbell_Front_Squat: '바벨 프론트 스쿼트',
    L_B_Barbell_Hack_Squat: '바벨 핵 스쿼트',
    L_B_Barbell_Lateral_Lunge: '바벨 레터럴 런지',
    L_B_Barbell_Lunge: '바벨 런지',
    L_B_Conventional_Deadlift: '컨벤셔널 데드리프트',
    L_B_Deficit_Deadlift: '데피싯 데드리프트',
    L_B_Romanian_Deadlift: '루마니안 데드리프트',
    L_B_Barbell_Front_Rack_Lunge: '바벨 프론트 랙 런지',
    L_B_Barbell_Hip_Thrust: '바벨 힙 쓰러스트',
    L_B_Barbell_Jump_Squat: '바벨 점프 스쿼트',
    L_B_Barbell_One_Leg_Deadlift: '바벨 원레그 데드리프트',
    L_B_Barbell_Split_Squat: '바벨 스플릿 스쿼트',
    L_B_Barbell_Standing_Calf_Raise: '바벨 스탠딩 카프 레이즈',
    L_B_Barbell_Sumo_Squat: '바벨 스모 스쿼트',
    L_B_Trap_Bar_Deadlift: '트랩바 데드리프트',
    L_B_Zercher_Squat: '저처 스쿼트',
    L_D_Dumbbell_Lateral_Lunge: '덤벨 레터럴 런지',
    L_D_Dumbbell_Sumo_Deadlift: '덤벨 스모 데드리프트',
    L_D_Dumbbell_Bulgarian_Split_Squat: '덤벨 불가리안 스플릿 스쿼트',
    L_D_Dumbbell_Goblet_Squat: '덤벨 고블릿 스쿼트',
    L_D_Dumbbell_Lunge: '덤벨 런지',
    L_D_Dumbbell_Squat: '덤벨 스쿼트',
    L_D_Dumbbell_Sumo_Squat: '덤벨 스모 스쿼트',
    L_D_Dumbbell_Romanian_Deadlift: '덤벨 루마니안 데드리프트',
    L_D_Dumbbell_Calf_Raise: '덤벨 카프 레이즈',
    L_D_Dumbbell_Leg_Curl: '덤벨 레그컬',
    L_D_Dumbbell_One_Leg_Deadlift: '덤벨 원레그 데드리프트',
    L_D_Dumbbell_Split_Squat: '덤벨 스플릿 스쿼트',
    L_D_Dumbbell_Stiff_Leg_Deadlift: '덤벨 스티프 레그 데드리프트',
    L_D_Weight_Step_Up: '중량 스텝업',
    L_M_Glute_Kickback_Machine: '글루트 킥백 머신',
    L_M_Leg_Extension: '레그 익스텐션',
    L_M_Leg_Press: '레그 프레스',
    L_M_Leg_Curl: '레그 컬',
    L_M_Cable_Donkey_Kick: '케이블 덩키 킥',
    L_M_Cable_Hip_Abduction: '케이블 힙 어브덕션',
    L_M_Cable_Hip_Adduction: '케이블 힙 어덕션',
    L_M_Cable_Pull_Through: '케이블 풀 스루',
    L_M_Hack_Squat_Machine: '핵 스쿼트 머신',
    L_M_Hip_Abduction_Machine: '힙 어브덕션 머신',
    L_M_Hip_Thrust_Machine: '힙 쓰러스트 머신',
    L_M_Horizontal_Leg_Press: '수평 레그 프레스',
    L_M_Horizontal_One_Leg_Press: '수평 원레그 프레스',
    L_M_Inner_Cy_Machine: '이너 싸이 머신',
    L_M_Monster_Glute_Machine: '몬스터 글루트 머신',
    L_M_One_Leg_Curl: '원레그 컬',
    L_M_One_Leg_Extension: '원레그 익스텐션',
    L_M_One_Leg_Press: '원레그 프레스',
    L_M_Reverse_V_Squat: '리버스 브이 스쿼트',
    L_M_Seated_Calf_Raises: '시티드 카프 레이즈',
    L_M_Seated_Leg_Curl: '시티드 레그 컬',
    L_M_Seated_One_Leg_Curl: '시티드 원레그 컬',
    L_M_Smith_Machine_Deadlift: '스미스 머신 데드리프트',
    L_M_Smith_Machine_Split_Squat: '스미스머신 스플릿 스쿼트',
    L_M_Smith_Machine_Squat: '스미스머신 스쿼트',
    L_M_Standing_Calf_Raise: '스탠딩 카프 레이즈',
    L_M_V_Squat: '브이 스쿼트',
    L_B_Donkey_Kick: '덩키 킥',
    L_B_Lunge: '런지',
    L_B_Glute_Bridge: '글루트 브릿지',
    L_B_Nordic_Hamstring_Curl: '노르딕 햄스트링 컬',
    L_B_Air_Squat: '에어 스쿼트',
    L_B_Body_Calf_Raise: '맨몸 카프 레이즈',
    L_B_Bodyweight_Lateral_Lunge: '맨몸 레터럴 런지',
    L_B_Bodyweight_One_Leg_Deadlift: '맨몸 원레그 데드리프트',
    L_B_Bodyweight_Overhead_Squat: '맨몸 오버헤드 스쿼트',
    L_B_Bodyweight_Split_Squat: '맨몸 스플릿 스쿼트',
    L_B_Hip_Thrust: '힙 쓰러스트',
    L_B_Jump_Squat: '점프 스쿼트',
    L_B_Lunge_Twist: '런지 트위스트',
    L_B_Lying_Hip_Abduction: '라잉 힙 어브덕션',
    L_B_Pistol_Squat: '피스톨 스쿼트',
    L_B_Side_Lying_Clam: '사이드 라잉 클램',
    L_B_Single_Leg_Glute_Bridge: '싱글 레그 글루트 브릿지',
    L_B_Step_Up: '스텝업',
    L_B_Sumo_Air_Squat: '스모 에어 스쿼트',
    S_B_Barbell_Overhead_Press: '바벨 오버헤드 프레스',
    S_B_Barbell_Front_Raise: '바벨 프론트 레이즈',
    S_B_Barbell_Shrug: '바벨 슈러그',
    S_B_Barbell_Upright_Row: '바벨 업라이트 로우',
    S_B_Easy_Bar_Front_Raise: '이지바 프론트 레이즈',
    S_B_Easy_Bar_Upright_Row: '이지바 업라이트 로우',
    S_B_Plate_Shoulder_Press: '플레이트 숄더 프레스',
    S_B_Push_Press: '푸시 프레스',
    S_B_Seated_Barbell_Shoulder_Press: '시티드 바벨 숄더 프레스',
    S_D_Arnold_Dumbbell_Press: '아놀드 덤벨 프레스',
    S_D_Bentover_Dumbbell_Lateral_Raise: '벤트오버 덤벨 레터럴 레이즈',
    S_D_Dumbbell_Front_Raise: '덤벨 프론트 레이즈',
    S_D_Dumbbell_Lateral_Raise: '덤벨 레터럴 레이즈',
    S_D_Dumbbell_Shoulder_Press: '덤벨 숄더 프레스',
    S_D_Dumbbell_Shrug: '덤벨 슈러그',
    S_D_Dumbbell_Upright_Row: '덤벨 업라이트 로우',
    S_D_Dumbbell_Y_Raise: '덤벨 Y 레이즈',
    S_D_Seated_Dumbbell_Rear_Lateral_Raise: '시티드 덤벨 리어 레터럴 레이즈',
    S_D_Seated_Dumbbell_Shoulder_Press: '시티드 덤벨 숄더 프레스',
    S_M_Behind_Neck_Press: '비하인드 넥 프레스',
    S_M_Cable_External_Rotation: '케이블 익스터널 로테이션',
    S_M_Cable_Front_Raise: '케이블 프론트 레이즈',
    S_M_Cable_Internal_Rotation: '케이블 인터널 로테이션',
    S_M_Cable_Lateral_Raise: '케이블 레터럴 레이즈',
    S_M_Cable_Reverse_Fly: '케이블 리버스 플라이',
    S_M_Cable_Shrug: '케이블 슈러그',
    S_M_Faithfull: '페이스풀',
    S_M_Landmine_Press: '랜드마인 프레스',
    S_M_Lateral_Raise_Machine: '레터럴 레이즈 머신',
    S_M_One_Arm_Cable_Lateral_Raise: '원암 케이블 레터럴 레이즈',
    S_M_Rear_Deltoid_Fly_Machine: '리어 델토이드 플라이 머신',
    S_M_Shoulder_Press_Machine: '숄더 플레스 머신',
    S_M_Shrug_Machine: '슈러그 머신',
    S_M_Smith_Machine_Overhead_Press: '스미스머신 오버헤드 프레스',
    S_M_Smith_Machine_Shrug: '스미스머신 슈러그',
    S_M_Wonam_Landmine_Press: '원암 랜드마인 프레스',
    S_B_Handstand: '핸드스탠드',
    S_B_Handstand_Push_Up: '핸드스탠드 푸시업',
    S_B_Shoulder_Tab: '숄더 탭',
    S_B_Y_Raise: 'Y 레이즈',
    C_B_Barbell_Floor_Press: '바벨 플로어 프레스',
    C_B_Bench_Press: '벤치프레스',
    C_B_Decline_Bench_Press: '디클라인 벤치프레스',
    C_B_Incline_Bench_Press: '인클라인 벤치프레스',
    C_B_Spoto_Bench_Press: '스포토 벤치프레스',
    C_D_Decline_Dumbbell_Bench_Press: '디클라인 덤벨 벤치프레스',
    C_D_Decline_Dumbbell_Fly: '디클라인 덤벨 플라이',
    C_D_Dumbbell_Bench_Press: '덤벨 벤치프레스',
    C_D_Dumbbell_Fly: '덤벨 플라이',
    C_D_Dumbbell_Pullover: '덤벨 풀오버',
    C_D_Dumbbell_Squeeze_Press: '덤벨 스퀴즈 프레스',
    C_D_Incline_Dumbbell_Bench_Press: '인클라인 덤벨 벤치프레스',
    C_D_Incline_Dumbbell_Flyes: '인클라인 덤벨 플라이',
    C_D_Incline_Dumbbell_Twist_Press: '인클라인 덤벨 트위스트 프레스',
    C_D_Weighted_Dips: '중량 딥스',
    C_M_Assist_Dips_Machine: '어시스트 딥스 머신',
    C_M_Cable_Crossover: '케이블 크로스오버',
    C_M_Chest_Press_Machine: '체스트 프레스 머신',
    C_M_Decline_Chest_Press_Machine: '디클라인 체스트 프레스 머신',
    C_M_Hammer_Bench_Press: '해머 벤치프레스',
    C_M_Incline_Bench_Press_Machine: '인클라인 벤치프레스 머신',
    C_M_Incline_Cable_Fly: '인클라인 케이블 플라이',
    C_M_Incline_Chest_Press_Machine: '인클라인 체스트 프레스 머신',
    C_M_Low_Pulley_Cable_Fly: '로우 풀리 케이블 플라이',
    C_M_Peck_Deck_Fly_Machine: '펙덱 플라이 머신',
    C_M_Seated_Dips_Machine: '시티드 딥스 머신',
    C_M_Smith_Machine_Bench_Press: '스미스머신 벤치프레스',
    C_M_Smith_Machine_Inline_Bench_Press: '스미스머신 인클라인 벤치프레스',
    C_M_Standing_Cable_Fly: '스탠딩 케이블 플라이',
    C_B_Archer_Push_Up: '아처 푸시업',
    C_B_Clap_Push_Up: '클랩 푸시업',
    C_B_Close_Grip_Push_Up: '클로즈그립 푸시업',
    C_B_Dips: '딥스',
    C_B_Hindu_Push_Up: '힌두 푸시업',
    C_B_Pike_Push_Up: '파이크 푸시업',
    C_B_Push_Up: '푸시업',
    C_B_Weighted_Push_Ups: '중량 푸시업',
    R_B_Barbell_Curl: '바벨 컬',
    R_B_Barbell_Lying_Tricep_Extension: '바벨 라잉 트라이셉 익스텐션',
    R_B_Barbell_Preacher_Curl: '바벨 프리쳐 컬',
    R_B_Barbell_Wrist_Curl: '바벨 리스트 컬',
    R_B_Close_Grip_Bench_Press: '클로즈 그립 벤치프레스',
    R_B_Easy_Bar_Curl: '이지바 컬',
    R_B_Easy_Bar_Preacher_Curl: '이지바 프리쳐 컬',
    R_B_Easy_Bar_Wrist_Curl: '이지바 리스트 컬',
    R_B_List_Roller: '리스트 롤러',
    R_B_Reverse_Barbell_Curl: '리버스 바벨 컬',
    R_B_Reverse_Barbell_Wrist_Curl: '리버스 바벨 리스트 컬',
    R_B_Skull_Crusher: '스컬 크러셔',
    R_D_Dembel_Preacher_Curl: '뎀벨 프리쳐 컬',
    R_D_Dumbbell_Curl: '덤벨 컬',
    R_D_Dumbbell_Hammer_Curl: '덤벨 해머 컬',
    R_D_Dumbbell_Kickback: '덤벨 킥백',
    R_D_Dumbbell_Tricep_Extension: '덤벨 트리이셉 익스텐션',
    R_D_Dumbbell_Wrist_Curl: '덤벨 리스트 컬',
    R_D_Incline_Dumbbell_Curl: '인클라인 덤벨 컬',
    R_D_Reverse_Dumbbell_Wrist_Curl: '리버스 덤벨 리스트 컬',
    R_D_Seated_Dumbbell_Tricep_Extension: '시티드 덤벨 트라이셉 익스텐션',
    R_M_Arm_Curl_Machine: '암 컬 머신',
    R_M_Cable_Curl: '케이블 컬',
    R_M_Cable_Hammer_Curl: '케이블 해머컬',
    R_M_Cable_Lying_Tricep_Extension: '케이블 라잉 트라이셉 익스텐션',
    R_M_Cable_Overhead_Tricep_Extension: '케이블 오버헤드 트라이셉 익스텐션',
    R_M_Cable_Push_Down: '케이블 푸시 다운',
    R_M_Cable_Tricep_Extension: '케이블 트라이셉 익스텐션',
    R_M_Preacher_Curl_Machine: '프리쳐 컬 머신',
    R_M_Tricep_Extension_Machine: '트라이셉 익스텐션 머신',
    R_B_Bench_Dips: '벤치 딥스',
    B_B_Barbell_Pullover: '바벨 풀오버',
    B_B_Barbell_Row: '바벨 로우',
    B_B_Good_Morning_Exercise: '굿모닝 엑서사이즈',
    B_B_Incline_Barbell_Row: '인클라인 바벨 로우',
    B_B_Lying_Barbell_Row: '라잉 바벨 로우',
    B_B_Pendlay_Row: '펜들레이 로우',
    B_B_Undergrip_Barbell_Row: '언더그립 바벨 로우',
    B_D_Dumbbell_Row: '덤벨 로우',
    B_D_Incline_Dumbbell_Row: '인클라인 덤벨 로우',
    B_D_One_Arm_Dumbbell_Row: '원암 덤벨 로우',
    B_D_Weighted_Chin_Up: '중량 친업',
    B_D_Weighted_Pull_Ups: '중량 풀업',
    B_M_Assist_Pull_Up_Machine: '어시스트 풀업 머신',
    B_M_Behind_The_Neck_Pulldown: '비하인드 넥 풀다운',
    B_M_Cable_Arm_Pulldown: '케이블 암 풀다운',
    B_M_Floor_Seated_Cable_Row: '플로어 시티드 케이블 로우',
    B_M_Heavy_Hyperextension: '중량 하이퍼 익스텐션',
    B_M_High_Low_Machine: '하이 로우 머신',
    B_M_Inverted_Row: '인버티드 로우',
    B_M_Lat_Pulldown: '랫풀다운',
    B_M_Lateral_Wide_Pulldown: '레터럴 와이드 풀다운',
    B_M_Mcgrip_Lat_Pulldown: '맥그립 랫풀다운',
    B_M_One_Arm_Cable_Pull_Down: '원암 케이블 풀다운',
    B_M_One_Arm_High_Low_Machine: '원암 하이 로우 머신',
    B_M_One_Arm_Lateral_Wide_Pulldown: '원암 레터럴 와이드 풀다운',
    B_M_One_Arm_Seated_Cable_Row: '원암 시티드 케이블 로우',
    B_M_One_Arm_Row_Machine: '원암 로우 머신',
    B_M_Parallel_Grip_Lat_Pulldown: '패러럴그립 랫풀다운',
    B_M_Row_Machine: '로우 머신',
    B_M_Seated_Cable_Row: '시티드 케이블 로우',
    B_M_Seated_Row_Machine: '시티드 로우 머신',
    B_M_Smith_Machine_Row: '스미스머신 로우',
    B_M_T_Bar_Row_Machine: '티바 로우 머신',
    B_M_Undergrab_Lat_Pulldown: '언더그랩 랫풀다운',
    B_M_Undergrip_High_Low_Machine: '언더그립 하이 로우 머신',
    B_B_Back_Extension: '백 익스텐션',
    B_B_Chin_Up: '친업',
    B_B_Hyper_Extension: '하이퍼 익스텐션',
    B_B_Pull_Up: '풀업',
    A_B_Abs_Rollout: '복근 롤아웃',
    A_D_Dumbbell_Side_Bend: '덤벨 사이드 벤드',
    A_D_Heavy_Decline_Sit_Up: '중량 디클라인 싯업',
    A_D_Heavy_Updominal_Hip_Thrust: '중량 업도미널 힙 쓰러스트',
    A_D_Russian_Twist: '러시안 트위스트',
    A_D_Weighted_Decline_Crunch: '중량 디클라인 크런치',
    A_M_Abdominal_Crunch_Machine: '복근 크런치 머신',
    A_M_Cable_Side_Bend: '케이블 사이드 벤드',
    A_M_Cable_Twist: '케이블 트위스트',
    A_M_Hanging_Knee_Raise: '행잉 니 레이즈',
    A_M_Hanging_Leg_Raise: '행잉 레그 레이즈',
    A_M_Tods_To_Bar: '토즈투 바',
    A_B_45_Degree_Side_Bend: '45도 사이드 벤드',
    A_B_Abs_Air_Bike: '복근 에어 바이크',
    A_B_Crunch: '크런치',
    A_B_Decline_Crunch: '디클라인 크런치',
    A_B_Decline_Reverse_Crunch: '디클라인 리버스 크런치',
    A_B_Decline_Sit_Up: '디클라인 싯업',
    A_B_Heel_Touch: '힐 터치',
    A_B_Hollow_Position: '할로우 포지션',
    A_B_Hollow_Rock: '할로우 락',
    A_B_Leg_Raise: '레그 레이즈',
    A_B_Pilates_Jackknife: '필라테스 잭나이프',
    A_B_Plank: '플랭크',
    A_B_Reverse_Crunch: '리버스 크런치',
    A_B_Side_Crunches: '사이드 크런치',
    A_B_Side_Plank: '사이드 플랭크',
    A_B_Sit_Up: '싯업',
    A_B_Updominal_Hip_Thrust: '업도미널 힙 쓰러스트',
    A_B_V_Up: '브이 업',
  };

  // 독일어 (German)
  static const Map<String, dynamic> DE = {
    selectedLanguage: 'Deutsch',
    title: 'Lokalisierung',
    body: 'Willkommen bei dieser lokalisierten Flutter-App',
    add: 'Hinzufügen',
  };

  // 일본어 (Japanese)
  static const Map<String, dynamic> JA = {
    selectedLanguage: '日本語',
    title: 'ローカリゼーション',
    body: 'このローカライズされたFlutterアプリへようこそ',
    add: '追加',
  };

  // 스페인어 (Spanish)
  static const Map<String, dynamic> ES = {
    selectedLanguage: 'Español',
    title: 'Localización',
    body: 'Bienvenido a esta aplicación Flutter localizada',
    add: 'Agregar',
  };

  // 중국어 (Simplified Chinese)
  static const Map<String, dynamic> ZH = {
    locale: 'zh',
    workoutdiary: 'Workout Diary',
    LOGO: '标识',
    logo: '标识',
    setting: '环境',
    usersetting: '你',
    language: '语言',
    selectedLanguage: '中国人',
    units: '单位',
    more: '更多的',
    dataInitialization: '数据初始化',
    dataInitializationBody: '删除存储在设备上的所有记录。',
    deleteButtonText: '是的，删除',
    dataInitializationToastmessage: '数据已初始化。',
    dataInitializationNotToastmessage: '没有数据可以初始化。',
    termsOfUse: '使用条款',
    toDevelopers: '给开发人员',
    feedback: '反馈',
    version: '版本',
    feedbackEmailBody: '如果您有任何疑问，请与我们联系。',
    back_button_text: '后退',
    sendEmailButtonText: '发电子邮件',
    Inquiry: '询问',
    InquiryEmailBody: '---- <<查询>> ---- \n😀请详细写入情况。它将帮助我们了解内容\ n \ n \ n \ n \ n \ n \ n \ n \ n \ n \ n---- <<设备详细信息>> -------',
    screenRatio: '屏幕比例',
    title: '本土化',
    body: '欢迎来到这个本地化的颤音应用程序',
    seeAds: '参见广告',
    add: '添加',
    toDo: '去做',
    workOut: '锻炼',
    reps: '代表',
    sets: '套',
    close: '关闭',
    legs: '腿',
    shoulders: '肩膀',
    chest: '胸部',
    arms: '武器',
    back: '后退',
    abs: '腹肌',
    babel: '别贝',
    dumbbell: '哑铃',
    machine: '机器',
    bodyweight: '体重',
    toastmessage_imgsaveing: '保存！！ ⏳',
    toastmessage_imgsavesuccess: '保存成功😘',
    toastmessage_registernumberexceeded: '最大超过15！太神奇了',
    toastmessage_internetconnect: '❗检查您的互联网连接❗',
    viewtitle_calendar: '锻炼日历',
    slogan: '习惯使我',
    L_B_Barbell_Glute_Bridge: '杠铃臀大桥',
    L_B_Sumo_Deadlift: '相扑硬拉',
    L_B_Barbell_Back_Squat: '杠铃后蹲',
    L_B_Barbell_Bulgarian_Split_Squat: '杠铃保加利亚分裂',
    L_B_Barbell_Front_Squat: '杠铃前蹲',
    L_B_Barbell_Hack_Squat: '杠铃hack蹲',
    L_B_Barbell_Lateral_Lunge: '杠铃横向弓步',
    L_B_Barbell_Lunge: '杠铃弓步',
    L_B_Conventional_Deadlift: '传统的硬拉',
    L_B_Deficit_Deadlift: '赤字硬拉',
    L_B_Romanian_Deadlift: '罗马尼亚硬拉',
    L_B_Barbell_Front_Rack_Lunge: '杠铃前架弓步',
    L_B_Barbell_Hip_Thrust: '杠铃臀部推力',
    L_B_Barbell_Jump_Squat: '杠铃跳蹲',
    L_B_Barbell_One_Leg_Deadlift: '杠铃一条腿硬拉',
    L_B_Barbell_Split_Squat: '杠铃分裂下蹲',
    L_B_Barbell_Standing_Calf_Raise: '杠铃站立小牛',
    L_B_Barbell_Sumo_Squat: '杠铃相扑下蹲',
    L_B_Trap_Bar_Deadlift: '陷阱吧台地图',
    L_B_Zercher_Squat: 'Zercher下蹲',
    L_D_Dumbbell_Lateral_Lunge: '哑铃侧弓',
    L_D_Dumbbell_Sumo_Deadlift: '哑铃相扑硬拉',
    L_D_Dumbbell_Bulgarian_Split_Squat: '哑铃保加利亚分裂蹲',
    L_D_Dumbbell_Goblet_Squat: '哑铃杯蹲',
    L_D_Dumbbell_Lunge: '哑铃弓步',
    L_D_Dumbbell_Squat: '哑铃下蹲',
    L_D_Dumbbell_Sumo_Squat: '哑铃sumo下蹲',
    L_D_Dumbbell_Romanian_Deadlift: '哑铃罗马尼亚硬拉',
    L_D_Dumbbell_Calf_Raise: '哑铃小牛饲养',
    L_D_Dumbbell_Leg_Curl: '哑铃腿卷发',
    L_D_Dumbbell_One_Leg_Deadlift: '哑铃一条腿硬拉',
    L_D_Dumbbell_Split_Squat: '哑铃分裂下蹲',
    L_D_Dumbbell_Stiff_Leg_Deadlift: '哑铃硬腿硬拉',
    L_D_Weight_Step_Up: '体重加强',
    L_M_Glute_Kickback_Machine: '臀部回扣机',
    L_M_Leg_Extension: '腿部扩展',
    L_M_Leg_Press: '腿部',
    L_M_Leg_Curl: '腿卷发',
    L_M_Cable_Donkey_Kick: '电缆驴踢',
    L_M_Cable_Hip_Abduction: '电缆髋关节绑架',
    L_M_Cable_Hip_Adduction: '电缆髋关节内收',
    L_M_Cable_Pull_Through: '电缆通过',
    L_M_Hack_Squat_Machine: '黑客蹲机',
    L_M_Hip_Abduction_Machine: '髋关节绑架机',
    L_M_Hip_Thrust_Machine: '臀部推力机',
    L_M_Horizontal_Leg_Press: '水平腿压',
    L_M_Horizontal_One_Leg_Press: '水平一条腿压',
    L_M_Inner_Cy_Machine: '内部CY机器',
    L_M_Monster_Glute_Machine: '怪物臀部机器',
    L_M_One_Leg_Curl: '一条腿卷发',
    L_M_One_Leg_Extension: '一条腿扩展',
    L_M_One_Leg_Press: '一条腿',
    L_M_Reverse_V_Squat: '反向V下蹲',
    L_M_Seated_Calf_Raises: '坐着小牛',
    L_M_Seated_Leg_Curl: '坐着的腿卷发',
    L_M_Seated_One_Leg_Curl: '坐着一条腿卷发',
    L_M_Smith_Machine_Deadlift: '史密斯机器硬拉',
    L_M_Smith_Machine_Split_Squat: '史密斯机器拆分',
    L_M_Smith_Machine_Squat: '史密斯机器下蹲',
    L_M_Standing_Calf_Raise: '站立小牛饲养',
    L_M_V_Squat: 'v蹲',
    L_B_Donkey_Kick: '驴踢',
    L_B_Lunge: '弓步',
    L_B_Glute_Bridge: '臀大桥',
    L_B_Nordic_Hamstring_Curl: '北欧腿筋卷发',
    L_B_Air_Squat: '空下蹲',
    L_B_Body_Calf_Raise: '身体小腿升高',
    L_B_Bodyweight_Lateral_Lunge: '体重侧弓',
    L_B_Bodyweight_One_Leg_Deadlift: '体重一条腿硬拉',
    L_B_Bodyweight_Overhead_Squat: '体重高架下蹲',
    L_B_Bodyweight_Split_Squat: '体重分裂下蹲',
    L_B_Hip_Thrust: '臀部推力',
    L_B_Jump_Squat: '跳下蹲',
    L_B_Lunge_Twist: '弓步扭曲',
    L_B_Lying_Hip_Abduction: '说谎的髋关节绑架',
    L_B_Pistol_Squat: '手枪下蹲',
    L_B_Side_Lying_Clam: '侧面蛤lam',
    L_B_Single_Leg_Glute_Bridge: '单腿臀肌',
    L_B_Step_Up: '加紧',
    L_B_Sumo_Air_Squat: 'Sumo空气下蹲',
    S_B_Barbell_Overhead_Press: '杠铃高架按下',
    S_B_Barbell_Front_Raise: '杠铃前升',
    S_B_Barbell_Shrug: '杠铃耸耸肩',
    S_B_Barbell_Upright_Row: '杠铃直立行',
    S_B_Easy_Bar_Front_Raise: '轻松的吧台前升',
    S_B_Easy_Bar_Upright_Row: '易于栏直立行',
    S_B_Plate_Shoulder_Press: '板肩部按',
    S_B_Push_Press: '按下',
    S_B_Seated_Barbell_Shoulder_Press: '坐着的杠铃肩部按',
    S_D_Arnold_Dumbbell_Press: 'Arnold Dumbbell出版社',
    S_D_Bentover_Dumbbell_Lateral_Raise: 'Bentover哑铃横向升起',
    S_D_Dumbbell_Front_Raise: '哑铃前升',
    S_D_Dumbbell_Lateral_Raise: '哑铃横向加升',
    S_D_Dumbbell_Shoulder_Press: '哑铃肩部按',
    S_D_Dumbbell_Shrug: '哑铃耸耸肩',
    S_D_Dumbbell_Upright_Row: '哑铃直立行',
    S_D_Dumbbell_Y_Raise: '哑铃y加了',
    S_D_Seated_Dumbbell_Rear_Lateral_Raise: '坐在哑铃后侧升起',
    S_D_Seated_Dumbbell_Shoulder_Press: '座位的哑铃肩部按',
    S_M_Behind_Neck_Press: '在脖子后面',
    S_M_Cable_External_Rotation: '电缆外旋转',
    S_M_Cable_Front_Raise: '电缆前升',
    S_M_Cable_Internal_Rotation: '电缆内部旋转',
    S_M_Cable_Lateral_Raise: '电缆横向升高',
    S_M_Cable_Reverse_Fly: '电缆逆飞',
    S_M_Cable_Shrug: '电缆耸耸肩',
    S_M_Faithfull: '忠实',
    S_M_Landmine_Press: '地雷出版社',
    S_M_Lateral_Raise_Machine: '横向升起机器',
    S_M_One_Arm_Cable_Lateral_Raise: '一根手臂电缆横向抬起',
    S_M_Rear_Deltoid_Fly_Machine: '后三角飞机飞机',
    S_M_Shoulder_Press_Machine: '肩部按机',
    S_M_Shrug_Machine: '耸耸肩的机器',
    S_M_Smith_Machine_Overhead_Press: '史密斯机器高架压力机',
    S_M_Smith_Machine_Shrug: '史密斯机器耸耸肩',
    S_M_Wonam_Landmine_Press: 'WONAM LONDMINE PRESS',
    S_B_Handstand: '手倒立',
    S_B_Handstand_Push_Up: '倒立向上',
    S_B_Shoulder_Tab: '肩膀标签',
    S_B_Y_Raise: 'y加了',
    C_B_Barbell_Floor_Press: '杠铃地板压力',
    C_B_Bench_Press: '卧推',
    C_B_Decline_Bench_Press: '下降卧推',
    C_B_Incline_Bench_Press: '倾斜卧推',
    C_B_Spoto_Bench_Press: 'Spoto卧推',
    C_D_Decline_Dumbbell_Bench_Press: '拒绝哑铃卧推',
    C_D_Decline_Dumbbell_Fly: '下降哑铃飞',
    C_D_Dumbbell_Bench_Press: '哑铃卧推',
    C_D_Dumbbell_Fly: '哑铃飞',
    C_D_Dumbbell_Pullover: '哑铃套头衫',
    C_D_Dumbbell_Squeeze_Press: '哑铃挤压按下',
    C_D_Incline_Dumbbell_Bench_Press: '倾斜哑铃卧推',
    C_D_Incline_Dumbbell_Flyes: '倾斜哑铃飞蝇',
    C_D_Incline_Dumbbell_Twist_Press: '倾斜哑铃扭曲',
    C_D_Weighted_Dips: '加权倾角',
    C_M_Assist_Dips_Machine: '辅助倾角机',
    C_M_Cable_Crossover: '电缆跨界',
    C_M_Chest_Press_Machine: '胸部按机',
    C_M_Decline_Chest_Press_Machine: '胸部压力降低',
    C_M_Hammer_Bench_Press: '锤子板出版社',
    C_M_Incline_Bench_Press_Machine: '倾斜卧推机',
    C_M_Incline_Cable_Fly: '倾斜电缆飞',
    C_M_Incline_Chest_Press_Machine: '倾斜的胸部压力机',
    C_M_Low_Pulley_Cable_Fly: '低滑轮电缆飞',
    C_M_Peck_Deck_Fly_Machine: '啄甲板飞机',
    C_M_Seated_Dips_Machine: '坐着的倾角机',
    C_M_Smith_Machine_Bench_Press: '史密斯机器卧推',
    C_M_Smith_Machine_Inline_Bench_Press: '史密斯机器内联卧推',
    C_M_Standing_Cable_Fly: '站立电缆飞',
    C_B_Archer_Push_Up: '弓箭手向上推',
    C_B_Clap_Push_Up: '鼓掌向上推',
    C_B_Close_Grip_Push_Up: '紧紧抓紧',
    C_B_Dips: '蘸酱',
    C_B_Hindu_Push_Up: '印度教向上推',
    C_B_Pike_Push_Up: '派克抬起',
    C_B_Push_Up: '俯卧撑',
    C_B_Weighted_Push_Ups: '加权俯卧撑',
    R_B_Barbell_Curl: '杠铃卷发',
    R_B_Barbell_Lying_Tricep_Extension: '杠铃说谎的三头肌扩展',
    R_B_Barbell_Preacher_Curl: '杠铃传教士卷发',
    R_B_Barbell_Wrist_Curl: '杠铃腕卷曲',
    R_B_Close_Grip_Bench_Press: '闭合卧推',
    R_B_Easy_Bar_Curl: '易于吧台卷发',
    R_B_Easy_Bar_Preacher_Curl: '轻松的酒吧传教士卷发',
    R_B_Easy_Bar_Wrist_Curl: '易于吧台手腕卷发',
    R_B_List_Roller: '列表辊',
    R_B_Reverse_Barbell_Curl: '反向杠铃卷发',
    R_B_Reverse_Barbell_Wrist_Curl: '反向杠铃手腕卷曲',
    R_B_Skull_Crusher: '头骨破碎机',
    R_D_Dembel_Preacher_Curl: 'Dembel传教士卷发',
    R_D_Dumbbell_Curl: '哑铃卷发',
    R_D_Dumbbell_Hammer_Curl: '哑铃锤卷',
    R_D_Dumbbell_Kickback: '哑铃回扣',
    R_D_Dumbbell_Tricep_Extension: '哑铃三头肌扩展',
    R_D_Dumbbell_Wrist_Curl: '哑铃腕卷曲',
    R_D_Incline_Dumbbell_Curl: '倾斜哑铃卷发',
    R_D_Reverse_Dumbbell_Wrist_Curl: '反向哑铃手腕卷曲',
    R_D_Seated_Dumbbell_Tricep_Extension: '座位的哑铃三头肌扩展',
    R_M_Arm_Curl_Machine: '手臂卷发机',
    R_M_Cable_Curl: '电缆卷发',
    R_M_Cable_Hammer_Curl: '电缆锤卷曲',
    R_M_Cable_Lying_Tricep_Extension: '电缆撒谎的三头肌扩展',
    R_M_Cable_Overhead_Tricep_Extension: '电缆顶部三头肌扩展',
    R_M_Cable_Push_Down: '电缆向下推',
    R_M_Cable_Tricep_Extension: '电缆三头肌扩展',
    R_M_Preacher_Curl_Machine: '传教士卷发机',
    R_M_Tricep_Extension_Machine: 'Tricep扩展机',
    R_B_Bench_Dips: '替补席',
    B_B_Barbell_Pullover: '杠铃套头衫',
    B_B_Barbell_Row: '杠铃行',
    B_B_Good_Morning_Exercise: '早上好运动',
    B_B_Incline_Barbell_Row: '倾斜杠铃行',
    B_B_Lying_Barbell_Row: '说谎的杠铃行',
    B_B_Pendlay_Row: 'pendlay行',
    B_B_Undergrip_Barbell_Row: '卧底杠铃行',
    B_D_Dumbbell_Row: '哑铃行',
    B_D_Incline_Dumbbell_Row: '倾斜哑铃行',
    B_D_One_Arm_Dumbbell_Row: '一只手臂哑铃行',
    B_D_Weighted_Chin_Up: '加权下巴向上',
    B_D_Weighted_Pull_Ups: '加权引体向上',
    B_M_Assist_Pull_Up_Machine: '辅助pull_up机器',
    B_M_Behind_The_Neck_Pulldown: '脖子下拉的后面',
    B_M_Cable_Arm_Pulldown: '电缆臂下拉',
    B_M_Floor_Seated_Cable_Row: '地板座椅行',
    B_M_Heavy_Hyperextension: '沉重的过度伸展',
    B_M_High_Low_Machine: '高低机器',
    B_M_Inverted_Row: '倒排',
    B_M_Lat_Pulldown: '拉特拉尔',
    B_M_Lateral_Wide_Pulldown: '外侧宽松的下拉',
    B_M_Mcgrip_Lat_Pulldown: 'McGrip lat下拉',
    B_M_One_Arm_Cable_Pull_Down: '一臂电缆向下拉',
    B_M_One_Arm_High_Low_Machine: '一臂高低机器',
    B_M_One_Arm_Lateral_Wide_Pulldown: '一只手臂的侧面下拉',
    B_M_One_Arm_Seated_Cable_Row: '一根座位的电缆行',
    B_M_One_Arm_Row_Machine: '一臂行车机',
    B_M_Parallel_Grip_Lat_Pulldown: '平行抓地力lat下拉',
    B_M_Row_Machine: '行机器',
    B_M_Seated_Cable_Row: '坐着的电缆行',
    B_M_Seated_Row_Machine: '座位的行机',
    B_M_Smith_Machine_Row: '史密斯机器行',
    B_M_T_Bar_Row_Machine: 't栏划船机',
    B_M_Undergrab_Lat_Pulldown: 'riusterrab lat下拉',
    B_M_Undergrip_High_Low_Machine: '高低的底漆',
    B_B_Back_Extension: '向后扩展',
    B_B_Chin_Up: '振奋起来',
    B_B_Hyper_Extension: '超扩展',
    B_B_Pull_Up: '拉起',
    A_B_Abs_Rollout: 'ABS推出',
    A_D_Dumbbell_Side_Bend: '哑铃侧弯曲',
    A_D_Heavy_Decline_Sit_Up: '大幅下降',
    A_D_Heavy_Updominal_Hip_Thrust: '重型上髋关节推力',
    A_D_Russian_Twist: '俄罗斯扭曲',
    A_D_Weighted_Decline_Crunch: '加权下降紧缩',
    A_M_Abdominal_Crunch_Machine: '腹部紧缩机',
    A_M_Cable_Side_Bend: '电缆侧弯曲',
    A_M_Cable_Twist: '电缆扭曲',
    A_M_Hanging_Knee_Raise: '悬挂膝盖',
    A_M_Hanging_Leg_Raise: '悬挂的腿抬起',
    A_M_Tods_To_Bar: 'to to bar',
    A_B_45_Degree_Side_Bend: '45度侧弯',
    A_B_Abs_Air_Bike: 'ABS空气自行车',
    A_B_Crunch: '紧缩',
    A_B_Decline_Crunch: '拒绝紧缩',
    A_B_Decline_Reverse_Crunch: '下降反向紧缩',
    A_B_Decline_Sit_Up: '下降静止',
    A_B_Heel_Touch: '脚跟触',
    A_B_Hollow_Position: '空心位置',
    A_B_Hollow_Rock: '空心岩石',
    A_B_Leg_Raise: '腿抬高',
    A_B_Pilates_Jackknife: '普拉提折刀',
    A_B_Plank: '板',
    A_B_Reverse_Crunch: '反向紧缩',
    A_B_Side_Crunches: '侧面仰卧起来',
    A_B_Side_Plank: '侧板',
    A_B_Sit_Up: '坐起来',
    A_B_Updominal_Hip_Thrust: 'Updominal Hip推力',
    A_B_V_Up: 'v向上',
  };

  // 포르투갈어 (Portuguese)
  static const Map<String, dynamic> PT = {
    selectedLanguage: 'Português',
    title: 'Localização',
    body: 'Bem-vindo a este aplicativo Flutter localizado',
    add: 'Adicionar',
  };

  // 아랍어 (Arabic)
  static const Map<String, dynamic> AR = {
    selectedLanguage: 'عربي',
    title: 'التوطين',
    body: 'مرحبًا بك في تطبيق Flutter المحلي',
    add: 'إضافة',
  };

  // 힌디어 (Hindi)
  static const Map<String, dynamic> HI = {
    selectedLanguage: 'हिंदी',
    title: 'स्थानीयकरण',
    body: 'इस स्थानीयकृत Flutter ऐप में आपका स्वागत है',
    add: 'जोड़ें',
  };
}
