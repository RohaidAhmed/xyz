import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:patient_module/Configurations/enums.dart';
import 'package:patient_module/Presentations/elements/app_button.dart';
import 'package:patient_module/Presentations/elements/auth_text_field.dart';
import 'package:patient_module/Presentations/elements/dialog.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/elements/navigation_dialog.dart';
import 'package:patient_module/Presentations/views/sign_in.dart';
import 'package:patient_module/application/errorStrings.dart';
import 'package:patient_module/infrastructure/services/authServices.dart';
import 'package:provider/provider.dart';

class ForgotPassward extends StatelessWidget {
  AuthServices _authServices = AuthServices.instance();
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  var node;
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthServices _services = Provider.of<AuthServices>(context);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _services.status == Status.Authenticating,
        progressIndicator: LoadingWidget(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Booster.verticalSpace(100),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Booster.dynamicFontSize(
                      label: "Forgot your password?",
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1E1A15),
                      isAlignCenter: false),
                ),
              ),
              Booster.verticalSpace(15),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Booster.dynamicFontSize(
                    label:
                        "Give your email address you used during registration",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6B6E74),
                    isAlignCenter: false),
              ),
              Booster.verticalSpace(56),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: getTextFieldLabel("YOUR EMAIL"),
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
                        val.isEmpty ? "Email Cannot be empty." : null,
                  ),
                ),
              ),
              Booster.verticalSpace(36),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: InkWell(
                    onTap: () {
                      Get.to(SignIn(), transition: Transition.cupertino);
                    },
                    child: AppButton(
                      text: "Recover",
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _forgotPassword(context);
                      },
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  _forgotPassword(BuildContext context) {
    AuthServices _services = Provider.of<AuthServices>(context, listen: false);
    _services
        .forgotPassword(context, email: _emailController.text)
        .then((val) async {
      if (_services.status == Status.Authenticated) {
        showNavigationDialog(context,
            message:
                "An email with password reset link has been sent to your email inbox",
            buttonText: "Okay", navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        }, secondButtonText: "", showSecondButton: false);
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}

getTextFieldLabel(String text) {
  return Text(
    text.toUpperCase(),
    style: TextStyle(
        color: Color(0xff1E1A15),
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 10),
  );
}
