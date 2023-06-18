import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:text_summary_edit/model/history_model.dart';
import 'package:text_summary_edit/model/user_model.dart';

class FireStoreHistory {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> addHistory(
      HistoryModel historyModel, UserModel userModel) async {
    return await _userCollectionRef
        .doc(userModel.uId)
        .collection('history')
        .add(historyModel.toJson())
        .then((value) {})
        .catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future getHistory(String uId) async {
    try {
      return await _userCollectionRef.doc(uId).collection('history').get();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  Future deleteHitory(uId,doscID) async {
    try {
      return await _userCollectionRef
          .doc(uId)
          .collection('history')
          .doc(doscID)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
