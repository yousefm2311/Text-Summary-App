// ignore_for_file: non_constant_identifier_names

class ChatBotModel {
  OpenAiModel? openai;

  ChatBotModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return;
    }
    openai =
        json['openai'] != null ? OpenAiModel.fromJson(json['openai']) : null;
  }
}

class OpenAiModel {
  String? status;
  String? generated_text;

  OpenAiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    generated_text = json['generated_text'];
  }
}
