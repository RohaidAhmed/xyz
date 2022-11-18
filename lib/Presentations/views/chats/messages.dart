import 'dart:async';

import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/elements/loading_widget.dart';
import 'package:patient_module/Presentations/elements/noData.dart';
import 'package:patient_module/application/notificationHandler.dart';
import 'package:patient_module/infrastructure/models/chatDetailsModel.dart';
import 'package:patient_module/infrastructure/models/messagModel.dart';
import 'package:patient_module/infrastructure/services/chat_services.dart';
import 'package:provider/provider.dart';

class MessagesView extends StatefulWidget {
  final String myID;
  final String receiverID;

  MessagesView({required this.receiverID, required this.myID});

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  ChatServices _chatServices = ChatServices();

  TextEditingController messageController = TextEditingController();

  ScrollController _scrollController = new ScrollController();
  int listLength = 0;
  bool callSetLength = true;
  NotificationHandler _notificationHandler = NotificationHandler();

  void setLength(int i) {
    listLength = i;
    callSetLength = false;
    setState(() {});
  }

  int get getLength => listLength;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppConfigurations.color,
        title: Text("Messages"),
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    setUserID(
      widget.myID,
    );
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamProvider.value(
                initialData: [MessagesModel()],
                value: _chatServices.streamMessages(
                    myID: widget.myID, senderID: widget.receiverID),
                builder: (context, child) {
                  Timer(
                      Duration(milliseconds: 300),
                      () => _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.ease));
                  return context.watch<List<MessagesModel>>().isNotEmpty
                      ? context.watch<List<MessagesModel>>()[0].docID == null
                          ? LoadingWidget()
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  context.watch<List<MessagesModel>>().length,
                              itemBuilder: (context, i) {
                                // if (callSetLength)
                                setList(context.watch<List<MessagesModel>>());
                                return MessageTile(
                                  message: context
                                      .watch<List<MessagesModel>>()[i]
                                      .messageBody
                                      .toString(),
                                  sendByMe: context
                                          .watch<List<MessagesModel>>()[i]
                                          .fromID ==
                                      widget.myID,
                                  time: context
                                      .watch<List<MessagesModel>>()[i]
                                      .time,
                                );
                              })
                      : NoData();
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            color: AppConfigurations.color.withOpacity(0.3),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    controller: messageController,
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "Type Here...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  )),
                  SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: () {
                      if (messageController.text.isEmpty) {
                        return;
                      }
                      String message = messageController.text;
                      setState(() {});
                      Future.delayed(Duration(microseconds: 20), () {
                        messageController.clear();
                      });
                      Timer(
                          Duration(milliseconds: 300),
                          () => _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 700),
                              curve: Curves.ease));
                      _notificationHandler.oneToOneNotificationHelper(
                          docID: widget.receiverID,
                          body: messageController.text,
                          title: "New Message!");
                      _chatServices
                          .addNewMessage(
                              receiverID: widget.receiverID,
                              myID: widget.myID,
                              detailsModel: ChatDetailsModel(
                                recentMessage: messageController.text,
                                date: DateFormat('MM/dd/yyyy')
                                    .format(DateTime.now()),
                                time: DateFormat('hh:mm a')
                                    .format(DateTime.now()),
                              ),
                              messageModel: MessagesModel(
                                  isRead: false,
                                  time: DateFormat('MM/dd/yyyy hh:mm a')
                                      .format(DateTime.now()),
                                  messageBody: messageController.text))
                          .then((value) async {
                        messageController.clear();
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: messageController.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  markMessageAsRead({List<MessagesModel>? list, String? uid}) {
    list!
        .map((e) => _chatServices.markMessageAsRead(
            myID: uid!, receiverID: widget.receiverID, messageID: e.docID!))
        .toList();
  }

  List<MessagesModel>? list;
  String? userID;

  void setList(List<MessagesModel> _list) {
    list = _list;
  }

  List<MessagesModel>? get getList => list;

  void setUserID(String _userID) {
    userID = _userID;
  }

  String get getUserID => userID!;

  @override
  void dispose() {
    // var user = Provider.of<User>(context, listen: false);
    // TODO: implement dispose
    markMessageAsRead(uid: getUserID, list: getList!);
    super.dispose();
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final time;
  final date;

  MessageTile(
      {required this.message, required this.sendByMe, this.time, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: 2,
              bottom: 1,
              left: sendByMe ? 0 : 14,
              right: sendByMe ? 14 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: 0.6 * MediaQuery.of(context).size.width),
            margin: sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
            decoration: BoxDecoration(
              color: sendByMe
                  ? AppConfigurations.color.withOpacity(0.6)
                  : AppConfigurations.color,
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        height: 1.3,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300)),
                Booster.verticalSpace(5),
                Text(
                  time,
                  style: TextStyle(fontSize: 9, color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
