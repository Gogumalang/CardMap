
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List items = [];
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.absolute.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    print('path $path');
    return File('$path/json/$fileName');
  }

  Future<void> read_file(String fileName) async {
    File file = await _localFile(fileName);
    final String response = await file.readAsString();
    final data = await json.decode(response);
    setState(() {
      items = data["items"]; //[{name,addr,...},{name,addr,...},{name,addr,...}]
      print("..number = ${items.length}");
    });
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
  /*
  저장되어있는 모든 카드들을 리스트로 저장한다. read_file 활용
  검색하여서 최대 10개의 항목을 띄운다 . 
  선택하면 해당 부분에 마커와 드로우를 한다. 

  */

  final TextEditingController _filter =
      TextEditingController(); // 검색창에 입력하는 문자열
  FocusNode focusNode = FocusNode();
  late String _searchText; // 검색창에 입력한 것을 반영하여 찾는 문자열.
  var textStream = FirebaseFirestore.instance
      .collection('Card')
      .snapshots(); // 파이어베이스에 저장된 카드 목록들
  _SearchScreenState() {
    // 검색창에 입력하는 모든 순간마다 _searchText 가 최신화가 된다.
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  // 텍스트를 입력하면, 즉각적으로 변화가 일어나야 한다.
  // 텍스트를 입력할 때, 파이어베이스 card collection의 doc 중 해당 텍스트를 포함하는 모든 데이터를 담는다.
  // 담은 변수를 리스트 뷰로 보여준다.

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // 수시로 바뀌는 검색 문자열 때문에 Future 가 아닌, stream 으로 선택했다.
        stream: textStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            late Map<String, dynamic> data; // field 값을 Map으로 저장할 변수
            var searchResults = []; // 원하는 value를 담는 리스트

            for (var doc in snapshot.data!.docs) {
              // 검색한 문자열이 포함되어 있는 값들을 searchResults에 저장하는 과정
              data = doc.data()! as Map<String, dynamic>;
              for (var value in data.values) {
                if (_searchText == "") continue;
                if (value.contains(_searchText)) {
                  print("search : $_searchText");
                  searchResults.add(value);
                  print(searchResults);
                }
              }
            }
            print(data.values);

            return SizedBox(
              height: 500,
              width: 120,
              child: ListView(
                children: [
                  for (int i = 0; i < searchResults.length; i++)
                    ListTile(
                        title: Text("$i ${searchResults[i]}"), onTap: () {}),
                ],
              ),
            );
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 2),
            color: Colors.white,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                  onPressed: () {
                    _filter.clear();
                    _searchText = "";
                    focusNode.unfocus();
                    Get.back();
                  },
                ),
              ),
              Expanded(
                flex: 6,
                child: TextField(
                  focusNode: focusNode,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white60,
                      size: 20,
                    ),
                    suffixIcon: focusNode.hasFocus
                        ? IconButton(
                            onPressed: () async {
                              await read_file("jechun_love.json");
                              //await download("jechun_love.json");

                              // setState(() {
                              //   _filter.clear();
                              //   _searchText = "";
                              // });
                            },
                            icon: const Icon(Icons.cancel, size: 20),
                          )
                        : Container(),
                    hintText: '검색',
                    labelStyle: const TextStyle(color: Colors.white),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              //focusNode.hasFocus ? Expanded(child: Button)
            ]),
          ),
          _buildBody(context),
        ],
      ),
    );
  }
}
