import 'package:cardmap/screen/forgot.dart';
import 'package:cardmap/screen/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String errorMsg = '';

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
      if (e.code == 'invalid-email' && idController.text.isNotEmpty) {
        setState(() {});
        errorMsg = '이메일 형식이 올바르지 않습니다.';
      } else if (e.code == 'user-not-found' && idController.text.isNotEmpty) {
        setState(() {});
        errorMsg = '존재하지 않는 이메일 입니다.';
      } else if (e.code == 'wrong-password' && pwController.text.isNotEmpty) {
        setState(() {});
        errorMsg = '비밀번호가 틀렸습니다.';
      }
    }
  }

  // void errorMessage(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('확인'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          Image.asset('assets/images/background.jpeg'),
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
                  height: 551,
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
                            Container(
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(
                                      bottom: BorderSide(
                                          width: 2, color: Colors.lightGreen))),
                              child: TextButton(
                                // 로그인 버튼
                                style: const ButtonStyle(),
                                onPressed: () {},
                                child: const Text(
                                  "로그인",
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 42,
                            ),
                            TextButton(
                              // 회원가입 버튼
                              onPressed: () {
                                Get.to(const SignUpPage(),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: idController,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.black38),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black38,
                                ),
                                hintText: '아이디를 입력하세요'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '필수로 입력해야하는 정보입니다.';
                              }
                              return null;
                            },
                            onSaved: (value) => id = value!,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          // PW 입력란
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: pwController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.black38),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.black38,
                                ),
                                hintText: '비밀번호를 입력하세요'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '필수로 입력해야하는 정보입니다.';
                              }
                              return null;
                            },
                            onSaved: (value) => password = value!,
                          ),
                        ),
                        Row(
                          // Forgot Password 입력란
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(const ForgotPasswordPage(),
                                    transition: Transition.noTransition);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.lightGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 13),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            errorMsg,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 32),
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
