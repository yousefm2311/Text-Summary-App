import 'package:get/get.dart';
import 'package:text_summary_edit/core/middleware/middleware.dart';
import 'package:text_summary_edit/util/binding.dart';
import 'package:text_summary_edit/view/auth/login_view.dart';
import 'package:text_summary_edit/view/auth/register_view.dart';
import 'package:text_summary_edit/view/hidden_drawer.dart';
import 'package:text_summary_edit/view/home_view.dart';
import 'package:text_summary_edit/view/info_view.dart';
import 'package:text_summary_edit/view/reset_password_view.dart';
import 'package:text_summary_edit/view/text_summary.dart';
import 'package:text_summary_edit/view/web.dart';

class AppRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: home,
      // bindings: [Binding()],
      page: () => HomeView(),
    ),
    GetPage(
      name: textSummary,
      page: () => TextSummary(),
    ),
    GetPage(
        name: login, page: () => LoginView(), middlewares: [AuthMiddleWare()]),
    GetPage(
      name: register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: initState,
      binding: Binding(),
      page: () => HiddenDrawer(),
    ),
    GetPage(
      name: resetPassword,
      binding: Binding(),
      page: () => const ResetPasswordView(),
    ),
    GetPage(
      name: info,
      binding: Binding(),
      page: () => const InfoView(),
    ),
    GetPage(
      name: webView,
      binding: Binding(),
      page: () => const WebView(),
    ),
  ];

  static String login = '/login';
  static String register = '/register';
  static String textSummary = '/textSummary';
  static String home = '/home';
  static String initState = '/initState';
  static String resetPassword = '/resetPassword';
  static String info = '/info';
  static String webView = '/webView';
}
