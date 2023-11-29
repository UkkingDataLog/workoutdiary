import 'package:workoutdiary/hivedata/xlog.dart';

double UnitConversion(String lxweightUnit, String selectedweightUnit) {
  double weightUnitConversion = 1;

  switch (selectedweightUnit) {
    case 'lb':
      switch (lxweightUnit) {
        case 'lb':
          // weightUnitConversion = 1; //변화없음
          break;
        case 'kg':
          weightUnitConversion = 2.20; //2.20462
          break;
      }
      break;
    //
    case 'kg':
      switch (lxweightUnit) {
        case 'lb':
          weightUnitConversion = 0.45; //0.453592
          break;
        case 'kg':
          weightUnitConversion = 1; //변화없음
          break;
      }
  }
  return weightUnitConversion;
}
