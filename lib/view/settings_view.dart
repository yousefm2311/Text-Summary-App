// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/settings_view_model.dart';
import 'package:text_summary_edit/view/widget/MyBotton.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/MyTextFormField.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class SettingsView extends GetWidget<SettingsViewModel> {
  SettingsView({super.key});

  var sharedPref = Get.put(SettingsServices());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sharedPref.sharedPref!.getBool("uId") == true
          ? GetBuilder<SettingsViewModel>(
              builder: (cont) {
                return cont.isLoading.value
                    ? const Center(child: CupertinoActivityIndicator())
                    : SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.07),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: Colors.grey,
                                  ),
                                  child: controller.userModel!.image != null
                                      ? CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          imageUrl: cont.userModel!.image!,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CupertinoActivityIndicator()),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                        )
                                      : Container(),
                                ),
                                const SizedBox(height: 30.0),
                                MyText(
                                  text: '${cont.userModel!.name}',
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                MyText(text: '${cont.userModel!.email}'),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                                InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: "Change your password",
                                      titleStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      content: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Form(
                                          key: cont.formKey,
                                          child: GetBuilder<SettingsViewModel>(
                                              builder: (contro) {
                                            return Column(
                                              children: [
                                                CustomTextFormField(
                                                  obscureText: contro.oldShow,
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      contro
                                                          .changeObscureTextOld();
                                                    },
                                                    icon: contro.oldShow
                                                        ? const Icon(
                                                            Icons.visibility,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .visibility_off,
                                                          ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Old password is required';
                                                    }
                                                    return null;
                                                  },
                                                  hintText: 'Old Password',
                                                  controller: cont
                                                      .oldPasswordController,
                                                  perfixIcon: const Icon(
                                                      IconBroken.Lock),
                                                ),
                                                const SizedBox(height: 10.0),
                                                CustomTextFormField(
                                                  obscureText: contro.newShow,
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      contro
                                                          .changeObscureTextNew();
                                                    },
                                                    icon: contro.newShow
                                                        ? const Icon(
                                                            Icons.visibility,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .visibility_off,
                                                          ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'New password is required';
                                                    }
                                                    return null;
                                                  },
                                                  hintText: 'New Password',
                                                  controller: cont
                                                      .newPasswordController,
                                                  perfixIcon: const Icon(
                                                      IconBroken.Lock),
                                                ),
                                                const SizedBox(height: 10.0),
                                                CustomTextFormField(
                                                  obscureText: contro.newShow,
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      contro
                                                          .changeObscureTextNew();
                                                    },
                                                    icon: contro.newShow
                                                        ? const Icon(
                                                            Icons.visibility,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .visibility_off,
                                                          ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Confirm password is required';
                                                    } else if (cont
                                                            .newPasswordController
                                                            .text !=
                                                        cont.confirmPasswordController
                                                            .text) {
                                                      return 'Passwords do not match';
                                                    }
                                                    return null;
                                                  },
                                                  hintText: 'Confirm Password',
                                                  controller: cont
                                                      .confirmPasswordController,
                                                  perfixIcon: const Icon(
                                                      IconBroken.Lock),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                      confirm: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GetX<SettingsViewModel>(
                                          builder: (c) {
                                            return MyBotton(
                                              onPressed: () {
                                                if (cont.formKey.currentState!
                                                    .validate()) {
                                                  cont.changePassword();
                                                }
                                              },
                                              text: c.isLoadingChangePaswword
                                                      .value
                                                  ? const CupertinoActivityIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : MyText(
                                                      text: 'Confirm',
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                    ),
                                              color: const [
                                                Colors.blue,
                                                Colors.purple,
                                              ],
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: BlurryContainer(
                                    color: Get.isDarkMode
                                        ? Colors.grey.withOpacity(0.05)
                                        : Colors.grey.withOpacity(0.21),
                                    blur: 30,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        const Icon(IconBroken.Lock),
                                        const SizedBox(width: 5.0),
                                        MyText(
                                          text: 'Change Password ',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 16.0),
                                        ),
                                        const Spacer(),
                                        const Icon(IconBroken.Arrow___Right_2)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                BlurryContainer(
                                  color: Get.isDarkMode
                                      ? Colors.grey.withOpacity(0.05)
                                      : Colors.grey.withOpacity(0.21),
                                  blur: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Get.isDarkMode
                                          ? const Icon(Icons.dark_mode_rounded)
                                          : const Icon(
                                              Icons.light_mode_outlined),
                                      const SizedBox(width: 5.0),
                                      MyText(
                                        text: 'Dark Mode',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 16.0),
                                      ),
                                      const Spacer(),
                                      GetBuilder<SettingsViewModel>(
                                          builder: (cont) {
                                        return SizedBox(
                                          height: 10,
                                          child: Switch.adaptive(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            value: sharedPref.sharedPref!
                                                    .getBool('theme') ??
                                                false,
                                            onChanged: (v) {
                                              cont.toggleTheme(v);
                                            },
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                        title: 'Edit Profile',
                                        titleStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        content: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  controller.getImageProfile();
                                                },
                                                child: GetBuilder<
                                                        SettingsViewModel>(
                                                    builder: (ima) {
                                                  return Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomEnd,
                                                    children: [
                                                      Container(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        height: 100.0,
                                                        width: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        child: ima.image != null
                                                            ? Image.file(
                                                                ima.image!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : CachedNetworkImage(
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                                imageUrl: cont
                                                                    .userModel!
                                                                    .image!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                        child:
                                                                            CupertinoActivityIndicator()),
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                                ),
                                                              ),
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          IconBroken.Edit,
                                                          color: Get.isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 20.0),
                                              CustomTextFormField(
                                                hintText: 'Name',
                                                controller: controller
                                                    .editNameController,
                                                perfixIcon: const Icon(
                                                  IconBroken.Profile,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirm: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              bottom: 20.0,
                                              right: 10),
                                          child: GetX<SettingsViewModel>(
                                              builder: (edit) {
                                            return MyBotton(
                                              onPressed: () {
                                                edit.editProfile();
                                              },
                                              text: edit.isLoadingEditProfile
                                                      .value
                                                  ? const CupertinoActivityIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : MyText(
                                                      text: 'Confirm',
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                    ),
                                              color: const [
                                                Colors.blue,
                                                Colors.purple,
                                              ],
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            );
                                          }),
                                        ));
                                  },
                                  child: BlurryContainer(
                                    color: Get.isDarkMode
                                        ? Colors.grey.withOpacity(0.05)
                                        : Colors.grey.withOpacity(0.21),
                                    blur: 30,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        const Icon(IconBroken.Edit),
                                        const SizedBox(width: 5.0),
                                        MyText(
                                          text: 'Edit Profile',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 16.0),
                                        ),
                                        const Spacer(),
                                        const Icon(IconBroken.Arrow___Right_2)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                InkWell(
                                  onTap: () {
                                    controller.signOut();
                                  },
                                  child: BlurryContainer(
                                    color: Get.isDarkMode
                                        ? Colors.grey.withOpacity(0.05)
                                        : Colors.grey.withOpacity(0.21),
                                    blur: 30,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        const Icon(IconBroken.Logout),
                                        const SizedBox(width: 5.0),
                                        MyText(
                                          text: 'Sign Out',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 16.0),
                                        ),
                                        const Spacer(),
                                        const Icon(IconBroken.Arrow___Right_2)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50.0),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            )
          : Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlurryContainer(
                    color: Get.isDarkMode
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.21),
                    blur: 30,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Get.isDarkMode
                            ? const Icon(Icons.dark_mode_rounded)
                            : const Icon(Icons.light_mode_outlined),
                        const SizedBox(width: 5.0),
                        MyText(
                          text: 'Dark Mode',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 16.0),
                        ),
                        const Spacer(),
                        GetBuilder<SettingsViewModel>(builder: (cont) {
                          return SizedBox(
                            height: 10,
                            child: Switch.adaptive(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: sharedPref.sharedPref!.getBool('theme') ??
                                  false,
                              onChanged: (v) {
                                cont.toggleTheme(v);
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      controller.logoutNoUser();
                    },
                    child: BlurryContainer(
                      color: Get.isDarkMode
                          ? Colors.grey.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.21),
                      blur: 30,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(IconBroken.Logout),
                          const SizedBox(width: 5.0),
                          MyText(
                            text: 'Sign In',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 16.0),
                          ),
                          const Spacer(),
                          const Icon(IconBroken.Arrow___Right_2)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
