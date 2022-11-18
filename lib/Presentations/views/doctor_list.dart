import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/elements/doctors_tile.dart';
import 'package:patient_module/Presentations/elements/noData.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';
import 'package:patient_module/infrastructure/services/doctor_services.dart';
import 'package:provider/provider.dart';

class DoctorList extends StatefulWidget {
  final String categoryID;
  DoctorList({required this.categoryID});
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  DoctorServices _doctorServices = DoctorServices();
  String txt = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctors List'),
        backgroundColor: AppConfigurations.color,
      ),
      body: StreamProvider.value(
        value: _doctorServices.streamDoctors(widget.categoryID),
        initialData: [DoctorProfileModel()],
        builder: (context, child) {
          return context.watch<List<DoctorProfileModel>>().isNotEmpty
              ? context.watch<List<DoctorProfileModel>>()[0].docId == null
                  ? Center(
                      child: Container(
                          height: Booster.screenHeight(context) - 100,
                          width: Booster.screenWidth(context),
                          child: Center(
                            child: CircularProgressIndicator(),
                          )))
                  : ListView.builder(
                      itemCount:
                          context.watch<List<DoctorProfileModel>>().length,
                      itemBuilder: (context, i) {
                        return DoctorsTile(
                            doctorProfileModel:
                                context.watch<List<DoctorProfileModel>>()[i]);
                      })
              : NoData();
        },
      ),
    );
  }
}
