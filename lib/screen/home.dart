
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.withOpacity(0.1),
      ),
      body: NaverMap(
        options: const NaverMapViewOptions(
          locationButtonEnable: true, // 현 위치를 나타내는 버튼
          mapType: NMapType.navi,
          nightModeEnable: true,
          extent: NLatLngBounds(
            southWest: NLatLng(31.43, 122.37),
            northEast: NLatLng(44.35, 132.0),
          ),
        ),
        onMapReady: (controller) {
          print("네이버 맵 로딩됨!");
          // final infoWindow = NInfoWindow.onMap(
          //     id: "test", position: target, text: "인포윈도우 텍스트");
          // controller.addOverlay(infoWindow);
        },
      ),
    );
  }
}
