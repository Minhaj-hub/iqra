import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  bool openVersePlayer = false;
  bool openSurahPlayer = false;

  void manageVersePlayer(value) {
    openVersePlayer = value;
    notifyListeners();
  }

  void manageSurahPlayer(value) {
    openSurahPlayer = value;
    notifyListeners();
  }
}
