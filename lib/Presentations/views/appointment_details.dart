import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/elements/flushBar.dart';
import 'package:patient_module/Presentations/elements/meeting_widget.dart';
import 'package:patient_module/Presentations/elements/navigation_dialog.dart';
import 'package:patient_module/Presentations/views/chats/messages.dart';
import 'package:patient_module/application/app_state.dart';
import 'package:patient_module/infrastructure/models/appointment_model.dart';
import 'package:patient_module/infrastructure/services/appointment_services.dart';
import 'package:provider/provider.dart';

import 'appointment.dart';

class AppointmentDetail extends StatelessWidget {
  final AppointmentModel appointmentModel;

  AppointmentDetail({required this.appointmentModel});

  AppointmentServices _appointmentServices = AppointmentServices();

  @override
  Widget build(BuildContext context) {
    var status = Provider.of<AppState>(context);
    return LoadingOverlay(
      isLoading: status.getStateStatus() == StateStatus.IsBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Appointment Details'),
          backgroundColor: AppConfigurations.color,
          actions: [
            if (appointmentModel.isApproved!)
              IconButton(
                  onPressed: () {
                    Get.to(() => MessagesView(
                        receiverID: appointmentModel.doctorID.toString(),
                        myID: appointmentModel.patientID.toString()));
                  },
                  icon: Icon(
                    Icons.chat,
                    size: 19,
                  )),
            if (appointmentModel.isApproved!)
              IconButton(
                  onPressed: () {
                    if (DateTime.now()
                        .isBefore(DateTime.parse(appointmentModel.date!))) {
                      getFlushBar(context,
                          title: "You cannot start meeting before time.",
                          icon: Icons.info_outline,
                          color: Colors.blue);
                      return;
                    }

                    joinMeeting(context,
                        meetingID: appointmentModel.meetingId.toString(),
                        meetingPassword: appointmentModel.meetingPwd.toString(),
                        name: appointmentModel.patientName.toString());
                  },
                  icon: Icon(
                    Icons.video_call,
                    size: 19,
                  )),
          ],
        ),
        body: Column(
          children: [
            Booster.verticalSpace(30),
            _getContainer(
                text: 'Patient Name',
                text1: appointmentModel.patientName.toString()),
            Booster.verticalSpace(10),
            _getContainer(
                text: 'Appointment Date | Time',
                text1: DateFormat.yMEd().format(
                        DateTime.parse(appointmentModel.date.toString())) +
                    " | " +
                    appointmentModel.time.toString()),
            Booster.verticalSpace(10),
            _getContainer(
                text: 'Disease', text1: appointmentModel.disease.toString()),
            Booster.verticalSpace(10),
            _getContainer(
                text: 'Appointment Description',
                text1: appointmentModel.description.toString()),
            Booster.verticalSpace(10),
            _getContainer(
              text: 'Appointment Status',
              text1: appointmentModel.isPending!
                  ? "Pending"
                  : appointmentModel.isApproved!
                      ? "Accepted"
                      : "Rejected",
            ),
            Booster.verticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: InkWell(
                onTap: () async {
                  showNavigationDialog(context,
                      message: "Do you really want to delete this meeting?",
                      buttonText: "Yes", navigation: () async {
                    Navigator.pop(context);
                    await _appointmentServices.deleteAppointment(
                        context, appointmentModel.docID.toString());
                    if (status.getStateStatus() == StateStatus.IsFree) {
                      Get.to(() => Appointment());
                    }
                  }, secondButtonText: "No", showSecondButton: true);
                },
                child: Container(
                  width: Booster.screenWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[600],
                  ),
                  child: Booster.paddedWidget(
                      top: 17,
                      bottom: 15,
                      child: Booster.dynamicFontSize(
                          label: "Delete Appointment",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

joinMeeting(BuildContext context,
    {required String meetingID,
    required String meetingPassword,
    required String name}) async {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return MeetingWidget(
            name: name, meetingId: meetingID, meetingPassword: meetingPassword);
      },
    ),
  );
}

_getContainer({
  required String text,
  required String text1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Booster.dynamicFontSize(
            label: text,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      Booster.verticalSpace(8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Booster.dynamicFontSize(
            label: text1,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            isAlignCenter: false,
            lineHeight: 1.4),
      ),
      Booster.verticalSpace(8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Divider(),
          ],
        ),
      )
    ],
  );
}
