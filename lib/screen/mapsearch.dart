import 'dart:convert';

import 'package:cardmap/model/market_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Search extends SearchDelegate {
  final List<List<Map<String, dynamic>>> items;

  Search(this.items); // 사용자가 저장한 카드 가맹점 전체 목록을 가져온다. (검색 자료로 활용하기 위함.)

  @override
  List<Widget>? buildActions(BuildContext context) {
    /*
      왼쪽 상단에 있는 아이콘을 만들었다. 
      query 를 초기화 하는 역할을 한다. 
    */

    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    /*
      우측 상단에 있는 아이콘을 만들었다. 
      뒤로가기 버튼이다. 
    */
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  late Map<String, dynamic> selectedResult;

  @override
  Widget buildResults(BuildContext context) {
    /*
      showResult 함수를 실행시키면(on Tap 할 때 실행됨. ) 결과를 화면에 빌드 시키는 메소드이다. 
    */
    return SearchResult(selectedResult);
  }

  List<Map<String, dynamic>> emptyList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    /*
      query(사용자가 검색하는 내용)를 포함하는 결과들을 띄우는 메소드이다. 
      사용자 카드 가맹점 이름에 query를 포함하면 ListTile 로 검색 결과들을 띄운다. 
      ListTile 에는 간단한 이름과 주소가 나타난다. 
      ListTile 을 터치를 하면 해당 결과를 가져와서 네이버 맵에 마커를 띄우게 된다. 
    */
    List<Map<String, dynamic>> suggestionList = [];
    if (query.isEmpty) {
      suggestionList = emptyList;
    } else {
      for (List<Map<String, dynamic>> item in items) {
        int count = 0;
        for (Map<String, dynamic> element in item) {
          if (element["name"].toString().contains(query)) {
            suggestionList.add(element);
            count++;
          }
          if (count == 7) break;
        }
      }
    }

    return suggestionList.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: const Icon(
                    Icons.map_outlined,
                    size: 33,
                  ),
                  subtitle: suggestionList[index]["road_addr"].isEmpty
                      ? Text(suggestionList[index]["addr"])
                      : Text(suggestionList[index]["road_addr"]),
                  title: Text(
                    suggestionList[index]["name"],
                    textScaleFactor: 1.1,
                  ),
                  onTap: () {
                    selectedResult = suggestionList[index];
                    query = selectedResult["name"];
                    showResults(context);
                  },
                  shape:
                      const Border(bottom: BorderSide(color: Colors.black12)));
            });
  }
}

class SearchResult extends StatefulWidget {
  final Map<String, dynamic> result;
  const SearchResult(this.result, {super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  /* 선택한 가맹점 결과를 받아온다. 
      결과에서 주소를 추출하여 좌표로 바꾼다. (convert to coord 함수 활용)
      해당 좌표와 기존 결과를 합쳐서 market_model 로 저장한다. 
      initCameraposition을 해당 좌표로 표시하여 맵이 로딩이 될 때 가맹점이 보이게 한다. 
      맵이 로딩이 되면, 해당 가맹점 마커를 띄운다.(printMarker 함수 활용)
  */

  late Map<String, dynamic> result;
  late Position position;
  late NCameraPosition initCameraPosition;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isReady = false;

  late Map<String, dynamic> location;
  late List<String> address;

  late NaverMapController mapController;

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "73oah8omwy",
    "X-NCP-APIGW-API-KEY": "rEFG1h9twWTR4P2GBIpB7gPIb70PZex3ZIt38hOL"
  };
  @override
  void initState() {
    super.initState();
    result = widget.result;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initState에서도 asnyc를 사용하기 위한 방법.
      convertToCoords();
    });
  }

  MarketModel find = MarketModel();
  Future<void> convertToCoords() async {
    print("-------------convertToCoords------------------");
    String lon;
    String lat;
    String jsonCoords;
    String query = result['road_addr'];

    http.Response responseGeocode;
    responseGeocode = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
        headers: headerss);

    jsonCoords = responseGeocode.body;
    if (jsonDecode(jsonCoords)["meta"]["totalCount"] == 0) {
    } else {
      lon = jsonDecode(jsonCoords)["addresses"][0]['x'];
      lat = jsonDecode(jsonCoords)["addresses"][0]['y'];
      find = MarketModel(lat: lat, lon: lon);
      find.fromJson(result);
    }
    setState(() {
      initCameraPosition = NCameraPosition(
          target: NLatLng(double.parse(find.lat!), double.parse(find.lon!)),
          zoom: 19);
      isReady = true;
    });
  }

  Future<void> directGuide(int index) async {
    String message;
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String currentLat = currentPosition.latitude.toString();
    String currentLon = currentPosition.longitude.toString();

    http.Response Directionresponse = await http.get(
        Uri.parse(
            'https://naveropenapi.apigw.ntruss.com/map-direction-15/v1/driving?start=$currentLon,$currentLat&goal=${find.lon},${find.lat}'),
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
      color: Colors.green,
      width: 10,
      outlineColor: Colors.green,
    );
    await mapController.addOverlay(path);
  }

  NAddableOverlay makeOverlay({
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
  }

  void setMarker(int index) {
    final NAddableOverlay<NOverlay<void>> overlay = makeOverlay(
        id: '$index',
        position: NLatLng(double.parse(find.lat!), double.parse(find.lon!)));

    overlay.setOnTapListener((overlay) async {
      infoWindow(index);
    });

    mapController.addOverlay(overlay);
  }

  void printMarker() {
    setMarker(1);
    //findCoords.clear();
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
                  height: 10,
                ),
                // Icon(Icons.l
                Text(
                  '${find.name}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${find.road_addr}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (find.phone != null)
                  Text(
                    '?��?��번호 : ${find.phone}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Container(
                    width: 120,
                    height: 70,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.lightGreen,
                    ),
                    child: const Center(
                      child: Text(
                        "길찾기",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: Stack(
        children: [
          isReady
              ? NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: initCameraPosition,
                    locationButtonEnable: true,
                    mapType: NMapType.basic,
                    nightModeEnable: true,
                    extent: const NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                  ),
                  onMapReady: (controller) async {
                    mapController = controller;
                    printMarker();
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
