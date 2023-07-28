import 'package:cardmap/firebase_options.dart';
import 'package:cardmap/provider/selected_card.dart';
import 'package:cardmap/screen/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  LocationPermission permission =
      await Geolocator.requestPermission(); //위치정보 허가
  await NaverMapSdk.instance.initialize(
      clientId: '73oah8omwy',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) =>
            SelectedCard(theFinalSelectedCard: List.empty(growable: true)))
  ], child: const MyApp()));
  //parkseyoung babo
  //ahnseoyoung 1004
  //yoonyohan cheunjae
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(home: AuthPage());
  }
}
