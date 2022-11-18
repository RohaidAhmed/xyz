import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Configurations/backEdnConfigs.dart';
import 'package:patient_module/Presentations/elements/appDrawer.dart';
import 'package:patient_module/Presentations/elements/appointment_tile.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/elements/navigation_dialog.dart';
import 'package:patient_module/Presentations/elements/noData.dart';
import 'package:patient_module/application/uid_provider.dart';
import 'package:patient_module/infrastructure/models/appointment_model.dart';
import 'package:patient_module/infrastructure/models/patient_profile_model.dart';
import 'package:patient_module/infrastructure/services/appointment_services.dart';
import 'package:provider/provider.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  AppointmentServices _appointmentServices = AppointmentServices();
  String txt = '';
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);

  bool initialized = false;

  PatientProfileModel userModel = PatientProfileModel();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future _getData() async {
    await storage.ready;
    return await storage.getItem(BackEndConfigs.userDetailsLocalStorage);
  }

  bool isDataLoaded = false;
  Future<void> _initFcm() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    _firebaseMessaging.getToken().then((token) {
      FirebaseFirestore.instance.collection('deviceTokens').doc(uid).set(
        {
          'deviceTokens': token,
        },
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _initFcm();
    _getData().then((value) {
      print("value: $value");
      isDataLoaded = true;

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showNavigationDialog(context,
            message: "Do you really want to exit?",
            buttonText: "Yes", navigation: () {
          exit(0);
        }, secondButtonText: "No", showSecondButton: true);
      },
      child: Scaffold(
        body: !isDataLoaded
            ? LoadingWidget()
            : FutureBuilder(
                future: storage.ready,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!initialized) {
                    _getData();
                    var items =
                        storage.getItem(BackEndConfigs.userDetailsLocalStorage);

                    if (items != null) {
                      userModel = PatientProfileModel(
                        patientName: items['patientName'],
                        patientDocId: items['patientDocID'],
                        patientEmail: items['patientEmail'],
                      );
                    }

                    initialized = true;
                  }
                  return snapshot.data == null
                      ? CircularProgressIndicator()
                      : _buildUI(context, userModel);
                }),
      ),
    );
  }

  Widget _buildUI(BuildContext context, PatientProfileModel _userModel) {
    var userID = Provider.of<UserID>(context);
    print(_userModel.patientDocId);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            centerTitle: true,
            title: Text('Appointments'),
            backgroundColor: AppConfigurations.color),
        body: StreamProvider.value(
          value: _appointmentServices.streamMyAppointments(userID.getUserID()),
          initialData: [AppointmentModel()],
          builder: (context, child) {
            return context.watch<List<AppointmentModel>>().isNotEmpty
                ? context.watch<List<AppointmentModel>>()[0].docID == null
                    ? LoadingWidget()
                    : ListView.builder(
                        itemCount:
                            context.watch<List<AppointmentModel>>().length,
                        itemBuilder: (context, i) {
                          return AppointmentTile(
                              appointmentModel:
                                  context.watch<List<AppointmentModel>>()[i]);
                        })
                : NoData();
          },
        ));
  }
}
