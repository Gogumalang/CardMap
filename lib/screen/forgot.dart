import 'package:cardmap/screen/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwController = TextEditingController();

  late String id;
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
      Navigator.pop(context);
      //print(e);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        wrongEmailMessage();
        // setState(() {
        //   wrongId = true;
        // });
        //print('wrong email');
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
        // setState(() {
        //   wrongPw = true;
        // });
        //print('wrong password');
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('존재하지 않는 이메일 입니다.'),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('비밀번호가 틀렸습니다.'),
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
      backgroundColor: Colors.lightGreen,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 110),
            Center(
                child:
                    Image.asset('assets/images/CardmapLogo.png')), // 로고 이미지 추가
            const SizedBox(
              height: 90,
            ),
            Container(
              height: 492,
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
                                  bottom: BorderSide(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                            TextButton(
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
                          ],
                        ),
                        const SizedBox(
                          width: 42,
                        ),
                        TextButton(
                          // 회원가입 버튼
                          onPressed: () {
                            Get.to(SignUpPage());
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
                    const SizedBox(height: 60),
                    Padding(
                      // ID입력란
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      // PW 입력란
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      // Forgot Password 입력란
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 34),
                    Row(
                      // 시작하기
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
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
            
// class WrongInfo extends StatelessWidget {
//   const WrongInfo({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (LoginPageState.wrongId == true) {
//       return const Padding(
//         padding: EdgeInsets.all(15),
//         child: Text(
//           "Wrong Email!!",
//           style: TextStyle(
//             color: Colors.red,
//           ),
//         ),
//       );
//     } else if (LoginPageState.wrongPw == true) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
//         child: Text(
//           "Wrong Password!!",
//           style: TextStyle(
//             color: Colors.red,
//           ),
//         ),
//       );
//     } else {
//       return const SizedBox(
//         height: 50,
//       );
//     }
//   }
// }