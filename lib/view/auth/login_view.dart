// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/auth_view_model.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:text_summary_edit/view/widget/MyBotton.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/MyTextFormField.dart';
import 'package:text_summary_edit/view/widget/circleDesgin.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class LoginView extends GetWidget<AuthViewModel> {
  LoginView({super.key});

  var shared = Get.put(SettingsServices());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? const Color.fromARGB(221, 17, 16, 16)
          : Colors.grey.shade300,
      // appBar: CustomAppBar(title: MyText(text: '')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.69,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: GradientBall(
                        colors: [
                          Colors.deepOrange.withOpacity(0.6),
                          Colors.amber.withOpacity(0.5),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 1,
                      child: GradientBall(
                        size: const Size.square(200),
                        colors: [
                          Colors.blue.withOpacity(0.6),
                          Colors.purple.withOpacity(1)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlurryContainer(
                        color: Get.isDarkMode
                            ? Colors.grey.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.21),
                        blur: 30,
                        padding: const EdgeInsets.all(20),
                        child: _buildLoginDesign(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginDesign(context) => Form(
        key: controller.formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: 'Login',
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 25,
                      ),
                ),
                const SizedBox(height: 50.0),
                CustomTextFormField(
                  validator: (value) {
                    if (value == null ||value.isEmpty) {
                      return 'email address is required';
                    }
                    return null;
                  },
                  typeInput: TextInputType.emailAddress,
                  controller: controller.emailController,
                  perfixIcon: const Icon(IconBroken.Profile),
                  hintText: 'Email Address',
                ),
                const SizedBox(height: 20.0),
                GetBuilder<AuthViewModel>(
                  builder: (cont) {
                    return CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password is required';
                        }
                        return null;
                      },
                      controller: controller.passwordController,
                      perfixIcon: const Icon(IconBroken.Lock),
                      hintText: 'Password',
                      obscureText: cont.isShow,
                      typeInput: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          cont.changeObscureText();
                        },
                        icon: cont.isShow
                            ? const Icon(
                                Icons.visibility,
                              )
                            : const Icon(Icons.visibility_off),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.resetPassword);
                    },
                    child: MyText(
                      text: 'Forgot Password !',
                      textStyle: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GetX<AuthViewModel>(builder: (c) {
                  return MyBotton(
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.signInWithEmailAndPassword();
                      }
                    },
                    text: c.isLoading.value
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : MyText(
                            text: 'Sign In',
                            textStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                          ),
                    color: const [
                      Colors.blue,
                      Colors.purple,
                    ],
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,
                  );
                }),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    controller.googleSignIn();
                  },
                  child: BlurryContainer(
                    color: Get.isDarkMode
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.21),
                    blur: 30,
                    borderRadius: BorderRadius.circular(10.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    // padding: const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: GetX<AuthViewModel>(builder: (loading) {
                      return loading.isLoadingGoogle.value
                          ? const CupertinoActivityIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google.png'),
                                const SizedBox(width: 10.0),
                                MyText(
                                  text: 'Sign In With Google',
                                ),
                              ],
                            );
                    }),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(text: 'Don\'t have an account?'),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: MyText(
                        text: 'Sign Up ',
                        textStyle: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        shared.sharedPref!.setBool('uId', false).then((value) {
                          Get.offAllNamed(AppRoutes.initState);
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              text: 'SKIP',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.blue,
                                    fontSize: 16.0,
                                  ),
                            ),
                            const Icon(
                              IconBroken.Arrow___Right_2,
                              size: 18,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
}
