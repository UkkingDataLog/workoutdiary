// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:workoutdiary/common/colo_extension.dart';

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     Future.delayed(Duration(seconds: 2), (() {
//       Navigator.of(context).pushReplacementNamed('/');
//     }));
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: TColor.secondaryG,
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 120,
//               backgroundColor: TColor.white,
//               child: Image.asset('assets/img/iconremovebg.png'),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Workout Diaey',
//               style: TextStyle(
//                   fontSize: 28,
//                   color: TColor.white,
//                   fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
