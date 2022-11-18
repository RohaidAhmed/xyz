import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_module/application/app_state.dart';
import 'package:patient_module/infrastructure/models/appointment_model.dart';
import 'package:provider/provider.dart';

class AppointmentServices {
  CollectionReference<Map<String, dynamic>> appointmentCollection =
      FirebaseFirestore.instance.collection('doctorAppointments');

  ///Create Appointment
  Future<void> createAppointment(BuildContext context,
      {required AppointmentModel model}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('doctorAppointments').doc();
    await docRef.set(model.toJson(docRef.id));
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }

  ///Get Appointment
  Stream<List<AppointmentModel>> streamMyAppointments(String uid) {
    return appointmentCollection
        .where('patientID', isEqualTo: uid)
        .snapshots()
        .map((event) => event.docs
            .map((e) => AppointmentModel.fromJson(e.data()))
            .toList());
  }

  ///Delete Appointment
  Future<void> deleteAppointment(BuildContext context, String docID) async {
    print(docID);
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);
    await appointmentCollection.doc(docID).delete();
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }
}
