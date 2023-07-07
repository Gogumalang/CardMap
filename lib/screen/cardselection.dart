import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSelection extends StatefulWidget {
  const CardSelection({super.key});

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  @override
  Widget build(BuildContext context) {
    container1(String location) {
      return Container(
        width: 91,
        height: 30,
        decoration: const BoxDecoration(
            color: Color.fromARGB(1, 0, 0, 0),
            border: BorderDirectional(
                end: BorderSide(width: 1, color: Colors.black38))),
        child: TextButton(
          onPressed: () {},
          child: Text(location),
        ),
      );
    }

    container2(String location) {
      return Container(
        width: 169,
        height: 30,
        decoration: const BoxDecoration(color: Colors.white),
        child: TextButton(
          onPressed: () {},
          child: Text(location),
        ),
      );
    }

    container3(String location) {
      return Container(
        width: 170,
        height: 30,
        decoration: const BoxDecoration(
            color: Colors.white,
            border: BorderDirectional(
                start: BorderSide(width: 1, color: Colors.black38))),
        child: TextButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(location),
                const Icon(Icons.check),
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
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                child: Text(
                  '동/읍/면',
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
                  height: 650,
                  width: 91,
                  child: ListView(
                    children: [
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('서울'),
                      container1('경기'),
                      container1('인천'),
                      container1('부산'),
                      container1('인도'),
                    ],
                  )),
              SizedBox(
                height: 650,
                width: 169,
                child: ListView(
                  children: [
                    container2('과천시'),
                    container2('광명시'),
                    container2('광주시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('과천시'),
                    container2('광명시'),
                    container2('광주시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                    container2('구리시'),
                  ],
                ),
              ),
              SizedBox(
                height: 650,
                width: 170,
                child: ListView(
                  children: [
                    container3('경안동'),
                    container3('고산동'),
                    container3('남종면'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('경안동'),
                    container3('고산동'),
                    container3('남종면'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
                    container3('곤지암읍'),
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
