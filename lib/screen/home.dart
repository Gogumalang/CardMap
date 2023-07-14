import 'dart:convert';

import 'package:cardmap/screen/more.dart';
import 'package:cardmap/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  late NCameraPosition cameraPosition;
  bool isReady = false;
  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy", // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY":
        "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL" // 개인 시크릿 키
  };

  Future<List<String>> fetchAlbum(String lat, String lon) async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // String lat = "37.30868980127576";
    // //position.latitude.toString();
    // String lon = "126.83061361312866";
    // //position.longitude.toString();
    print(lat);
    print(lon);

    var response = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=roadaddr'),
        headers: headerss);
    print(response.body);

    String jsonData = response.body;

    print(jsonData);
    var myjsonGu =
        jsonDecode(jsonData)["results"][0]['region']['area2']['name'];
    var myjsonSi =
        jsonDecode(jsonData)["results"][0]['region']['area1']['name'];

    List<String> gusi = [myjsonSi, myjsonGu];
    print(gusi);

    return gusi;
  }

  @override
  void initState() {
    // 현재 위치를 받아오기
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      position = value;
      setState(() {
        cameraPosition = NCameraPosition(
            target: NLatLng(position.latitude, position.longitude), zoom: 15);
        isReady = true;
      });
    });
    super.initState();
  }

  final controller = NaverMapController;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); //drawer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key, //drawer
      endDrawer: const MorePage(), //drawer
      body: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    // naver map 옵션을 세팅하는 위젯
                    initialCameraPosition: cameraPosition,
                    locationButtonEnable: true, // 현 위치를 나타내는 버튼
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    // extent: const NLatLngBounds(
                    //   southWest: NLatLng(31.43, 122.37),
                    //   northEast: NLatLng(44.35, 132.0),
                    // ),
                  ),
                  onMapReady: (controller) {
                    print("네이버 맵 로딩됨!");
                    // final infoWindow = NInfoWindow.onMap(
                    //     id: "test", position: target, text: "인포윈도우 텍스트");
                    // controller.addOverlay(infoWindow);
                  },
                  onSymbolTapped: (symbolInfo) => fetchAlbum(
                      symbolInfo.position.latitude.toString(),
                      symbolInfo.position.longitude.toString()),
                )
              : Container(),
          Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    // 검색창 버튼
                    width: 310,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.to(const SearchScreen(),
                            transition: Transition.noTransition);
                      },
                      child: const Text(
                        "search",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    // 더보기란
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      iconSize: 25,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        _key.currentState!.openEndDrawer(); //drawer open
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                //카드 스크롤
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 250,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 250,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 250,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// class NaverService {
//   late NCameraPosition cameraPosition;
//   Future currentPosition() async {
//     cameraPosition = await getCameraPosition();
//   }
// }
