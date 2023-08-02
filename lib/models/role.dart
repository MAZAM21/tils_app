import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Role with ChangeNotifier {
  final String role;
  final String instID;

  Role(this.role, this.instID);
  factory Role.fromFirestore(DocumentSnapshot doc) {
    try {
      print('gettin role from doc: ${doc.id}');
      Map data = doc.data() as Map<dynamic, dynamic>;
      String instID = data['instID'];
      return Role(data['role'], instID);
    } on Exception catch (e) {
      print('error in role constructor: $e');
    }
    throw Exception();
  }
  String get getRole {
    return role;
  }
}

/// This is a point of failure in the app. If there is no role then app won't generate the homescreen
class InstProvider with ChangeNotifier {
  String? _instID;

  String? get instID => _instID;

  Future<String?> getId() {
    return Future.value(_instID);
  }

  void setID(String instID) {
    _instID = instID;
    notifyListeners();
  }
}
