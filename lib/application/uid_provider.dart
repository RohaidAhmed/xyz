import 'package:flutter/cupertino.dart';

class UserID extends ChangeNotifier {
  String _uid = "";

  void saveUserID(String uid) {
    _uid = uid;
    notifyListeners();
  }

  String getUserID() => _uid;
}
