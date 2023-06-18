import 'package:get/get.dart';
import 'package:text_summary_edit/core/view_model/auth_view_model.dart';
import 'package:text_summary_edit/core/view_model/chatbot_view_model.dart';
import 'package:text_summary_edit/core/view_model/home_view_model.dart';
import 'package:text_summary_edit/core/view_model/profile_view_model.dart';
import 'package:text_summary_edit/core/view_model/settings_view_model.dart';
import 'package:text_summary_edit/core/view_model/web_view_model.dart';

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => SettingsViewModel());
    Get.lazyPut(() => ProfileViewModel());
    Get.lazyPut(() => WebViewModel());
    Get.lazyPut(() => ChatBotViewModel());
  }
}
