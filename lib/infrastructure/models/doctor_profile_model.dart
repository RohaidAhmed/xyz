// To parse this JSON data, do
//
//     final doctorProfileModel = doctorProfileModelFromJson(jsonString);

import 'dart:convert';

DoctorProfileModel doctorProfileModelFromJson(String str) =>
    DoctorProfileModel.fromJson(json.decode(str));

String doctorProfileModelToJson(DoctorProfileModel data) =>
    json.encode(data.toJson(data.docId!));

class DoctorProfileModel {
  DoctorProfileModel({
    this.name,
    this.email,
    this.categoryId,
    this.categoryName,
    this.profilePic,
    this.qualification,
    this.location,
    this.docId,
  });

  String? name;
  String? email;
  String? categoryId;
  String? categoryName;
  String? profilePic;
  String? qualification;
  String? location;
  String? docId;

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      DoctorProfileModel(
        name: json["name"],
        email: json["email"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        profilePic: json["profile_pic"],
        qualification: json["qualification"],
        location: json["location"],
        docId: json["docID"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "name": name,
        "email": email,
        "category_id": categoryId,
        "category_name": categoryName,
        "profile_pic": profilePic,
        "qualification": qualification,
        "location": location,
        "docID": docID,
      };
}
