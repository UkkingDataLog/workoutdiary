import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoutdiary/common/colo_extension.dart';

void showToastMessage(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: TColor.black,
      textColor: TColor.white,
    );
