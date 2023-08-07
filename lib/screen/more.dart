import 'package:cardmap/screen/cardselection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    super.key,
  });

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getCardList();
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20, //left
            50, //top
            20, //right
            20, //down
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
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.my_library_books_outlined,
                  color: Colors.lightGreen,
                ),
                title: const Text(
                  "마이페이지",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {},
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
