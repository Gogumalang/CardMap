import 'dart:convert';

import 'package:cardmap/provider/selected_card.dart';
import 'package:cardmap/screen/more.dart';
import 'package:cardmap/screen/search.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TestModel {
  final String number;
  final String name;
  final String address;
  final String card;

  TestModel(this.number, this.name, this.address, this.card);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "card": card,
      "address": address,
      "number": number,
    };
  }
}

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
    FirebaseDatabase realtime = FirebaseDatabase.instance;

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // String lat = "37.30868980127576";
    // //position.latitude.toString();
    // String lon = "126.83061361312866";
    // //position.longitude.toString();

    print(lat);
    print(lon);

    var responseRoadAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=roadaddr'),
        headers: headerss);

    var responseAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=addr'),
        headers: headerss);

    print(responseRoadAddress.body);
    print(responseAddress.body);

    String jsonRoadAddressData = responseRoadAddress.body;
    String jsonAddressData = responseAddress.body;

    // print(jsonRoadAddressData);
    // print(jsonAddressData);

    var myjsonGu = jsonDecode(jsonRoadAddressData)["results"][0]['region']
        ['area2']['name'];
    var myjsonSi = jsonDecode(jsonRoadAddressData)["results"][0]['region']
        ['area1']['name'];
    var myjsonRoadName =
        jsonDecode(jsonRoadAddressData)["results"][0]['land']['name'];
    var myjsonRoadNumber =
        jsonDecode(jsonRoadAddressData)["results"][0]['land']['number1'];
    var myjsonDong =
        jsonDecode(jsonAddressData)["results"][0]['region']['area3']['name'];
    var myjsonEub =
        jsonDecode(jsonAddressData)["results"][0]['region']['area4']['name'];
    var myjsonDongNumber1 =
        jsonDecode(jsonAddressData)["results"][0]['land']['number1'];
    var myjsonDongNumber2 =
        jsonDecode(jsonAddressData)["results"][0]['land']['number2'];

    List<String> roadAddress = [
      myjsonSi,
      myjsonGu,
      myjsonRoadName,
      myjsonRoadNumber,
    ];
    List<String> address = [
      myjsonSi,
      myjsonGu,
      myjsonDong,
      myjsonEub,
      myjsonDongNumber1,
      myjsonDongNumber2,
    ];

    print(roadAddress);
    print(address);

    // await realtime.ref("서울사랑상품권").child("1").set(TestModel(
    //       "01023282938",
    //       "KFC",
    //       "address",
    //       "nuri",
    //     ).toJson());

    DataSnapshot snapshot = await realtime
        .ref("통영사랑상품권")
        //.orderByValue()
        .equalTo("경상남도 통영시 도천상가안길 18, 101동 112호 (도천동, 동원나폴리상가)")
        .get();
    if (snapshot.exists) {
      List<Object?> value = snapshot.value as List<Object?>;
      print(value);
    } else {
      print('No data available.');
    }
    // Map<dynamic, dynamic> value = snapshot.value as Map<dynamic, dynamic>;

    // final idek =
    //     realtime.ref('통영사랑상품권').orderByChild('road_addr').equalTo('경상남도 통영시');
    // print(idek);

    // final idek = realtime.ref('통영사랑상품권');
    // print(idek);

    return roadAddress;
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
                    width: 320,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.lightGreen),
                        bottom: BorderSide(width: 1, color: Colors.lightGreen),
                        right: BorderSide(width: 1, color: Colors.lightGreen),
                        left: BorderSide(width: 1, color: Colors.lightGreen),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Get.to(const SearchScreen(),
                            transition: Transition.noTransition);
                      },
                      child: const Text(
                        "search",
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    // 더보기란
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.lightGreen),
                        bottom: BorderSide(width: 1, color: Colors.lightGreen),
                        right: BorderSide(width: 1, color: Colors.lightGreen),
                        left: BorderSide(width: 1, color: Colors.lightGreen),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      iconSize: 25,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.lightGreen,
                      ),
                      onPressed: () {
                        _key.currentState!.openEndDrawer(); //drawer open
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              SingleChildScrollView(
                //카드 스크롤
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (int i = 0;
                        i <
                            (context
                                .watch<SelectedCard>()
                                .finalSelectedCard
                                .length);
                        i++)
                      cardButton(
                          "${context.watch<SelectedCard>().finalSelectedCard[i]}"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding cardButton(String cardName) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1, color: Colors.lightGreen),
              bottom: BorderSide(width: 1, color: Colors.lightGreen),
              right: BorderSide(width: 1, color: Colors.lightGreen),
              left: BorderSide(width: 1, color: Colors.lightGreen),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              cardName,
              //style: const TextStyle(color: Colors.lightGreen),
            ),
          ),
        ),
        onTap: () {},
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
