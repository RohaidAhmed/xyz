// To parse this JSON data, do
//
//     final patientProfileModel = patientProfileModelFromJson(jsonString);

import 'dart:convert';

PatientProfileModel patientProfileModelFromJson(String str) =>
    PatientProfileModel.fromJson(json.decode(str));

String patientProfileModelToJson(PatientProfileModel data) =>
    json.encode(data.toJson(data.patientDocId!));

class PatientProfileModel {
  PatientProfileModel({
    this.patientName,
    this.patientPic,
    this.patientEmail,
    this.patientAge,
    this.patientDocId,
  });

  String? patientName;
  String? patientPic;
  String? patientEmail;
  String? patientAge;
  String? patientDocId;

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) =>
      PatientProfileModel(
        patientName: json["patientName"],
        patientPic: json["patientPic"],
        patientEmail: json["patientEmail"],
        patientAge: json["patientAge"],
        patientDocId: json["patientDocID"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "patientName": patientName,
        "patientPic": patientPic,
        "patientEmail": patientEmail,
        "patientAge": patientAge,
        "patientDocID": docID,
      };
}
