import 'package:cardmap/provider/selected_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                onPressed: () {
                  clickedCardListFinal = clickedCardList;

                  Provider.of<SelectedCard>(context, listen: false)
                      .updateCardList(clickedCardListFinal);

                  setState(() {});
                  saveUserCards();
                  Get.back();
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
                onPressed: () {
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
