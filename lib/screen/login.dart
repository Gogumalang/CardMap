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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 222, 105),
        title: const Text('로그인 페이지'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 200),
              Container(
                color: Colors.white,
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
              const SizedBox(height: 10),
              Container(
                color: Colors.white,
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
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 25,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 101, 222, 105),
                    borderRadius: BorderRadius.circular(50)),
                child: TextButton(
                  onPressed: validateAndSave,
                  child: const Center(
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
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
        ),
      ),
    );
  }
}
