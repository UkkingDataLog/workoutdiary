import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/common/coustom_web_view.dart';
import 'package:workoutdiary/localization/locales.dart';

class TermOfUseView extends StatefulWidget {
  const TermOfUseView({super.key});

  @override
  State<TermOfUseView> createState() => _TermOfUseViewState();
}

class _TermOfUseViewState extends State<TermOfUseView> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const CoustomWebView(url: 'https://docs.google.com/document/d/1dUQCACxFQeAyKhpu_sy-fJSYagaWaawlGPoDKF2sMs0/edit?usp=sharing'),
          Container(
            height: 58,
            width: media.width,
            color: TColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        LocaleData.termsOfUse.getString(context),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: TColor.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
