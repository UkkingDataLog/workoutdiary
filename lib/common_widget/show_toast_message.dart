import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workoutdiary/common/colo_extension.dart';

void showToastMessage(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: TColor.white,
    );
