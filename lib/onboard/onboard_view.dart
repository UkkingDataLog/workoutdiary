import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:workoutdiary/common_widget/round_button.dart';
import 'package:workoutdiary/exercise_log/xlog_create_view.dart';
import 'package:workoutdiary/localization/locales.dart';
import 'package:workoutdiary/onboard/onboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  int selectedchoise = 0;
  late PageController _pageController;

  late String _currentLocale;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    if (_currentLocale == 'en') {
      selectedchoise = 0;
    } else if (_currentLocale == 'ko') {
      selectedchoise = 1;
    } else if (_currentLocale == 'zh') {
      selectedchoise = 2;
    } else if (_currentLocale == 'ja') {
      selectedchoise = 3;
    } else if (_currentLocale == 'de') {
      selectedchoise = 4;
    } else if (_currentLocale == 'es') {
      selectedchoise = 5;
    } else if (_currentLocale == 'pt') {
      selectedchoise = 6;
    } else if (_currentLocale == 'ar') {
      selectedchoise = 7;
    } else if (_currentLocale == 'hi') {
      selectedchoise = 8;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    List<OnboardModel> screens = <OnboardModel>[
      OnboardModel(
        img: 'assets/img/LanguageTranslator.png',
        text: LocaleData.chooselanguage.getString(context),
        desc: "Sebuah metode belajar yang terbuktiampuh dalam meningkatkan produktifitas belajar, Learning by Doing",
        bg: Theme.of(context).colorScheme.background,
        button: Theme.of(context).colorScheme.primary,
      ),
      // OnboardModel(
      //   img: 'assets/img/on_2.png',
      //   text: "Dapatkan Kemudahan Akses Kapanpun dan Dimanapun",
      //   desc: "Tidak peduli dimanapun kamu, semua kursus yang telah kamu ikuti bias kamu akses sepenuhnya",
      //   bg:  Theme.of(context).colorScheme.background,
      //   button: Theme.of(context).colorScheme.primary,
      // ),
      // OnboardModel(
      //   img: 'assets/img/on_3.png',
      //   text: "Gunakan Fitur Kolaborasi Untuk Pengalaman Lebih",
      //   desc: "Tersedia fitur Kolaborasi dengan tujuan untuk mengasah skill lebih dalam karena bias belajar bersama",
      //   bg:  Theme.of(context).colorScheme.background,
      //   button: Theme.of(context).colorScheme.primary,
      // ),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        actions: [
          (currentIndex == 0)
              ? Container()
              : TextButton(
                  onPressed: () {
                    _storeOnboardInfo();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const XlogCreateView()));
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: PageView.builder(
          itemCount: screens.length,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 512 / 4,
                  width: 512 / 4,
                  child: Image.asset(
                    screens[index].img,
                  ),
                ),
                Text(
                  screens[index].text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                (currentIndex != 0)
                    ? Container()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 0 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'en';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 0;
                                      });
                                    },
                                    title: "🇺🇸\nEnglish",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 1 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'ko';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 1;
                                      });
                                    },
                                    title: "🇰🇷\n한국어",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 2 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'zh';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 2;
                                      });
                                    },
                                    title: "🇨🇳\n中国",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 3 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'ja';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 3;
                                      });
                                    },
                                    title: "🇯🇵\n日本語",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 4 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'de';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 4;
                                      });
                                    },
                                    title: "🇩🇪\nDeutsch",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 5 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'es';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 5;
                                      });
                                    },
                                    title: "🇪🇸\nEspañol",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 6 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'pt';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 6;
                                      });
                                    },
                                    title: "🇵🇹\nPortuguês",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 7 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'ar';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 7;
                                      });
                                    },
                                    title: "🇸🇦\nعربي",
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.sizeOf(context).width / 3.5,
                                  child: RoundButton(
                                    type: selectedchoise == 8 ? RoundButtonType.selected : RoundButtonType.textGradient,
                                    onPressed: () {
                                      String value = 'hi';
                                      _setLocale(value);
                                      setState(() {
                                        selectedchoise = 8;
                                      });
                                    },
                                    title: "🇮🇳\nहिंदी",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                (currentIndex == 0)
                    ? Container()
                    : Text(
                        screens[index].desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
              ],
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: 100,
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
                child: ListView.builder(
                  itemCount: screens.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        width: currentIndex == index ? 25 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )
                    ]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (currentIndex == 0)
                        ? Container()
                        : InkWell(
                            onTap: () async {
                              print(currentIndex);

                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, borderRadius: BorderRadius.circular(15.0)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  LocaleData.prev.getString(context),
                                  style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onBackground),
                                ),
                              ]),
                            ),
                          ),
                    InkWell(
                      onTap: () async {
                        print(currentIndex);
                        if (currentIndex == screens.length - 1) {
                          await _storeOnboardInfo();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => XlogCreateView()));
                        }

                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            (currentIndex != screens.length - 1) ? LocaleData.next.getString(context) : LocaleData.done.getString(context),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Icon(
                            Icons.arrow_forward_sharp,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late FlutterLocalization _flutterLocalization;
  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      _flutterLocalization.translate(('en'));
    } else if (value == 'ko') {
      _flutterLocalization.translate(('ko'));
    } else if (value == 'zh') {
      _flutterLocalization.translate(('zh'));
    } else if (value == 'ja') {
      _flutterLocalization.translate(('ja'));
    } else if (value == 'de') {
      _flutterLocalization.translate(('de'));
    } else if (value == 'es') {
      _flutterLocalization.translate(('es'));
    } else if (value == 'pt') {
      _flutterLocalization.translate(('pt'));
    } else if (value == 'ar') {
      _flutterLocalization.translate(('ar'));
    } else if (value == 'hi') {
      _flutterLocalization.translate(('hi'));
    } else {
      return;
    }
  }
}
