import 'package:flutter/material.dart';

class CardSelection extends StatefulWidget {
  const CardSelection({super.key});

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: SizedBox(
            height: 800,
            child: Column(
              children: [Row()],
            )),
      ),
    );
  }
}
