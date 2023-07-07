import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSelection extends StatefulWidget {
  const CardSelection({super.key});

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "카드 선택",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 100,
                      width: 200,
                      color: Colors.black,
                    )
                  ],
                )
              ],
            ),
          )
        ],
        // mainAxisSize: MainAxisSize.max,
        // children: <Widget>[
        //   Row(
        //     children: [
        //       Container(
        //         width: 100,
        //         height: double.infinity,
        //         color: Colors.red,
        //       ),
        //       Container(
        //         width: 100,
        //         height: 300,
        //         color: Colors.orange,
        //       ),
        //       Container(
        //         width: 100,
        //         height: 300,
        //         color: Colors.yellow,
        //       ),
        //     ],
        //   )
        // ],
      ),
    );
  }
}
