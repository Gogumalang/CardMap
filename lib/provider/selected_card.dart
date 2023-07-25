import 'package:flutter/material.dart';

class SelectedCard with ChangeNotifier {
  List _finalSelectedCard = List.empty(growable: true);
  List get finalSelectedCard => _finalSelectedCard;

  void updateCardList(List finalSelectedCard) {
    _finalSelectedCard = finalSelectedCard;
    notifyListeners();
  }
}
