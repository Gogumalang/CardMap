import 'package:cardmap/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  late String id;

  passwordReset() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: idController.text.trim())
          .then(
            (value) => {
              Navigator.pop(context),
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("이메일이 전송 되었습니다!!"),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('확인'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(() => const LoginPage(),
                              transition: Transition.noTransition);
                        },
                      ),
                    ],
                  );
                },
              ),
            },
          );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        showSnackBar(context, const Text('존재하지 않는 이메일 입니다.'));
        //errorMessage('존재하지 않는 이메일 입니다.');
      }
    }
  }

  void showSnackBar(BuildContext context, Text text) {
    final snackBar = SnackBar(
      content: text,
      backgroundColor: const Color.fromARGB(255, 112, 48, 48),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(message), actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
      },
    );
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Stack(
        children: [
          const NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(36.1030521, 129.391357), zoom: 14.5),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 110),
                Center(
                    child: Image.asset(
                        'assets/images/CardmapLogo.png')), // 로고 이미지 추가
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 600,
                  decoration: const BoxDecoration(
                    // 동글동글한 흰색 Box
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.lightGreen,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            const Text(
                              "비밀번호 찾기",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Center(
                          child: Text(
                            "새 비밀번호를 발급받을 이메일을 입력해주세요.",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Padding(
                          // ID입력란
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: idController,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                hintText: '이메일을 입력하세요'),
                            validator: (value) =>
                                value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                            onSaved: (value) => id = value!,
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          // 시작하기
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 260,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 156, 221, 82),
                                  borderRadius: BorderRadius.circular(50)),
                              child: TextButton(
                                onPressed: passwordReset,
                                child: const Center(
                                  child: Text(
                                    "이메일 전송",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
