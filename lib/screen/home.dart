import 'dart:convert';
import 'package:cardmap/model/market_model.dart';
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
  List findItems = []; // Ï∞æÍ≥†?ûê ?ïò?äî Î≤îÏúÑ ?Ç¥?óê ?ûà?äî Î™®Îì† Ï£ºÏÜå Î¶¨Ïä§?ä∏
  List shop = []; //Í∞?ÎßπÏ†ê ?ïò?ÇòÎ•? ????û•?ïò?äî Î≥??àò
  late Map<String, dynamic> location;
  late List<String>
      address; // fetchAddress ?ã§?ñâ?ñà?ùÑ ?ïå Î¶¨ÌÑ¥ Î∞õÎäî Î≥??àò, Ï£ºÏÜåÎ•? Ï∂úÎ†•?ïú?ã§.
  // List<Map<String, dynamic>> findCoords = [];
  List<MarketModel> findCoords = [];

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy", // Í∞úÏù∏ ?Å¥?ùº?ù¥?ñ∏?ä∏ ?ïÑ?ù¥?îî
    "X-NCP-APIGW-API-KEY":
        "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL" // Í∞úÏù∏ ?ãú?Å¨Î¶? ?Ç§
  };
  @override
  void initState() {
    // ?òÑ?û¨ ?úÑÏπòÎ?? Î∞õÏïÑ?ò§Í∏?
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
    // ?õê?ïò?äî Ï£ºÏÜå?ùò Í∞?ÎßπÏ†ê?ùÑ Í∞??†∏?ò®?ã§.
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

    return (shop[0]);
  }

  Future<List<String>> cameraLocation() async {
    // Ïπ¥Î©î?ùº ?úÑÏπòÎ?? Ï£ºÏÜåÎ°? Î≥??ôò?ïú?ã§.
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

  Future<void> readJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/json/seoul.json');
    final data = await json.decode(response);
    setState(() {
      items = data["items"]; //[{name,addr,...},{name,addr,...},{name,addr,...}]
      print("..number = ${items.length}");
    });
    print('readJsonFile');
  }

  Future<void> fetchShopList() async {
    // ?õê?ïò?äî Î¨∏Ïûê?ó¥?ùÑ ?è¨?ï®?ïò?äî Î™©Î°ù?ì§?ùÑ listÎ°? ????û•?ïò?äî ?ï®?àò
    List<String> findlist = await cameraLocation();
    findItems = items
        .where(
            (element) => element['road_addr'].toString().contains(findlist[2]))
        .toList();
    print(findItems);
    print("Fetch start!");
  }

  Future<void> convertToCoords() async {
    print("-------------convertToCoords------------------");
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
          //print("Î©îÎ°±~ ");
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

  Future<void> directGuide() async {
    String message;
    print("-------------Get Direction Guide------------------");

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    http.Response Directionresponse = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-direction-15/v1/driving?start=127.0823,37.5385&goal=127.0838,37.5382'),
        headers: headerss);

    message = Directionresponse.body;
    print(message);

    List<dynamic> polylines =
        jsonDecode(message)["route"]["traoptimal"][0]["path"];

    List<dynamic> coords = [];
    for (int i = 0; i < polylines.length; i++) {
      coords.add(polylines[i]);
    }
// String toString() {
//     return 'NLatLng(${lng},${lat})';
//   }
    List<NLatLng> coordinates = coords.map((coord) {
      double longitude = coord[0];
      double latitude = coord[1];
      return CustomNLatLng(coord[0], coord[1]);
    }).toList();

    print(coordinates);

    var polyline = NPolylineOverlay(
        id: 'test1004', coords: coordinates, color: Colors.blue, width: 1);
    mapController.addOverlay(polyline);
    polylines.add(polyline);
  }

  NAddableOverlay makeOverlay({
    // marker ?ïò?Çò ?Éù?Ñ±?ïú?ã§.
    required NLatLng position,
    required String id,
  }) {
    final overlayId = id;
    final point = position;
    return NMarker(
        id: overlayId,
        position: point,
        icon:
            const NOverlayImage.fromAssetImage('assets/images/CardmapLogo.png'),
        size: const Size(50, 50),
        isHideCollidedMarkers: true,
        isHideCollidedSymbols: true);
    //return NMarker(id: overlayId, position: point);
  }

  void setMarker(int index) {
    //marker?ùò ?èô?ûë?ùÑ Ïß??†ï?ïòÍ≥?, ?ï± ?ôîÎ©¥Ïóê ?ùÑ?ö¥?ã§.
    final NAddableOverlay<NOverlay<void>> overlay = makeOverlay(
        id: '$index',
        position: NLatLng(double.parse(findCoords[index].lat!),
            double.parse(findCoords[index].lon!)));

    overlay.setOnTapListener((overlay) async {
      infoWindow(index);
      await directGuide();
    });

    mapController.addOverlay(overlay);
  }

  // NAddableOverlay changeOverlay({
  //   // marker ?Å¥Î¶? ?ãú marker?ùò UI Î≥?Í≤?
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
    //?ôîÎ©¥Ïóê ?ùÑ?ö∞?äî Í≥ºÏ†ï?ùÑ findCoords ÎßåÌÅº Î∞òÎ≥µ?ïú?ã§.
    print("printMarker start !");
    for (int i = 0; i < findCoords.length; i++) {
      setMarker(i);
    }
    //findCoords.clear();
    //print("Í≥ºÏó∞ ..... $findCoords");
    print("PM fin.");
  }

  void infoWindow(int index) async {
    // marker Î•? ?Å¥Î¶??ñà?ùÑ ?ïå, ?ÉÅ?Ñ∏ ?†ïÎ≥¥Î?? ?ùÑ?õåÏ§??ã§.
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
                  height: 10,
                ),
                // Icon(Icons.l
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
                Text(
                  '${findCoords[index].road_addr}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (findCoords[index].phone != null)
                  Text(
                    '?†Ñ?ôîÎ≤àÌò∏ : ${findCoords[index].phone}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
          );
        });
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
                    // naver map ?òµ?Öò?ùÑ ?Ñ∏?åÖ?ïò?äî ?úÑ?†Ø
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true, // ?òÑ ?úÑÏπòÎ?? ?Çò????Ç¥?äî Î≤ÑÌäº
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  onMapReady: (controller) async {
                    // NaverMap.setLocation(locationSorce)
                    await readJsonFile(); //Í∞?ÎßπÏ†ê ?†ïÎ≥? ?ùΩ?ñ¥?ò§Í∏?

                    mapController = controller;

                    print("≥◊¿Ãπˆ ∏  ∑Œµ˘µ !");
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
                    // Í≤??ÉâÏ∞? Î≤ÑÌäº
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
                        await fetchShopList();
                        await convertToCoords();
                        printMarker();
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
                    // ?çîÎ≥¥Í∏∞???
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
                  //Ïπ¥Îìú ?ä§?Å¨Î°?
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    for (int i = 0;
                        i <
                            (context
                                .watch<SelectedCard>()
                                .theFinalSelectedCard
                                .length);
                        i++)
                      if (selectedCardsIndex[i] == '0')
                        cardButton(
                            "${Provider.of<SelectedCard>(context).theFinalSelectedCard[i]}")
                      else
                        cardButton10(
                            "${Provider.of<SelectedCard>(context).theFinalSelectedCard[i]}"),
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
        i < (Provider.of<SelectedCard>(context).theFinalSelectedCard.length);
        i++) {
      clickedChecked = false;
      for (int j = 0; j < selectedCards.length; j++) {
        if (Provider.of<SelectedCard>(context).theFinalSelectedCard[i] ==
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

  // public void onMapReady(@NonNull NaverMap naverMap){
  //   this.naverMap = naverMap;

  //   naverMap.setLocationSource(locationSource);
  //   ActivityCompat.requestPer
  // }

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

class CustomNLatLng extends NLatLng {
  CustomNLatLng(double lng, double lat) : super(lng, lat);

  @override
  String toString() {
    return 'NLatLng($latitude,$longitude)';
  }
}
