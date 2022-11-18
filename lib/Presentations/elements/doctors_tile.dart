import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/views/doctor_profile_screen.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';

class DoctorsTile extends StatelessWidget {
  final DoctorProfileModel doctorProfileModel;
  DoctorsTile({required this.doctorProfileModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                child: ListTile(
                  leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppConfigurations.color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      )),
                  title: Text(doctorProfileModel.name.toString(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Booster.verticalSpace(3),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              doctorProfileModel.qualification.toString(),
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white),
                            ),
                          )),
                      Booster.verticalSpace(6),
                      Text(
                        doctorProfileModel.location.toString(),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: AppConfigurations.color,
                  ),
                  selected: true,
                  onTap: () {
                    Get.to(() =>
                        DoctorProfileScreen(profileModel: doctorProfileModel));
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
