class ChatDetailsModel {
  String? recentMessage;
  String? myID;
  String? otherID;
  String? time;
  String? date;
  int? sortTime;

  ChatDetailsModel({
    this.recentMessage,
    this.myID,
    this.otherID,
    this.time,
    this.sortTime,
    this.date,
  });

  ChatDetailsModel.fromJson(Map<String, dynamic> json) {
    myID = json['myID'];
    otherID = json['otherID'];
    time = json['time'];
    recentMessage = json['recentMessage'];
    date = json['date'];
    sortTime = json['sortTime'];
  }

  Map<String, dynamic> toJson({required String myID, required String otherID}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myID'] = myID;
    data['otherID'] = otherID;
    data['time'] = this.time;
    data['date'] = this.date;
    data['recentMessage'] = this.recentMessage;
    data['sortTime'] = DateTime.now().microsecondsSinceEpoch;
    return data;
  }
}
