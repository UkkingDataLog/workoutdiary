import 'package:hive/hive.dart';
import 'package:workoutdiary/hivedata/xlog.dart';

const String xlogBox = 'xlogBox';
const String ximgBox = 'ximgBox';
const String usersettingBox = 'usersettingBox';

class HiveHelper {
  static final HiveHelper _singleton = HiveHelper._internal();
  factory HiveHelper() {
    return _singleton;
  }

  HiveHelper._internal();

  Box<Xlog>? xlogsBox;
  Box<Ximg>? ximgsBox;
  Box<UserSetting>? usersettingsBox;

  Future openBox() async {
    xlogsBox = await Hive.openBox(xlogBox);
    ximgsBox = await Hive.openBox(ximgBox);
    usersettingsBox = await Hive.openBox(usersettingBox);
  }

  //Xlog
  Future createXlog(Xlog newXlog) async {
    return xlogsBox!.add(newXlog);
  }

  Future<List<Xlog>> readXlog() async {
    return xlogsBox!.values.toList();
  }

  Future updateXlog(int index, Xlog updateXlog) async {
    await xlogsBox?.putAt(index, updateXlog);
  }

  Future deleteXlog(int index) async {
    xlogsBox!.deleteAt(index);
  }

  //Ximg
  Future createXimg(Ximg newXimg) async {
    return ximgsBox!.add(newXimg);
  }

  Future<List<Ximg>> readXimg() async {
    return ximgsBox!.values.toList();
  }

  Future updateXimg(int index, Ximg updateXimg) async {
    await ximgsBox?.putAt(index, updateXimg);
  }

  Future deleteXimg(int index) async {
    ximgsBox!.deleteAt(index);
  }

  // UserSetting
  Future createUserSetting(UserSetting newUserSetting) async {
    return usersettingsBox!.add(newUserSetting);
  }

  Future<List<UserSetting>> readUserSettingg() async {
    return usersettingsBox!.values.toList();
  }

  Future updateUserSetting(int index, UserSetting updateUserSetting) async {
    await usersettingsBox?.putAt(index, updateUserSetting);
  }

  Future deleteUserSetting(int index) async {
    usersettingsBox!.deleteAt(index);
  }
}
