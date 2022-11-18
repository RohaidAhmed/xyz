import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    child: Image.asset(
                      'assets/images/profileBG.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Booster.verticalSpace(30),
                    Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Booster.dynamicFontSize(
                                  label: "Profile",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Booster.verticalSpace(20),
                            Center(
                              child: Booster.localProfileAvatar(
                                  radius: 130,
                                  assetImage: 'assets/images/dp.png'),
                            ),
                            Booster.verticalSpace(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Booster.horizontalSpace(5),
                                Booster.dynamicFontSize(
                                    label: "Upload Photo",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ],
                            ),
                            Booster.verticalSpace(25),
                            Booster.dynamicFontSize(
                                label: "Patient Name",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            Booster.verticalSpace(5),
                            Booster.dynamicFontSize(
                                label: "Patient",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Booster.verticalSpace(50),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Icon(Icons.person,
                  ),
                  Booster.horizontalSpace(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          label: "NAME",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,),
                      Booster.verticalSpace(5),
                      Booster.dynamicFontSize(
                          label: "User Name",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,)
                    ],
                  ),
                ],
              ),
            ),
            Booster.verticalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.5,
              ),
            ),
            Booster.verticalSpace(10),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Icon(Icons.mail,
                  ),
                  Booster.horizontalSpace(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          label: "EMAIL",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      Booster.verticalSpace(5),
                      Booster.dynamicFontSize(
                          label: "abc123@gmail.com",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

