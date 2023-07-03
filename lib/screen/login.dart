@override
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String id; // late를 붙여줘야 하는 이유 ?
  late String password;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $id, PW: $password');
    } else {
      print('Form is invalid ID: $id, PW: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 222, 105),
        title: Text('로그인 페이지'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 200),
              Container(
                color: Colors.white,
                child: TextFormField(
                  decoration: InputDecoration(
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
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'PW',
                      border: OutlineInputBorder(),
                      hintText: '비밀번호를 입력하세요'),
                  validator: (value) =>
                      value!.isEmpty ? '필수로 입력해야하는 정보입니다.' : null,
                  onSaved: (value) => password = value!,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 25,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 101, 222, 105),
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
