import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0.8),
            // child: Column(
            //     // children: const [
            //     //   FormHeaderWidget(
            //     //     image: tWelcomeScreenImage,
            //     //     title: tSignUpTitle,
            //     //     subTitle: tSignUpSubTitle,
            //     //     imageHeight: 0.15,
            //     //   ),
            //     //   SignUpFormWidget(),
            //     //   SignUpFooterWidget(),
            //     // ],
            //     ),
          ),
        ),
      ),
    );
  }
}
