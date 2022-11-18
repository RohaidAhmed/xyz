import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Configurations/backEdnConfigs.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/elements/messageTile.dart';
import 'package:patient_module/Presentations/elements/noData.dart';
import 'package:patient_module/Presentations/views/appointment.dart';
import 'package:patient_module/Presentations/views/chats/messages.dart';
import 'package:patient_module/infrastructure/models/chatDetailsModel.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';
import 'package:patient_module/infrastructure/models/messagModel.dart';
import 'package:patient_module/infrastructure/models/patient_profile_model.dart';
import 'package:patient_module/infrastructure/services/chat_services.dart';
import 'package:provider/provider.dart';

class RecentChatList extends StatefulWidget {
  @override
  _RecentChatListState createState() => _RecentChatListState();
}

class _RecentChatListState extends State<RecentChatList> {
  ChatServices _chatServices = ChatServices();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  bool initialized = false;
  PatientProfileModel userModel = PatientProfileModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!initialized) {
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
    );
  }

  Widget _buildUI(BuildContext context, PatientProfileModel _userModel) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Appointment()));
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppConfigurations.color,
          title: Text("Recent Chats"),
        ),
        body: _getUI(context, _userModel),
      ),
    );
  }

  Widget _getUI(BuildContext context, PatientProfileModel _model) {
    return Column(
      children: [
        Booster.verticalSpace(5),
        Expanded(
          child: StreamProvider.value(
            initialData: [ChatDetailsModel()],
            value: _chatServices.streamChatList(myID: _model.patientDocId!),
            builder: (context, child) {
              return context.watch<List<ChatDetailsModel>>().isNotEmpty
                  ? context.watch<List<ChatDetailsModel>>()[0].myID == null
                      ? LoadingWidget()
                      : context.watch<List<ChatDetailsModel>>().length != 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: context
                                  .watch<List<ChatDetailsModel>>()
                                  .length,
                              itemBuilder: (context, i) {
                                return StreamProvider.value(
                                  initialData: [MessagesModel()],
                                  value: _chatServices.getUnreadMessageCounter(
                                      myID: userModel.patientDocId.toString(),
                                      receiverID: context
                                          .watch<List<ChatDetailsModel>>()[i]
                                          .otherID!),
                                  builder: (unReadContext, child) {
                                    return unReadContext
                                                .watch<List<MessagesModel>>() ==
                                            null
                                        ? LoadingWidget()
                                        : StreamProvider.value(
                                            initialData: DoctorProfileModel(),
                                            value: _chatServices
                                                .streamDoctorData(context
                                                    .watch<
                                                        List<
                                                            ChatDetailsModel>>()[
                                                        i]
                                                    .otherID!),
                                            builder: (userContext, child) {
                                              return userContext.watch<
                                                          DoctorProfileModel>() ==
                                                      null
                                                  ? LoadingWidget()
                                                  : InkWell(
                                                      onTap: () {
                                                        ChatDetailsModel
                                                            _model =
                                                            context.read<
                                                                List<
                                                                    ChatDetailsModel>>()[i];
                                                        setState(() {});
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MessagesView(
                                                                          receiverID:
                                                                              _model.otherID!,
                                                                          myID:
                                                                              userModel.patientDocId!,
                                                                        )));
                                                      },
                                                      child: RecentChatTile(
                                                        image: userContext
                                                            .watch<
                                                                DoctorProfileModel>()
                                                            .profilePic
                                                            .toString(),
                                                        title: userContext
                                                            .watch<
                                                                DoctorProfileModel>()
                                                            .name
                                                            .toString(),
                                                        description: context
                                                                .watch<
                                                                    List<
                                                                        ChatDetailsModel>>()[
                                                                    i]
                                                                .recentMessage ??
                                                            "",
                                                        time: context
                                                            .watch<
                                                                List<
                                                                    ChatDetailsModel>>()[
                                                                i]
                                                            .time
                                                            .toString(),
                                                        counter: unReadContext
                                                            .watch<
                                                                List<
                                                                    MessagesModel>>()
                                                            .length,
                                                      ),
                                                    );
                                            },
                                          );
                                  },
                                );
                              })
                          : NoData()
                  : NoData();
            },
          ),
        )
      ],
    );
  }
}
