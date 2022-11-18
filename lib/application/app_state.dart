import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum StateStatus { IsBusy, IsFree, IsError }
enum AppTheme { Dark, Light }

class AppState with ChangeNotifier {
  StateStatus _status = StateStatus.IsFree;
  AppTheme _appTheme = AppTheme.Light;

  void stateStatus(StateStatus status) {
    _status = status;
    notifyListeners();
  }

  getStateStatus() => _status;

  ///Will Deal with App Theme
  void appTheme(AppTheme theme) {
    _appTheme = theme;
    notifyListeners();
  }

  getAppTheme() => _appTheme;
}
