import 'package:flutter/material.dart';
import 'package:patient_module/Presentations/views/appointment.dart';
import 'package:patient_module/Presentations/views/sign_in.dart';
import 'package:patient_module/application/auth_state.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;

  Future<bool?> getUserLoginState() async {
    return await UserLoginStateHandler.getUserLoggedInSharedPreference();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserLoginState().then((value) {
      if (value == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = value;
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Appointment() : SignIn();
  }
}
