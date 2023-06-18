// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_summary_edit/core/services/firestore_user.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/model/user_model.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SettingsViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  var shared = Get.put(SettingsServices());
  RxBool isDarkMode = false.obs;
  RxBool isLoading = false.obs;

  bool oldShow = true;

  void changeObscureTextOld() {
    oldShow = !oldShow;
    update();
  }

  bool newShow = true;

  void changeObscureTextNew() {
    newShow = !newShow;
    update();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   getProfileData();
  // }

  SettingsViewModel() {
    getProfileData();
  }

  var sharedPref = Get.put(SettingsServices());
  void toggleTheme(value) {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    sharedPref.sharedPref!.setBool('theme', isDarkMode.value);
  }

  Future<void> signOut() async {
    if (GoogleSignIn() == true) {
      GoogleSignIn().signOut().then((value) {
        shared.sharedPref!.clear();
        Get.offAllNamed(AppRoutes.login);
      });
    } else {
      await _auth.signOut().then((value) {
        shared.sharedPref!.remove('uId');
        Get.offAllNamed(AppRoutes.login);
      });
    }
  }

  UserModel? userModel;

  void getProfileData() async {
    isLoading.value = true;
    try {
      await FireStoreUser()
          .getUserDataFromFirebase(shared.sharedPref!.getString('Id')!)
          .then((value) {
        userModel = UserModel.fromJson(value.data());
        isLoading.value = false;
        if (kDebugMode) {
          print(userModel!.email);
          print(userModel!.image);
        }
        update();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        isLoading.value = false;
      }
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  RxBool isLoadingChangePaswword = false.obs;

  void changePassword() async {
    try {
      isLoadingChangePaswword.value = true;
      AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!, password: oldPasswordController.text);
      await user!.reauthenticateWithCredential(credential);

      await user!.updatePassword(confirmPasswordController.text).then((value) {
        Get.back();
        oldPasswordController.text = '';
        newPasswordController.text = '';
        confirmPasswordController.text = '';
      });
      Get.snackbar("success", "Password updated successfully");
      isLoadingChangePaswword.value = false;
    } catch (e) {
      isLoadingChangePaswword.value = false;
      Get.snackbar('Error', e.toString());
      if (kDebugMode) {
        print('Error updating password: $e');
      }
    }
  }

  File? image;
  var picker = ImagePicker();
  Future<void> getImageProfile() async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      image = File(pickerFile.path);
      update();
    } else {
      if (kDebugMode) {
        print("No image selected");
      }
    }
    update();
  }

  RxBool isLoadingEditProfile = false.obs;
  void editProfile() async {
    try {
      isLoadingEditProfile.value = true;
      if (image != null) {
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child("users/${Uri.file(image!.path).pathSegments.last}")
            .putFile(image!)
            .then((value) {
          value.ref.getDownloadURL().then((data) async {
            UserModel user = UserModel(
                uId: userModel!.uId,
                email: userModel!.email,
                image: data,
                name: editNameController.text.isEmpty
                    ? userModel!.name
                    : editNameController.text);
            await FireStoreUser()
                .updateProfile(shared.sharedPref!.getString('Id')!, user)
                .then((value) {
              getProfileData();
              isLoadingEditProfile.value = false;
              Get.back();
              editNameController.text = '';
            });
          });
        });
      } else {
        UserModel user = UserModel(
            uId: userModel!.uId,
            email: userModel!.email,
            image: userModel!.image,
            name: editNameController.text.isEmpty
                ? userModel!.name
                : editNameController.text);
        await FireStoreUser()
            .updateProfile(shared.sharedPref!.getString('Id')!, user)
            .then((value) {
          getProfileData();
          isLoadingEditProfile.value = false;
          Get.back();
          editNameController.text = '';
        });
      }
    } catch (e) {
      isLoadingEditProfile.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void logoutNoUser() {
    shared.sharedPref!.remove('uId').then((value) {
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
