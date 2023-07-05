// import 'dart:html';

import 'package:cardmap/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  late String id;
  late String password;

  void signUserUp() async {
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
      if (pwController.text == confirmPwController.text) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: idController.text,
              password: pwController.text,
            )
            .then((value) => Navigator.pop(context));
      } else {
        Navigator.pop(context);
        errorMessage('비밀번호가 일치하지 않습니다.');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //print(e);
      if (e.code == 'email-already-in-use') {
        errorMessage('이미 사용중인 이메일 입니다.');
      } else if (e.code == 'weak-password') {
        errorMessage('비밀번호가 6자리 이상이어야 합니다.');
      }
    }
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
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.lightGreen,
      body: Stack(
        children: [
          NaverMap(
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
                Center(child: Image.asset('assets/images/CardmapLogo.png')),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 600,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  padding: const EdgeInsets.all(50),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: const ButtonStyle(),
                              onPressed: () {
                                Get.to(() => const LoginPage(),
                                    transition: Transition.noTransition);
                              },
                              child: const Column(
                                children: [
                                  Text(
                                    "로그인",
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                               ),
                            const SizedBox(
                              width: 42,
                            ),
                        Container(
                          decoration: const BoxDecoration(
                              border: BorderDirectional(
                                  bottom: BorderSide(
                                      width: 2, color: Colors.lightGreen))),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "회원가입",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black38),
                            border: OutlineInputBorder(),
                            hintText: '이메일을 입력하세요'),
                        validator: (value) =>
                            value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                        onSaved: (value) => id = value!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        controller: pwController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black38),
                            border: OutlineInputBorder(),
                            hintText: '비밀번호를 입력하세요'),
                        validator: (value) =>
                            value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                        onSaved: (value) => password = value!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: TextFormField(
                        controller: confirmPwController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black38),
                            border: OutlineInputBorder(),
                            hintText: '비밀번호를 입력하세요'),
                        validator: (value) =>
                            value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                        onSaved: (value) => password = value!,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 260,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 156, 221, 82),
                              borderRadius: BorderRadius.circular(50)),
                          child: TextButton(
                            onPressed: signUserUp,
                            child: const Center(
                              child: Text(
                                "시작하기",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,

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
