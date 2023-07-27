import 'dart:convert';
import 'package:cardmap/provider/selected_card.dart';
import 'package:cardmap/screen/more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  List items = [];
  List findItems = []; // 찾고자 하는 범위 내에 있는 모든 주소 리스트
  List shop = []; //가맹점 하나를 저장하는 변수
  late Map<String, dynamic> location;
  late List<String> address; // fetchAddress 실행했을 때 리턴 받는 변수, 주소를 출력한다.
  late List<Map<String, String>> findCoords;

  final marker = NMarker(
      id: 'test',
      position: const NLatLng(36.01979137115008, 129.34156894683838));

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

  Future<List<String>> fetchAddress(String lat, String lon) async {
    var responseRoadAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=roadaddr'),
        headers: headerss);

    var responseAddress = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=addr'),
        headers: headerss);

    String jsonRoadAddressData = responseRoadAddress.body;
    String jsonAddressData = responseAddress.body;

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

    print(jsonRoadAddressData);
    print("roadAddr = $roadAddress");
    print("addr = $address");

    return roadAddress;
  }

  Map<String, dynamic> findShop(List<String> roadAddress) {
    shop = items
        .where((element) =>
            element['road_addr'].toString().contains(roadAddress[1]))
        .toList();
    print(roadAddress[1]);
    print(shop);

    shop = shop
        .where((element) => element['road_addr']
            .toString()
            .contains('${roadAddress[2]} ${roadAddress[3]}'))
        .toList();
    print(roadAddress[2]);
    print(shop);

    // shop = shop
    //     .where((element) =>
    //         element['road_addr'].toString().contains(roadAddress[3]))
    //     .toList();
    // print(roadAddress[3]);
    // print(shop);

    return (shop[0]);
  }

  Future<List<String>> cameraLocation() async {
    late List<String> cameraAddress;
    NCameraPosition cameraPosition = await mapController.getCameraPosition();
    final lat = cameraPosition.target.latitude.toString();
    final lon = cameraPosition.target.longitude.toString();
    final zoom = cameraPosition.zoom;

    cameraAddress = await fetchAddress(lat, lon);

    print("camera = $cameraAddress");
    return cameraAddress;
  }

  Future<void> readJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/json/seoul.json');
    final data = await json.decode(response);
    setState(() {
      items = data["items"];
      print("..number = ${items.length}");
    });
    print('readJsonFile');
  }

  void fetchShopList() async {
    // 원하는 문자열을 포함하는 목록들을 list로 저장하는 함수
    List<String> findlist = await cameraLocation();
    findItems = items
        .where(
            (element) => element['road_addr'].toString().contains(findlist[2]))
        .toList();
  }

  Future<void> convertToCoords() async {
    /*------------------------- geocode 활용하기 ------------------------- */
    // 해당되는 주소를 저장한 리스트를 가지고
    // 하나씩 geocode를 통해 좌표를 받아온다.
    // 좌표를 가지고 변환하여 그 자리에 마커를 표시한다.

    // 어떻게 geocode 를 사용할것인가?
    // String endPoint =
    //     "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode";
    for (int i = 0; i < findItems.length; i++) {
      print("$i =${findItems[i]}");
      String lon;
      String lat;
      String jsonCoords;
      String query = findItems[i]['road_addr'];
      http.Response responseGeocode;
      responseGeocode = await http.get(
          Uri.parse(
              'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
          headers: headerss);

      jsonCoords = responseGeocode.body;
      print("Im json $jsonCoords");
      if (jsonDecode(jsonCoords)["meta"]["totalCount"] == 0) {
        print("메롱~ ");
      } else {
        lon = jsonDecode(jsonCoords)["addresses"][0]['x'];
        lat = jsonDecode(jsonCoords)["addresses"][0]['y'];
        print("convert lon = $lon");
        print("convert lon = $lat");
        findCoords.add({"lon": lon, "lat": lat});
        print("힝힝 $findCoords");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setCards(context);

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
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  onMapReady: (controller) async {
                    await readJsonFile(); //가맹점 정보 읽어오기
                    mapController = controller;
                    controller.addOverlay(marker);
                    print("네이버 맵 로딩됨!");
                  },
                  onSymbolTapped: (symbolInfo) async {
                    address = await fetchAddress(
                        symbolInfo.position.latitude.toString(),
                        symbolInfo.position.longitude.toString());
                    print(address);
                    location = findShop(address);
                    print(location);
                    if (!mounted) return;
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '${location['name']}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${location['road_addr']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (location['phone'] != null)
                                  Text(
                                    '전화번호 : ${location['phone']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        });
                  },
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
                        // Get.to(const SearchScreen(),
                        //     transition: Transition.noTransition);
                        /*------------------------------------------------------------------------------------------*/
                        await readJsonFile(); // 디버깅 목적으로 사용하였습니다.
                        fetchShopList();
                        print("${findItems[0]}");
                        print("${findItems.length}");
                        await convertToCoords();
                        //print("난 대단하다.${findCoords[0]}");
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

  void setCards(BuildContext context) {
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
}
