class MessagesModel {
  String? docID;
  String? toID;
  String? fromID;
  var sortTime;
  var time;
  String? messageBody;
  bool? isRead;

  MessagesModel(
      {this.toID,
      this.fromID,
      this.isRead,
      this.docID,
      this.time,
      this.sortTime,
      this.messageBody});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    toID = json['toID'];
    fromID = json['fromID'];
    docID = json['docID'];
    isRead = json['isRead'];
    sortTime = json['sortTime'];
    time = json['time'];
    messageBody = json['messageBody'];
  }

  Map<String, dynamic> toJson(
      {required String fromID,
      required String otherID,
      required String docID}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toID'] = otherID;
    data['fromID'] = fromID;
    data['sortTime'] = DateTime.now().microsecondsSinceEpoch;
    data['isRead'] = this.isRead;
    data['time'] = this.time;
    data['docID'] = docID;
    data['messageBody'] = this.messageBody;
    return data;
  }
}
