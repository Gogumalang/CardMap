import 'package:cardmap/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  late String _searchText;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: firestore.collection('Card').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data! == null) {
              return const Center(
                child: Text('data empty'),
              );
            } else {
              var searchResults = [];

              for (var doc in snapshot.data!.docs) {
                if (doc.data().toString().contains(_searchText)) {
                  searchResults.add(doc.data());
                }
              }

              return ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    textColor: Colors.amber,
                    title: Text(searchResults[index]['name']),
                    subtitle: Text(searchResults[index]['company']),
                  );
                },
              );
            }
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  // Widget _buildList(
  //     BuildContext context, List<QueryDocumentSnapshot<Object?>> documents) {
  //   var searchResults = [];

  //   for (var doc in documents) {
  //     if (doc.data().toString().contains(_searchText)) {
  //       searchResults.add(doc.data());
  //     }
  //   }

  //   return ListView.builder(
  //     itemCount: searchResults.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return ListTile(
  //         textColor: Colors.amber,
  //         title: Text(searchResults[index]['name']),
  //         subtitle: Text(searchResults[index]['company']),
  //       );
  //     },
  //   );
  // }

  //Widget _buildListItem(BuildContext context, DocumentSnapshot data) {}

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
                    Get.off(const HomePage(),
                        transition: Transition.noTransition);
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
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
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
              //   focusNode.hasFocus ? Expanded(child: Button)
            ]),
          ),
          _buildBody(context),
        ],
      ),
    );
  }
}
