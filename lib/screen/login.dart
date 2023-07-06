import 'package:cardmap/screen/forgot.dart';
import 'package:cardmap/screen/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwController = TextEditingController();

  late String id;
  late String password;

  void logUserIn() async {
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
          .signInWithEmailAndPassword(
            email: idController.text,
            password: pwController.text,
          )
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //print(e);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        errorMessage('존재하지 않는 이메일 입니다.');
      } else if (e.code == 'wrong-password') {
        errorMessage('비밀번호가 틀렸습니다.');
      }
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
                  padding: const EdgeInsets.all(50),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.lightGreen),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: Colors.lightGreen))),
                                  child: TextButton(
                                    // 로그인 버튼
                                    style: const ButtonStyle(),
                                    onPressed: () {},
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 42,
                            ),
                            TextButton(
                              // 회원가입 버튼
                              onPressed: () {
                                Get.to(() => const SignUpPage(),
                                    transition: Transition.noTransition);
                              },
                              child: const Text(
                                "회원가입",
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Padding(
                          // ID입력란
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: idController,
                            decoration: const InputDecoration(
                                labelText: 'ID',
                                labelStyle: TextStyle(color: Colors.black38),
                                border: OutlineInputBorder(),
                                hintText: '아이디를 입력하세요'),
                            validator: (value) =>
                                value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                            onSaved: (value) => id = value!,
                          ),
                        ),
                        Padding(
                          // PW 입력란
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
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
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          // Forgot Password 입력란
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  const ForgotPasswordPage(),
                                  transition: Transition.noTransition,
                                );
                              },
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 13),
                          ],
                        ),
                        const SizedBox(height: 53),
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
                                onPressed: logUserIn,
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
