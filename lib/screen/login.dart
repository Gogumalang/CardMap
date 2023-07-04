import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwController = TextEditingController();

  late String id; // late를 붙여줘야 하는 이유 ?
  late String password;

  void validateAndSave() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: idController.text,
        password: pwController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('wrong email');
      } else if (e.code == 'wrong-password') {
        print('wrong password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 101, 222, 105),
      //   title: const Text('로그인 페이지'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "CardMap",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "사용 가능 가맹점이 제한되어 있어 카드 이용에 불편함을 겪는 분들을 위하여 사용가능 가맹점을 지도에 한 눈에 나타내는 앱",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
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
                      SizedBox(
                        width: 42,
                      ),
                      TextButton(
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
                    ],
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                          hintText: '아이디를 입력하세요'),
                      validator: (value) =>
                          value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                      onSaved: (value) => id = value!,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: pwController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'PW',
                          border: OutlineInputBorder(),
                          hintText: '비밀번호를 입력하세요'),
                      validator: (value) =>
                          value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                      onSaved: (value) => password = value!,
                    ),
                  ),
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
                          onPressed: validateAndSave,
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //SizedBox(width: 0.2),
                      TextButton(
                        onPressed: () {},
                        child: Text("자동완성"),
                      ),
                      TextButton(
                        onPressed: () {
                          //TODO FORGOT PASSWORD SCREEN GOES HERE
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.black, fontSize: 15),
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
    );
  }
}
