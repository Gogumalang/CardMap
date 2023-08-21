import 'dart:io';

import 'package:cardmap/screen/cardselection.dart';
import 'package:cardmap/screen/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    super.key,
  });

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  /*------------------------------------------------*/

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
          print("실행중이다..");
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

  Future<void> read_file(String fileName) async {
    File file = await _localFile(fileName);
    final String response = await file.readAsString();
    print(response);
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

  /*------------------------------------------------*/

  CardSelection card = const CardSelection();
  final user = FirebaseAuth.instance.currentUser!;
  List<dynamic> theCardList = [];

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getCardList();
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            50,
            20,
            20,
          ), //const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.settings,
                    size: 35,
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/hamzzi.jpeg'),
                // backgroundImage: NetworkImage(
                //     "https://img.freepik.com/premium-vector/cute-hamster-sitting-icon-illustration-hamster-mascot-cartoon-character-animal-icon-concept-white-isolated_138676-906.jpg"),
                child: ClipOval(),
              ),
              const SizedBox(
                height: 15,
              ),
              const Center(
                child: Text(
                  "안서영",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  user.email!,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.black38,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 70,
                child: ListView(
                  children: const [
                    // for(int i = 0; i < card.clickedCardListFinal.length; i++);
                  ],
                ),
              ),
              for (int i = 0; i < (theCardList.length); i++)
                cardList("${theCardList[i]}"),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(
                        const CardSelection(),
                      );
                    },
                    child: const Text(
                      "+ 카드 추가 등록",
                      style: TextStyle(color: Colors.lightGreen),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black38,
              ),
              ListTile(
                leading: const Icon(
                  Icons.question_answer_outlined,
                  color: Colors.lightGreen,
                ),
                title: const Text(
                  "문의",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Get.to(const ChatScreen());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.lightGreen,
                ),
                title: const Text(
                  "로그아웃",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: signUserOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding cardList(String cardName) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        cardName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
