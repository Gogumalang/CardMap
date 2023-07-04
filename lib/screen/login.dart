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
  // static bool wrongId = false;
  // static bool wrongPw = false;

  late String id; // late를 붙여줘야 하는 이유 ?
  late String password;

  void validateAndSave() async {
    final form = formKey.currentState;
    // setState(() {
    //   wrongId = false;
    //   wrongPw = false;
    // });
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: idController.text,
        password: pwController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 222, 105),
        title: const Text('로그인 페이지'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                const SizedBox(height: 50),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordPage();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
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
