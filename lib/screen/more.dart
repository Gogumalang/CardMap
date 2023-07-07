import 'package:cardmap/screen/cardselection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  MorePage({
    super.key,
  });

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black54,
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "문화 누리 카드",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "아동 복지 카드",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "지역 사랑 카드",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      const CardSelection();
                    },
                    child: const Text(
                      "+ 카드 추가 등록",
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black54,
              ),
              ListTile(
                leading: const Icon(Icons.question_answer_outlined),
                title: const Text("문의"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.my_library_books_outlined),
                title: const Text("마이페이지"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("로그아웃"),
                onTap: signUserOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
