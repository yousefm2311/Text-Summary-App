import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:text_summary_edit/model/user_model.dart';

class FireStoreUser {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUserToFireStore(UserModel userModel) async {
    return await _userCollectionRef
        .doc(userModel.uId)
        .set(userModel.toJson())
        .then((value) {})
        .catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future getUserDataFromFirebase(String uId) async {
    return await _userCollectionRef.doc(uId).get();
  }
  Future updateProfile(String uId,UserModel model) async {
    return await _userCollectionRef.doc(uId).update(model.toJson());
  }
}
