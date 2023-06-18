class SummaryModel {
  OpenAi? openai;

  SummaryModel.fromJson(Map<dynamic, dynamic> json) {
    if (json.isEmpty) {
      return;
    }
    openai = json['openai'] != null ? OpenAi.fromJson(json['openai']) : null;
  }
}

class OpenAi {
  String? result, status;

  OpenAi.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    status = json['status'];
  }
}
