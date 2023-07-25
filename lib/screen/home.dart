import 'dart:convert';

import 'package:cardmap/provider/selected_card.dart';
import 'package:cardmap/screen/more.dart';
import 'package:cardmap/screen/search.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// class TestModel {
//   final String name;
//   final String road_addr;

//   TestModel(this.name, this.road_addr);

//   factory TestModel.fromJson(Map<String, dynamic> Json) {
//     return TestModel(name, road_addr);
//   }
// }
// 1. json - > List<Map<string,dy>> 하나의 객체만 가져오는건가? 전체를 다 가져올 순 없는 건가?
// 2. List<Map>> findList = jsonlist.where((element) 해당되는 (찾고자하는 문자열이 포함되는 ) 객체를 찾는 과정
// 3. findList 에서 주소를 가져온다. 한놈씩
// 4. geocoding 을 헤서 위경도를 얻는다.
// 5. 위경도에 마커를 띄운다.

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  late NCameraPosition initCameraPosition;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); //drawer
  bool isReady = false;
  List selectedCards = [];
  List selectedCardsIndex = [];
  bool clickedChecked = false;

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy", // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY":
        "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL" // 개인 시크릿 키
  };
  @override
  void initState() {
    // 현재 위치를 받아오기
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      position = value;
      setState(() {
        initCameraPosition = NCameraPosition(
            target: NLatLng(position.latitude, position.longitude), zoom: 15);
        isReady = true;
      });
    });
    super.initState();
  }

  late NaverMapController mapController;

  Future<List<String>> fetchAlbum(String lat, String lon) async {
    FirebaseDatabase realtime = FirebaseDatabase.instance;

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // String lat = "37.30868980127576";
    position.latitude.toString();
    // String lon = "126.83061361312866";

    position.longitude.toString();
    print(lat);
    print(lon);

    
    var responseRoadAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=roadaddr'),
        headers: headerss);
    //print(response.body);

    var responseAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=addr'),
        headers: headerss);

    // print(responseRoadAddress.body);
    // print(responseAddress.body);

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

    //String hi = "$myjsonSi $myjsonGu $myjsonRoadName $myjsonRoadNumber";

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

    //print(hi);
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

  Future<List<String>> cameraLocation() async {
    late List<String> adress, find;
    NCameraPosition cameraPosition = await mapController.getCameraPosition();
    final lat = cameraPosition.target.latitude.toString();
    final lon = cameraPosition.target.longitude.toString();
    final zoom = cameraPosition.zoom;

    adress = await fetchAlbum(lat, lon);

    print(adress);
    return adress;
  }

  List _items = [];
  List findItems = [];
  Future<void> readJson() async {
    //  json파일을 list 로 저장하는 함수.
    final String response =
        await rootBundle.loadString('assets/images/seoul.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
      print("..number = ${_items.length}");
      print("..첫번째꺼 마 나온나 = ${_items[180000]}");
      print("..이름 마 나온나 = ${_items[180000]['name']}");
    });
  }

  void findList() {
    // 원하는 문자열을 포함하는 목록들을 list로 저장하는 함수
    findItems = _items
        .where((element) => element['name'].toString().contains('파리바게뜨'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0;
        i < (context.watch<SelectedCard>().finalSelectedCard.length);
        i++) {
      clickedChecked = false;
      for (int j = 0; j < selectedCards.length; j++) {
        if (context.watch<SelectedCard>().finalSelectedCard[i] ==
            selectedCards[j]) {
          clickedChecked = true;
          break;
        }
      }
      if (clickedChecked == true) {
        selectedCardsIndex.add('1');
      } else {
        selectedCardsIndex.add('0');
      }
    }

    return Scaffold(
      key: _key, //drawer
      endDrawer: const MorePage(), //drawer
      body: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    // naver map 옵션을 세팅하는 위젯
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true, // 현 위치를 나타내는 버튼
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    // extent: const NLatLngBounds(
                    //   southWest: NLatLng(31.43, 122.37),
                    //   northEast: NLatLng(44.35, 132.0),
                    // ),
                  ),
                  onMapReady: (controller) {
                    mapController = controller;
                    print("네이버 맵 로딩됨!");
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
                        top: BorderSide(width: 1, color: Colors.black38),
                        bottom: BorderSide(width: 1, color: Colors.black38),
                        right: BorderSide(width: 1, color: Colors.black38),
                        left: BorderSide(width: 1, color: Colors.black38),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Get.to(const SearchScreen(),
                            transition: Transition.noTransition);
                        /*------------------------------------------------------------------------------------------*/
                        // await readJson(); // 디버깅 목적으로 사용하였습니다.
                        // findList();

                        // print("${findItems[0]}");
                        // print("${findItems[600]}");
                        // print("${findItems.length}");
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
                        top: BorderSide(width: 1, color: Colors.black38),
                        bottom: BorderSide(width: 1, color: Colors.black38),
                        right: BorderSide(width: 1, color: Colors.black38),
                        left: BorderSide(width: 1, color: Colors.black38),
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
                      if (selectedCardsIndex[i] == '0')
                        cardButton(
                            "${context.watch<SelectedCard>().finalSelectedCard[i]}")
                      else
                        cardButton10(
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
              top: BorderSide(width: 1, color: Colors.black38),
              bottom: BorderSide(width: 1, color: Colors.black38),
              right: BorderSide(width: 1, color: Colors.black38),
              left: BorderSide(width: 1, color: Colors.black38),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              cardName,
            ),
          ),
        ),
        onTap: () {
          selectedCardsIndex = [];
          selectedCards.add(cardName);
          setState(() {});
        },
      ),
    );
  }

  Padding cardButton10(String cardName) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.lightGreen,
            border: Border(
              top: BorderSide(width: 1, color: Colors.black12),
              bottom: BorderSide(width: 1, color: Colors.black12),
              right: BorderSide(width: 1, color: Colors.black12),
              left: BorderSide(width: 1, color: Colors.black12),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              cardName,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        onTap: () {
          selectedCardsIndex = [];
          selectedCards.remove(cardName);
          setState(() {});
        },
      ),
    );
  }

  // Container cardButton(String cardName) {
  //   return Container(
  //     padding: const EdgeInsets.only(right: 6),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       border: Border(
  //         top: BorderSide(width: 1, color: Colors.black38),
  //         bottom: BorderSide(width: 1, color: Colors.black38),
  //         right: BorderSide(width: 1, color: Colors.black38),
  //         left: BorderSide(width: 1, color: Colors.black38),
  //       ),
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(15),
  //       ),
  //     ),
  //     child: TextButton(
  //       onPressed: () {
  //         selectedCards.add(cardName);
  //         setState(() {});
  //       },
  //       child: Text(cardName),
  //       //style: const TextStyle(color: Colors.lightGreen),
  //     ),
  //   );
  // }
}
// class NaverService {
//   late NCameraPosition cameraPosition;
//   Future currentPosition() async {
//     cameraPosition = await getCameraPosition();
//   }
// }
