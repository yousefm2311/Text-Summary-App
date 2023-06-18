import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/view_model/auth_view_model.dart';
import 'package:text_summary_edit/view/widget/MyBotton.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/MyTextFormField.dart';
import 'package:text_summary_edit/view/widget/custom_appBar.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class ResetPasswordView extends GetWidget<AuthViewModel> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: MyText(text: 'Reset Password')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomTextFormField(
              hintText: 'Enter email address',
              controller: controller.emailController,
              perfixIcon: const Icon(
                IconBroken.Message,
              ),
            ),
          ),
          GetX<AuthViewModel>(builder: (contr) {
            return MyBotton(
              onPressed: () {
                controller.reserPassword();
              },
              text: contr.isLoading.value
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : MyText(
                      text: 'Reset Password',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
              color: const [Colors.blue, Colors.purple],
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
            );
          })
        ],
      ),
    );
  }
}
