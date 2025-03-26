// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:text_summary_edit/core/services/const.dart';
import 'package:text_summary_edit/core/services/firestore_user.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/model/user_model.dart';
import 'package:text_summary_edit/routes/routes.dart';

class AuthViewModel extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
  ]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyR = GlobalKey<FormState>();

  var shared = Get.put(SettingsServices());
  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;

  bool isShow = true;

  void changeObscureText() {
    isShow = !isShow;
    update();
  }

  void googleSignIn() async {
    try {
      isLoadingGoogle.value = true;

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoadingGoogle.value = false;
        return; // User canceled the sign-in
      }

      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Save user data to shared preferences
      shared.sharedPref!.setBool('uId', true);
      shared.sharedPref!.setString('Id', userCredential.user!.uid);
      uId = userCredential.user!.uid;

      // Add user data to Firestore
      addToFireStore(userCredential);

      // Show success message
      Get.snackbar('Success', 'Signed in as ${userCredential.user!.email}');
      isLoadingGoogle.value = false;

      // Navigate to the home screen
      Get.offAllNamed(AppRoutes.initState);
    } on PlatformException catch (error) {
      isLoadingGoogle.value = false;
      if (error.code == 'sign_in_canceled') {
        Get.snackbar('Cancel', 'Cancelled the sign-in');
      } else {
        Get.snackbar(
            'Error', 'Failed to sign in with Google: ${error.message}');
      }
    } catch (e) {
      isLoadingGoogle.value = false;
      Get.snackbar('Error', 'Failed to sign in with Google: $e');
    }
  }

  UserModel? userModel;

  void signInWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      final credential = await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text)
          .then((value) async {
        if (kDebugMode) {
          print(value);
        }
        isLoading.value = false;
        shared.sharedPref!.setBool('uId', true);
        shared.sharedPref!.setString('Id', value.user!.uid);
        // await FireStoreUser()
        //     .getUserDataFromFirebase(value.user!.uid)
        //     .then((value) {
        //   userModel = UserModel.fromJson(value.data());
        //   // setUser(UserModel.fromJson(value.data()));
        // });
        // uId = value.user!.uid;
        Get.offAllNamed(AppRoutes.initState);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", 'No user found for that email.');
        isLoading.value = false;
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", 'Wrong password provided for that user.');
        isLoading.value = false;
      } else if (e.code.isEmail != true) {
        Get.snackbar('Error', 'Not a valid email address');
        isLoading.value = false;
      }
    }
  }

  void createAccountWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Get.snackbar(
          'success',
          'Created successfully',
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
        addToFireStore(value);
        isLoading.value = false;
        shared.sharedPref!.setString('Id', value.user!.uid);
        shared.sharedPref!.setBool('uId', true);
        // uId = value.user!.uid;
        Get.offAllNamed(AppRoutes.initState);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
          Get.snackbar('Error password', 'The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
          Get.snackbar('Error create account',
              'The account already exists for that email.');
        }
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error create account', e.toString());
      isLoading.value = false;
    }
  }

  void addToFireStore(UserCredential user) async {
    UserModel model = UserModel(
        uId: user.user!.uid,
        email: user.user!.email,
        name: nameController.text.isEmpty
            ? user.user!.displayName
            : nameController.text,
        image: user.user!.photoURL ??
            "https://cdn.pixabay.com/photo/2017/06/20/22/14/man-2425121_1280.jpg");
    await FireStoreUser().addUserToFireStore(model);
  }

  void reserPassword() async {
    try {
      isLoading.value = true;
      await _auth
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) {
        Get.snackbar('success', 'Check message in Gmail');
        isLoading.value = false;
        Future.delayed(const Duration(seconds: 5)).then((value) {
          Get.back();
        });
      });
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
