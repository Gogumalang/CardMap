import 'package:flutter/material.dart';

class SelectedCard with ChangeNotifier {
  List theFinalSelectedCard;

  SelectedCard({required this.theFinalSelectedCard});

  void updateCardList(List finalSelectedCard) {
    theFinalSelectedCard = finalSelectedCard;
    notifyListeners();
  }
}
