// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'dart:convert';

AppointmentModel appointmentModelFromJson(String str) =>
    AppointmentModel.fromJson(json.decode(str));

String appointmentModelToJson(AppointmentModel data) =>
    json.encode(data.toJson(data.docID!));

class AppointmentModel {
  AppointmentModel({
    this.patientName,
    this.patientAge,
    this.description,
    this.doctorID,
    this.time,
    this.date,
    this.docID,
    this.meetingId,
    this.meetingPwd,
    this.appointmentName,
    this.isApproved,
    this.disease,
    this.patientPic,
    this.patientEmail,
    this.isPending,
    this.patientID,
  });

  String? patientName;
  String? patientAge;
  String? description;
  String? time;
  String? date;
  String? meetingId;
  String? meetingPwd;
  String? appointmentName;
  String? doctorID;
  String? docID;
  String? patientPic;
  String? disease;
  String? patientEmail;
  String? patientID;
  bool? isApproved;
  bool? isPending;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        patientName: json["patientName"],
        patientAge: json["patientAge"],
        description: json["description"],
        time: json["time"],
        doctorID: json["doctorID"],
        date: json["date"],
        meetingId: json["meetingID"],
        meetingPwd: json["meetingPwd"],
        appointmentName: json["appointmentName"],
        isApproved: json["isApproved"],
        docID: json["docID"],
        disease: json["disease"],
        patientPic: json["patientPic"],
        patientEmail: json["patientEmail"],
        isPending: json["isPending"],
        patientID: json["patientID"],
      );

  Map<String, dynamic> toJson(String docID) => {
    "patientName": patientName,
    "patientAge": patientAge,
    "description": description,
    "time": time,
    "date": date,
    "meetingID": meetingId,
    "meetingPwd": meetingPwd,
    "appointmentName": appointmentName,
    "doctorID": doctorID,
    "isApproved": isApproved,
    "docID": docID,
    "disease": disease,
    "patientPic": patientPic,
    "patientEmail": patientEmail,
    "isPending": isPending,
    "patientID": patientID,
  };
}
