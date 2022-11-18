import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/views/appointment_details.dart';
import 'package:patient_module/infrastructure/models/appointment_model.dart';

class AppointmentTile extends StatelessWidget {
  final AppointmentModel appointmentModel;

  const AppointmentTile({Key? key, required this.appointmentModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
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
              title: Text(appointmentModel.appointmentName.toString(),
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
                          appointmentModel.isPending!
                              ? "Pending"
                              : appointmentModel.isApproved!
                                  ? "Accepted"
                                  : "Rejected",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      )),
                  Booster.verticalSpace(6),
                  Text(
                    DateFormat.yMEd().format(
                            DateTime.parse(appointmentModel.date.toString())) +
                        " - " +
                        appointmentModel.time.toString(),
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
                    AppointmentDetail(appointmentModel: appointmentModel));
              },
            ),
          ),
        ),
      ),
    );
  }
}
