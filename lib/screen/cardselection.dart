import 'dart:io';

import 'package:cardmap/provider/selected_card.dart';
import 'package:cardmap/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CardSelection extends StatefulWidget {
  const CardSelection({super.key});

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  String pClicked = '서울';
  String cClicked = '전체';
  String cardClicked = '';
  List<dynamic> theCardList = [];
  List clickedCardList = [];
  List clickedCardListFinal = [];

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

  final provinceList = [
    '서울',
    '경기',
    '인천',
    '부산',
    '대구',
    '광주',
    '대전',
    '울산',
    '경남',
    '경북',
    '충남',
    '충북',
    '전남',
    '전북',
    '강원',
    '제주',
    '세종',
  ];

  final cityList = [
    ['전체'],
    [
      '전체',
      '과천',
      '안산',
      '안양',
      '광명',
      '광주',
      '구리',
      '군포',
      '동두천',
      '부천',
      '수원',
      '안성',
      '양평',
      '여주',
      '오산',
      '용인',
      '의정부',
      '이천',
      '파주',
      '하남',
      '화성',
      '고양',
      '김포',
      '성남',
      '시흥',
    ],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
    ['전체'],
  ];

  final cardList = [
    [
      [
        '서울 아동급식카드',
        '서울 사랑상품권',
      ],
    ],
    [
      [
        '과천화폐',
        '과천토리',
        '다온',
        '안양 사랑페이',
        '광명 사랑화폐',
        '광주 사랑카드',
        '구리 사랑카드',
        '군포애머니',
        '동두천 사랑카드',
        '부천페이',
        '수원페이',
        '안성 사랑카드',
        '양편통보',
        '여주 사랑카드',
        '오산화폐',
        '오색전',
        '용인 와이페이',
        '의정부 사랑카드',
        '이천 사랑지역화폐',
        '파주페이',
        '하머니',
        '행복화성 지역화폐',
        '고양페이',
        '김포페이',
        '성남 사랑카드',
        '시루',
      ],
      ['과천화폐', '과천토리'],
      ['다온'],
      ['안양 사랑페이'],
      ['광명 사랑화폐'],
      ['광주 사랑카드'],
      ['구리 사랑카드'],
      ['군포애머니'],
      ['동두천 사랑카드'],
      ['부천페이'],
      ['수원페이'],
      ['안성 사랑카드'],
      ['양편통보'],
      ['여주 사랑카드'],
      ['오산화폐', '오색전'],
      ['용인 와이페이'],
      ['의정부 사랑카드'],
      ['이천 사랑지역화폐'],
      ['파주페이'],
      ['하머니'],
      ['행복화성 지역화폐'],
      ['고양페이'],
      ['김포페이'],
      ['성남 사랑카드'],
      ['시루'],
    ],
    [
      ['인천e음'],
    ],
    [
      ['동백전'],
    ],
    [
      ['대구로페이'],
    ],
    [
      ['광주상생카드'],
    ],
    [
      ['대전 사랑카드'],
    ],
    [
      ['울산페이'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
    [
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
      ['아동 복지 카드', '문화 누리 카드', '지역 사랑 카드'],
    ],
  ];

  var cardListIndex = [
    [
      [0, 0],
    ],
    [
      [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ],
      [0, 0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0, 0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
    [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ],
  ];

  Future<void> saveUserCards() async {
    print('start');

    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("users").doc(user.email!).set({
      "cardlist": Provider.of<SelectedCard>(context, listen: false)
          .theFinalSelectedCard,
    });
    print("idek");
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
    clickedCardList = theCardList;
    setState(() {});
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.absolute.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    print('path $path');
    return File('$path/json/$fileName');
  }

  Future<void> download(String fileName) async {
    File file = await _localFile(fileName);
    //File("/Users/parkseyoung/Documents/CardMap/assets/json/seyoung.json");

    final downloadTask =
        FirebaseStorage.instance.ref("files/$fileName").writeToFile(file);

    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          // print("실행중이다..");
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          print("멈춤중이다..");
          break;
        case TaskState.success:
          // TODO: Handle this case.
          print("성공중이다..");
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          print("취소중이다..");
          break;
        case TaskState.error:
          // TODO: Handle this case.
          print("에러중이다..");
          break;
      }
    });
  }

  Future<bool> isExist(String fileName) async {
    final file = await _localFile(fileName);
    return await file.exists();
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

  @override
  void initState() {
    getCardList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refreshCardListIndex(clickedCardList);
    container1(String location) {
      return Container(
        width: 91,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(10, 0, 0, 0),
          border: BorderDirectional(
            end: BorderSide(width: 1, color: Colors.black38),
          ),
        ),
        child: TextButton(
          onPressed: () {
            pClicked = location;
            cClicked = '전체';
            setState(() {});
          },
          child: Text(
            location,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    container10(String location) {
      return Container(
        width: 91,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: BorderDirectional(
            top: BorderSide(width: 1, color: Colors.black38),
            bottom: BorderSide(width: 1, color: Colors.black38),
          ),
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            location,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    container2(String location) {
      return Container(
        width: 171,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            end: BorderSide(width: 1, color: Colors.black38),
          ),
        ),
        child: TextButton(
          onPressed: () {
            cClicked = location;
            cardClicked = '';
            setState(() {});
          },
          child: Text(
            location,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    container20(String location) {
      return Container(
        width: 171,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 220, 250, 220),
          border: BorderDirectional(
            end: BorderSide(width: 1, color: Colors.black38),
          ),
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            location,
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      );
    }

    container3(String location) {
      return Container(
        width: 168,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TextButton(
          onPressed: () {
            cardClicked = location;
            clickedCardList.add(location);
            for (int i = 0; i < provinceList.length; i++) {
              if (provinceList[i] == pClicked) {
                for (int j = 0; j < cityList[i].length; j++) {
                  if (cityList[i][j] == cClicked) {
                    for (int k = 0; k < cardList[i][j].length; k++) {
                      if (cardList[i][j][k] == location) {
                        cardListIndex[i][j][k] = 1;
                      }
                    }
                  }
                }
              }
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      );
    }

    container30(String location) {
      return Container(
        width: 168,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 220, 250, 220),
        ),
        child: TextButton(
          onPressed: () {
            clickedCardList.remove(location);
            for (int i = 0; i < provinceList.length; i++) {
              if (provinceList[i] == pClicked) {
                for (int j = 0; j < cityList[i].length; j++) {
                  if (cityList[i][j] == cClicked) {
                    for (int k = 0; k < cardList[i][j].length; k++) {
                      if (cardList[i][j][k] == location) {
                        cardListIndex[i][j][k] = 0;
                      }
                    }
                  }
                }
              }
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );
    }

    container4(String location) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 220, 250, 220),
            border: BorderDirectional(
              top: BorderSide(width: 1, color: Colors.lightGreen),
              start: BorderSide(width: 1, color: Colors.lightGreen),
              end: BorderSide(width: 1, color: Colors.lightGreen),
              bottom: BorderSide(width: 1, color: Colors.lightGreen),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    clickedCardList.remove(location);
                    for (int i = 0; i < provinceList.length; i++) {
                      for (int j = 0; j < cityList[i].length; j++) {
                        for (int k = 0; k < cardList[i][j].length; k++) {
                          if (cardList[i][j][k] == location) {
                            cardListIndex[i][j][k] = 0;
                          }
                        }
                      }
                    }
                    setState(() {});
                  },
                  constraints: BoxConstraints.tight(const Size(15, 24)),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  iconSize: 18,
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            //context.read<SelectedCard>().updateCardList(temporary);
            //setState(() {});
            Get.back();
          },
        ),
        title: const Text(
          "카드 선택",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 8),
                  child: Row(
                    children: [
                      Text(
                        "카드를 선택해주세요.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  //controller: idController,
                  decoration: const InputDecoration(
                      labelText: '카드검색',
                      labelStyle: TextStyle(color: Colors.black38),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 36,
                      ),
                      hintText: '안서영 바보'),
                ),
                //Row(children: [Icon(Icons.)],)
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 0,
            thickness: 1,
            color: Colors.black,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                child: Text(
                  '시/도',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Text(
                '|',
                style: TextStyle(color: Colors.black38),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                child: Text(
                  '시/구/군',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Text(
                '|',
                style: TextStyle(color: Colors.black38),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 59),
                child: Text(
                  '카드종류',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
          const Divider(
            height: 0,
            thickness: 1,
            color: Colors.black12,
          ),
          Row(
            children: [
              SizedBox(
                  height: 500,
                  width: 91,
                  child: ListView(
                    children: [
                      for (int i = 0; i < provinceList.length; i++)
                        if (provinceList[i] == pClicked)
                          container10(provinceList[i])
                        else
                          container1(provinceList[i]),
                    ],
                  )),
              SizedBox(
                height: 500,
                width: 169,
                child: ListView(
                  children: [
                    for (int i = 0; i < provinceList.length; i++)
                      if (provinceList[i] == pClicked)
                        for (int j = 0; j < cityList[i].length; j++)
                          if (cityList[i][j] == cClicked)
                            container20(cityList[i][j])
                          else
                            container2(cityList[i][j]),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                width: 170,
                child: ListView(
                  children: [
                    for (int i = 0; i < provinceList.length; i++)
                      if (provinceList[i] == pClicked)
                        for (int j = 0; j < cityList[i].length; j++)
                          if (cityList[i][j] == cClicked)
                            for (int k = 0; k < cardList[i][j].length; k++)
                              if (cardListIndex[i][j][k] == 1)
                                container30(cardList[i][j][k])
                              else
                                container3(cardList[i][j][k]),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 0,
            thickness: 1,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 35,
              width: 420,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < clickedCardList.length; i++)
                    container4(clickedCardList[i])
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 115, vertical: 16)),
                ),
                onPressed: () async {
                  clickedCardListFinal = clickedCardList;

                  Provider.of<SelectedCard>(context, listen: false)
                      .updateCardList(clickedCardListFinal);

                  setState(() {});
                  saveUserCards();
                  for (int i = 0; i < clickedCardListFinal.length; i++) {
                    bool a = await isExist(
                        '${cardNameDictionary[theCardList[i]]}.json');
                    print(cardNameDictionary[theCardList[i]]);

                    if (!a) {
                      await download(
                          '${cardNameDictionary[theCardList[i]]}.json');
                    }
                  }

                  Get.to(const HomePage(), transition: Transition.noTransition);
                },
                child: const Text(
                  '등록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              TextButton.icon(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black12),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 10, vertical: 14)),
                ),
                onPressed: () async {
                  for (int i = 0; i < provinceList.length; i++) {
                    for (int j = 0; j < cityList[i].length; j++) {
                      for (int k = 0; k < cardList[i][j].length; k++) {
                        cardListIndex[i][j][k] = 0;
                        container3(cardList[i][j][k]);
                      }
                    }
                  }
                  clickedCardList.clear();
                  setState(() {});
                  // int a;
                  // a = await deleteFile("seoul_adong.json");
                  // print(await isExist("seoul_adong.json"));
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                label: const Text(
                  '초기화',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void refreshCardListIndex(List<dynamic> clickedCardList) {
    for (int h = 0; h < clickedCardList.length; h++) {
      for (int i = 0; i < provinceList.length; i++) {
        for (int j = 0; j < cityList[i].length; j++) {
          for (int k = 0; k < cardList[i][j].length; k++) {
            if (cardList[i][j][k] == clickedCardList[h]) {
              cardListIndex[i][j][k] = 1;
            }
          }
        }
      }
    }
  }
}
