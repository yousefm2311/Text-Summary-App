class HistoryModel {
  String? text;
  String? time;
  // String? uId;

  HistoryModel({
    this.text,
    this.time,
  });
  HistoryModel.fromJson(Map<dynamic, dynamic> json) {
    if (json.isEmpty) {
      return;
    }
    text = json["text"];
    time = json["time"];
    // uId = json["uId"];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time,
      // 'uId': uId
    };
  }
}
