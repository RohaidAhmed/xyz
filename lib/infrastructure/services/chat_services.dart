import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_module/infrastructure/models/chatDetailsModel.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';
import 'package:patient_module/infrastructure/models/messagModel.dart';

class ChatServices {
  ///Get Recent Chats
  Stream<List<ChatDetailsModel>> streamChatList({required String myID}) {
    print(myID);
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(myID)
        .collection('recent_chats')
        .orderBy('sortTime', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ChatDetailsModel.fromJson(e.data()))
            .toList());
  }

  ///Get Messages
  Stream<List<MessagesModel>> streamMessages(
      {required String myID, required String senderID}) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(myID)
        .collection('recent_chats')
        .doc(senderID)
        .collection('messages')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessagesModel.fromJson(e.data())).toList());
  }

  ///Start New Chat
  Future<void> addNewMessage(
      {required String myID,
      required String receiverID,
      required ChatDetailsModel detailsModel,
      required MessagesModel messageModel}) async {
    return await FirebaseFirestore.instance
        .collection("messages")
        .doc(myID)
        .collection('recent_chats')
        .doc(receiverID)
        .set(detailsModel.toJson(myID: myID, otherID: receiverID))
        .then((value) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("messages")
          .doc(myID)
          .collection('recent_chats')
          .doc(receiverID)
          .collection("messages")
          .doc(DateTime.now().toString());
      return docRef.set(messageModel.toJson(
          otherID: receiverID, fromID: myID, docID: docRef.id));
    }).then((value) => FirebaseFirestore.instance
                .collection("messages")
                .doc(receiverID)
                .collection('recent_chats')
                .doc(myID)
                .set(detailsModel.toJson(myID: receiverID, otherID: myID))
                .then((value) {
              DocumentReference docRef = FirebaseFirestore.instance
                  .collection("messages")
                  .doc(receiverID)
                  .collection('recent_chats')
                  .doc(myID)
                  .collection("messages")
                  .doc(DateTime.now().toString());
              return docRef.set(messageModel.toJson(
                  fromID: myID, otherID: receiverID, docID: docRef.id));
            }));
  }

  ///Get Unread Message Counter
  Stream<List<MessagesModel>> getUnreadMessageCounter(
      {required String myID, required String receiverID}) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(myID)
        .collection('recent_chats')
        .doc(receiverID)
        .collection('messages')
        .where('fromID', isEqualTo: receiverID)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessagesModel.fromJson(e.data())).toList());
  }

  ///Mark Messages as Read
  Future<void> markMessageAsRead(
      {required String myID,
      required String receiverID,
      required String messageID}) async {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(myID)
        .collection('recent_chats')
        .doc(receiverID)
        .collection('messages')
        .doc(messageID)
        .update({'isRead': true});
  }

  Stream<DoctorProfileModel> streamDoctorData(String docID) {
    print("FROM DOC ID : $docID");
    FirebaseFirestore.instance
        .collection('patientsData')
        .doc(docID)
        .snapshots()
        .map((event) => print(event.data()))
        .toList();
    return FirebaseFirestore.instance
        .collection('doctorsData')
        .doc(docID)
        .snapshots()
        .map((snap) => DoctorProfileModel.fromJson(snap.data()!));
  }
}
