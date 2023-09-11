import 'dart:convert';
import 'dart:io';
import 'package:cardmap/model/market_model.dart';
import 'package:cardmap/screen/more.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cardmap/screen/mapsearch.dart';

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

  String selectedCard = '';
  List<List<Map<String, dynamic>>> items = List.filled(10, [], growable: true);
  List findItems = []; // 찾고자 하는 범위 내에 있는 모든 주소 리스트
  List shop = []; //가맹점 하나를 저장하는 변수

  late Map<String, dynamic> location;
  late List<String>
      address; // fetchAddress ?��?��?��?�� ?�� 리턴 받는 �??��, 주소�? 출력?��?��.
  // List<Map<String, dynamic>> findCoords = [];
  List<MarketModel> findCoords = [];
  late String typeOfAddress;
  late String? addressCheck;
  List<dynamic> theCardList = [];
  int clickedCardIndex = 0;

  Map cardNameDictionary = {
    '옥천 향수OK카드': 'okchun_love',
    '제주 사랑상품권': 'jeju_love',
    '제천 화폐(모아)': 'jechun_love',
    '칠곡 사랑카드': 'chilkok_love',
    '통영 사랑상품권': 'tongyoung_love',
    '평택 사랑카드': 'pyeongtack_love',
    '함평 사랑상품권': 'hampyeong_love',
    '강원 사랑상품권': 'gangwon_love',
    '동백전': 'dongback',
    '부산 아동급식카드': 'busan_adong',
    '계룡 사랑상품권': 'galong_love',
    '광주 아동급식카드': 'gwangju_adong',
    '무안 사랑상품권': 'muan_love',
    '남원 문화누리카드': 'namwon_munhwa',
    '산청 사랑상품권': 'sanchung_love',
    '서울 아동급식카드': 'seoul_adong',
    '서울 사랑상품권': 'seoul_love',
    '여수 사랑상품권': 'yeosu_love',
  };

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy", // 개인 ?��?��?��?��?�� ?��?��?��
    "X-NCP-APIGW-API-KEY":
        "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL" // 개인 ?��?���? ?��
  };
  @override
  void initState() {
    // ?��?�� ?��치�?? 받아?���?
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      position = value;
      setState(() {
        initCameraPosition = NCameraPosition(
            target: NLatLng(position.latitude, position.longitude), zoom: 15);
        isReady = true;
      });
    });
    //download();

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
    print(jsonRoadAddressData);
    print(jsonAddressData);

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

    addressCheck = items[0][clickedCardIndex]['road_addr'];
    if (addressCheck == null) {
      typeOfAddress = 'addr';
      return address;
    } else {
      typeOfAddress = 'road_addr';
      return roadAddress;
    }
  }

  // Map<String, dynamic> findShop(List<String> roadAddress) {
  //   // 원하는 주소의 가맹점을 가져온다.
  //   shop = items
  //       .where((element) =>
  //           element['road_addr'].toString().contains(roadAddress[1]))
  //       .toList();
  //   print(roadAddress[1]);
  //   print(shop);

  //   shop = shop
  //       .where((element) => element['road_addr']
  //           .toString()
  //           .contains('${roadAddress[2]} ${roadAddress[3]}'))
  //       .toList();
  //   print(roadAddress[2]);
  //   print(shop);

  //   return (shop[0]);
  // }dldldld

  Future<List<String>> cameraLocation() async {
    // 카메?�� ?��치�?? 주소�? �??��?��?��.
    late List<String> cameraAddress;
    NCameraPosition cameraPosition = await mapController.getCameraPosition();
    mapController.clearOverlays();
    final lat = cameraPosition.target.latitude.toString();
    final lon = cameraPosition.target.longitude.toString();
    final zoom = cameraPosition.zoom;

    cameraAddress = await fetchAddress(lat, lon);

    print("camera = $cameraAddress");
    return cameraAddress;
  }

  // Future<void> readJsonFile() async {
  //   await getCardList();
  //   for (var i = 0; i < theCardList.length; i++) {
  //     final String response = await rootBundle
  //         .loadString('assets/json/${cardNameDictionary[theCardList[i]]}.json');
  //     final data = await json.decode(response);
  //     setState(() {
  //       items[i] =
  //           data["items"]; //[{name,addr,...},{name,addr,...},{name,addr,...}]
  //       print("..number = ${items[i].length}");
  //     });
  //   }
  // }

  Future<void> fetchShopList() async {
    // 원하는 문자열을 포함하는 목록들을 list로 저장하는 함수
    print('fetch shop list start');
    List<String> findlist = await cameraLocation();
    findItems = items[clickedCardIndex]
        .where((element) =>
            element[typeOfAddress].toString().contains(findlist[2]))
        .toList();
    print(findItems);
    print("Fetch start!");
  }

  Future<void> convertToCoords() async {
    print("-------------convertToCoords------------------");
    findCoords = [];
    if (findItems.length > 10) {
      for (int i = 0; i < 10; i++) {
        MarketModel find = MarketModel();
        //print("$i =${findItems[i]}"); //RangeError
        String lon;
        String lat;
        String jsonCoords;
        String query = findItems[i]['road_addr']; //range error

        http.Response responseGeocode;
        responseGeocode = await http.get(
            Uri.parse(
                'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
            headers: headerss);

        jsonCoords = responseGeocode.body;
        print(jsonCoords);
        if (jsonDecode(jsonCoords)["meta"]["totalCount"] == 0) {
        } else {
          lon = jsonDecode(jsonCoords)["addresses"][0]['x'];
          lat = jsonDecode(jsonCoords)["addresses"][0]['y'];

          find = MarketModel(lat: lat, lon: lon);
          find.fromJson(findItems[i]);
          print(find.name);
          print(find.lon);
          print("convert lon = $lon");
          print("convert lat = $lat");

          findCoords.add(find);
          print("convertToCoods");
          print(find);
        }
      }
    } else {
      for (int i = 0; i < findItems.length; i++) {
        MarketModel find = MarketModel();
        //print("$i =${findItems[i]}"); //RangeError
        String lon;
        String lat;
        String jsonCoords;
        String query = findItems[i]['road_addr']; //range error

        http.Response responseGeocode;
        responseGeocode = await http.get(
            Uri.parse(
                'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
            headers: headerss);

        jsonCoords = responseGeocode.body;
        //print("Im json $jsonCoords");
        if (jsonDecode(jsonCoords)["meta"]["totalCount"] == 0) {
          //print("메롱~ ");
        } else {
          lon = jsonDecode(jsonCoords)["addresses"][0]['x'];
          lat = jsonDecode(jsonCoords)["addresses"][0]['y'];
          find = MarketModel(lat: lat, lon: lon);
          find.fromJson(findItems[i]);
          print(find.name);

          print(find.lon);
          print("convert lon = $lon");
          print("convert lat = $lat");
          findCoords.add(find);
          print("convertToCoods");
          print(find);
        }
      }
    }
  }

  Future<void> directGuide(int index) async {
    String message;
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String currentLat = currentPosition.latitude.toString();
    String currentLon = currentPosition.longitude.toString();

    http.Response Directionresponse = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-direction-15/v1/driving?start=$currentLon,$currentLat&goal=${findCoords[index].lon},${findCoords[index].lat}'),
        headers: headerss); // 길 찾는 기준은 driving 기준이라서 도보랑 다를 수 있다.

    message = Directionresponse.body;

    List<dynamic> polylines =
        jsonDecode(message)["route"]["traoptimal"][0]["path"];

    List<dynamic> coords = [];
    for (int i = 0; i < polylines.length; i++) {
      coords.add(polylines[i]);
    }

    Iterable<NLatLng> coordinates = [];

    coordinates = coords.map((coord) {
      double longitude = coord[0];
      double latitude = coord[1];
      return NLatLng(latitude, longitude);
    }).toList();

    var path = NPathOverlay(
      id: "hoho",
      coords: coordinates,
      color: Colors.blueAccent,
      width: 4.5,
      outlineColor: Colors.blueAccent,
    );
    await mapController.addOverlay(path);
  }

  NAddableOverlay makeOverlay({
    // marker ?��?�� ?��?��?��?��.
    required NLatLng position,
    required String id,
    required String name,
  }) {
    final overlayId = id;
    final point = position;
    String overlayName = name;
    return NMarker(
        id: overlayId,
        position: point,
        caption: NOverlayCaption(
          text: overlayName,
          color: Colors.lightGreen,
        ),
        isCaptionPerspectiveEnabled: true,
        icon:
            const NOverlayImage.fromAssetImage('assets/images/CardmapLogo.png'),
        size: const Size(50, 50),
        isHideCollidedMarkers: true,
        isHideCollidedSymbols: true,
        isHideCollidedCaptions: false);
    //return NMarker(id: overlayId, position: point);
  }

  void setMarker(int index) {
    //marker?�� ?��?��?�� �??��?���?, ?�� ?��면에 ?��?��?��.
    final NAddableOverlay<NOverlay<void>> overlay = makeOverlay(
      id: '$index',
      position: NLatLng(double.parse(findCoords[index].lat!),
          double.parse(findCoords[index].lon!)),
      name: findCoords[index].name.toString(),
    );

    overlay.setOnTapListener((overlay) async {
      infoWindow(index);
    });

    mapController.addOverlay(overlay);
  }

  // NAddableOverlay changeOverlay({
  //       // marker 클릭 시 marker의 UI 변경
  //   required NLatLng position,
  //   required String id,
  // }) {
  //   final overlayId = id;
  //   final point = position;
  //   return NMarker(
  //       id: overlayId,
  //       position: point,
  //       icon: const NOverlayImage.fromAssetImage('assets/images/hamzzi.jpeg'),
  //       size: const Size(200, 200),
  //       isHideCollidedMarkers: true,
  //       isHideCollidedSymbols: true);
  //   //return NMarker(id: overlayId, position: point);
  // }

  void printMarker() {
    //?��면에 ?��?��?�� 과정?�� findCoords 만큼 반복?��?��.
    print("printMarker start !");
    for (int i = 0; i < findCoords.length; i++) {
      setMarker(i);
    }
    //findCoords.clear();
    //print("과연 ..... $findCoords");
    print("PM fin.");
  }

  void infoWindow(int index) async {
    // marker 를 클릭했을 때, 상세 정보를 띄워준다.
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
                  height: 55,
                ),
                Text(
                  '${findCoords[index].name}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 6, 30, 20),
                  child: Text(
                    '${findCoords[index].road_addr}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (findCoords[index].phone != null)
                  Text(
                    '전화번호 : ${findCoords[index].phone}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                const SizedBox(
                  height: 90,
                ),
                InkWell(
                  child: Container(
                    width: 350,
                    height: 70,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightGreen,
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.drive_eta,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "길찾기",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    directGuide(index);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future getCardList() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email!)
        .get()
        .then((snapshot) {
      theCardList = snapshot.get('cardlist');
    });
    setState(() {});
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.absolute.path);
    return directory.absolute.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    print('path $path');
    return File('$path/json/$fileName');
  }

  Future<void> readFile(String fileName, int i) async {
    print('read file start');
    await getCardList();

    File file = await _localFile(fileName);

    final String response = await file.readAsString();

    print(response);
    final data = await json.decode(response);
    List<Map<String, dynamic>> map =
        (data["items"] as List).map((e) => e as Map<String, dynamic>).toList();
    setState(() {
      items[i] = map; //[{name,addr,...},{name,addr,...},{name,addr,...}]
      print("..number = ${items[i].length}");
    });
    print('read file end');
  }

  Future<int> deleteFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      await file.delete();

      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> isExist(String fileName) async {
    final file = await _localFile(fileName);
    return await file.exists();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getCardList();
    });

    return Scaffold(
      key: _key, //drawer
      endDrawer: const MorePage(), //drawer
      body: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    // naver map ?��?��?�� ?��?��?��?�� ?��?��
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true, // ?�� ?��치�?? ?��????��?�� 버튼
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  onMapReady: (controller) async {
                    // NaverMap.setLocation(locationSorce)
                    await getCardList();
                    for (int i = 0; i < theCardList.length; i++) {
                      await readFile(
                          '${cardNameDictionary[theCardList[i]]}.json', i);
                    }
                    mapController = controller;

                    print("���̹� �� �ε���!");
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
                    // �??���? 버튼
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
                        showSearch(context: context, delegate: Search(items));
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
                    // ?��보기???
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
              SizedBox(
                height: 29,
                width: 420,
                child: ListView(
                  //카드 ?��?���?
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    for (int i = 0; i < (theCardList.length); i++)
                      // if (selectedCardsIndex[i] == '0')
                      //   cardButton(
                      //       "${Provider.of<SelectedCard>(context).theFinalSelectedCard[i]}")
                      // else
                      //   cardButton10(
                      //       "${Provider.of<SelectedCard>(context).theFinalSelectedCard[i]}"),
                      if (selectedCard == "${theCardList[i]}")
                        cardButton10("${theCardList[i]}")
                      else
                        cardButton("${theCardList[i]}"),
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
        onTap: () async {
          selectedCard = cardName;
          setState(() {});
          for (int i = 0; i < theCardList.length; i++) {
            if (theCardList[i] == cardName) clickedCardIndex = i;
          }
          await fetchShopList();
          await convertToCoords();
          printMarker();
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
          // selectedCardsIndex = [];
          // selectedCards.remove(cardName);
          selectedCard = '';
          setState(() {});
          mapController.clearOverlays();
        },
      ),
    );
  }
}

class CustomNLatLng extends NLatLng {
  CustomNLatLng(double lng, double lat) : super(lng, lat);

  @override
  String toString() {
    return 'NLatLng($latitude,$longitude)';
  }
}
