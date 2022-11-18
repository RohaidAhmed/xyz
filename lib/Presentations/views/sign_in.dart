import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Configurations/enums.dart';
import 'package:patient_module/Presentations/elements/app_button.dart';
import 'package:patient_module/Presentations/elements/auth_text_field.dart';
import 'package:patient_module/Presentations/elements/dialog.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/views/appointment.dart';
import 'package:patient_module/Presentations/views/sign_up.dart';
import 'package:patient_module/application/auth_state.dart';
import 'package:patient_module/application/errorStrings.dart';
import 'package:patient_module/application/loginBusinessLogic.dart';
import 'package:patient_module/infrastructure/services/authServices.dart';
import 'package:provider/provider.dart';

import 'forgot_your_passward.dart';

class SignIn extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool isObscure = true;
  LoginBusinessLogic data = LoginBusinessLogic();
  final _formKey = GlobalKey<FormState>();
  var node;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthServices>(context);
    node = FocusScope.of(context);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: auth.status == Status.Authenticating,
        progressIndicator: LoadingWidget(),
        color: AppConfigurations.color,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                Booster.verticalSpace(100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Booster.dynamicFontSize(
                        label: "Login",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1E1A15),
                      )),
                ),
                Booster.verticalSpace(11),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                        label: "Using your email and password",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6B6E74),
                      )
                    ],
                  ),
                ),
                Booster.verticalSpace(36),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          label: "YOUR EMAIL",
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ],
                  ),
                ),
                Booster.verticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTextField(
                      controller: _emailController,
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty" : null,
                    ),
                  ),
                ),
                Booster.verticalSpace(36),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          label: "YOUR PASSWORD"),
                    ],
                  ),
                ),
                Booster.verticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTextField(
                      controller: _pwdController,
                      isPasswordField: true,
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty" : null,
                    ),
                  ),
                ),
                Booster.verticalSpace(47),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: AppButton(
                    text: "Login",
                    onTap: () {
                      print("Called");
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      loginUser(
                          context: context,
                          data: data,
                          email: _emailController.text,
                          auth: auth,
                          password: _pwdController.text);
                    },
                  ),
                ),
                Booster.verticalSpace(67),
                _gettext(text: "Forgot your passward?"),
                Booster.verticalSpace(12),
                _gettextrow(text: "Don't have an account?", text1: "SignUp"),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

loginUser(
    {required BuildContext context,
    required LoginBusinessLogic data,
    required String email,
    required AuthServices auth,
    required String password}) {
  data
      .loginUserLogic(
    context,
    email: email,
    password: password,
  )
      .then((val) async {
    if (auth.status == Status.Authenticated) {
      UserLoginStateHandler.saveUserLoggedInSharedPreference(true);
      Get.to(() => Appointment());
    } else {
      showErrorDialog(context,
          message: Provider.of<ErrorString>(context, listen: false)
              .getErrorString());
    }
  });
}

_gettext({
  required String text,
}) {
  return InkWell(
    onTap: () {
      Get.to(ForgotPassward(), transition: Transition.cupertino);
    },
    child: Booster.dynamicFontSize(
        label: text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black),
  );
}

_gettextrow({required String text, required String text1}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Booster.dynamicFontSize(
          label: text,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black),
      Booster.horizontalSpace(3),
      InkWell(
        onTap: () {
          Get.to(SignUp(), transition: Transition.cupertino);
        },
        child: Booster.dynamicFontSize(
            label: text1,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppConfigurations.color,
            isUnderline: true),
      ),
    ],
  );
}

getTextFieldLabel(String text) {
  return Text(
    text.toUpperCase(),
    style: TextStyle(
        color: Color(0xff3A3D46),
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 10),
  );
}
