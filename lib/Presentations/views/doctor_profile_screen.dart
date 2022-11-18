import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_module/Presentations/elements/app_button.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/views/create%20_appointment.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorProfileModel profileModel;

  DoctorProfileScreen({required this.profileModel});

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
                  height: MediaQuery.of(context).size.height * 0.4,
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
                                  label: "Doctor Profile",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Booster.verticalSpace(20),
                            Center(
                              child: Container(
                                height: 115,
                                width: 115,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        profileModel.profilePic.toString(),
                                    placeholder: (context, url) =>
                                        LoadingWidget(),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: Colors.white)),
                              ),
                            ),
                            Booster.verticalSpace(25),
                            Booster.dynamicFontSize(
                                label: profileModel.name.toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            Booster.verticalSpace(8),
                            Booster.dynamicFontSize(
                                label: profileModel.categoryName.toString(),
                                fontSize: 12,
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
                  Icon(
                    Icons.mail,
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
                          label: profileModel.email.toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
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
                  Image.asset(
                    'assets/images/degree_icon.jpg',
                    height: 25,
                    width: 25,
                  ),
                  Booster.horizontalSpace(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          label: "Qualification",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      Booster.verticalSpace(5),
                      Booster.dynamicFontSize(
                          label: profileModel.qualification.toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
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
                  Icon(
                    Icons.location_on,
                  ),
                  Booster.horizontalSpace(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Booster.dynamicFontSize(
                          label: "Location",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      Booster.verticalSpace(5),
                      Booster.dynamicFontSize(
                          label: profileModel.location.toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
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
            Booster.verticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: AppButton(
                  onTap: () {
                    Get.to(
                        () => CreateAppointment(profileModel.docId.toString()));
                  },
                  text: "Book Appointment with Doctor"),
            )
          ]),
        ),
      ),
    );
  }
}
