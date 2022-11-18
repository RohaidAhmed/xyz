import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Configurations/backEdnConfigs.dart';
import 'package:patient_module/Presentations/elements/app_button.dart';
import 'package:patient_module/Presentations/elements/detail_text_field.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/elements/navigation_dialog.dart';
import 'package:patient_module/application/app_state.dart';
import 'package:patient_module/application/notificationHandler.dart';
import 'package:patient_module/infrastructure/models/appointment_model.dart';
import 'package:patient_module/infrastructure/models/patient_profile_model.dart';
import 'package:patient_module/infrastructure/services/appointment_services.dart';
import 'package:provider/provider.dart';

import 'appointment.dart';

class CreateAppointment extends StatefulWidget {
  final String doctorID;

  CreateAppointment(this.doctorID);

  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  AppointmentServices _appointmentServices = AppointmentServices();
  TextEditingController _appointmentName = TextEditingController();

  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);

  bool initialized = false;

  PatientProfileModel userModel = PatientProfileModel();
  DateTime selectedDate = DateTime.now();
  NotificationHandler _notificationHandler = NotificationHandler();
  TimeOfDay selectedTime = TimeOfDay.now();

  late String _setTime, _setDate;

  int _currentValue = 1;

  late String _hour, _minute, _time;

  late String dateTime;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackEndConfigs.userDetailsLocalStorage);

            if (items != null) {
              userModel = PatientProfileModel(
                patientName: items['patientName'],
                patientDocId: items['patientDocID'],
                patientEmail: items['patientEmail'],
                patientPic: items['patientPic'],
                patientAge: items['patientAge'],
              );
            }

            _nameController =
                TextEditingController(text: userModel.patientName);
            _ageController = TextEditingController(text: userModel.patientAge);
            _emailController =
                TextEditingController(text: userModel.patientEmail);
            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getUI(context, userModel);
        });
  }

  Widget _getUI(BuildContext context, PatientProfileModel _model) {
    var status = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Appointment'),
        backgroundColor: AppConfigurations.color,
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: status.getStateStatus() == StateStatus.IsBusy,
          progressIndicator: LoadingWidget(),
          child: SingleChildScrollView(
            child: Column(children: [
              Booster.verticalSpace(10),
              DetailTextField(
                  data: _nameController,
                  label: "Patient Name",
                  validator: (val) {}),
              DetailTextField(
                  data: _ageController,
                  label: "Patient Age",
                  validator: (val) {}),
              DetailTextField(
                  data: _emailController,
                  label: "Patient Email",
                  validator: (val) {}),
              DetailTextField(
                  data: _diseaseController,
                  label: "Disease",
                  validator: (val) {}),
              DetailTextField(
                  data: _appointmentName,
                  label: "Appointment Name",
                  validator: (val) {}),
              DetailTextField(
                  data: _descriptionController,
                  label: "Appointment Description",
                  maxLines: 4,
                  validator: (val) {}),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppConfigurations.color)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(DateFormat.jm().format(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute))),
                      ),
                      IconButton(
                        icon: Icon(Icons.timer),
                        onPressed: () {
                          _selectTime(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppConfigurations.color)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          DateFormat.yMd().format(selectedDate),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          _selectDate(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Booster.verticalSpace(17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AppButton(
                  text: "Create Appointment",
                  onTap: () {
                    _createAppointment(context, status);
                  },
                ),
              ),
              Booster.verticalSpace(37),
            ]),
          ),
        ),
      ),
    );
  }

  _createAppointment(BuildContext context, AppState status) async {
    await _appointmentServices
        .createAppointment(
      context,
      model: AppointmentModel(
          patientName: _nameController.text,
          patientAge: _ageController.text,
          patientEmail: _emailController.text,
          patientPic: userModel.patientPic,
          meetingPwd: "hhz6S8",
          isPending: true,
          isApproved: false,
          disease: _diseaseController.text,
          date: selectedDate.toString(),
          description: _descriptionController.text,
          time: DateFormat.jm().format(DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute)),
          meetingId: "82832790783",
          appointmentName: _appointmentName.text,
          patientID: userModel.patientDocId,
          doctorID: widget.doctorID),
    )
        .then((value) async {
      if (status.getStateStatus() == StateStatus.IsFree) {
        _notificationHandler.oneToOneNotificationHelper(
            docID: widget.doctorID,
            body: "You have new appointment to see.",
            title: "Appointment Update!");
        showNavigationDialog(context,
            message: "Appointment has been created successfully.",
            buttonText: "okay", navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Appointment()));
        }, secondButtonText: "", showSecondButton: false);
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        // _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        // _timeController.text = _time;
        // _timeController.text = date.formatDate(
        //     DateTime(2019, 08, 1, selectedTime!.hour, selectedTime!.minute),
        //     [hh, ':', nn, " ", am]).toString();
      });
  }
}
