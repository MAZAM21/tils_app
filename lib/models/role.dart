import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Role with ChangeNotifier {
  final String role;
  final String instID;

  Role(this.role, this.instID);
  factory Role.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    String instID = data['instID'];
    return Role(data['role'], instID);
  }
  String get getRole {
    return role;
  }
}

/// This is a point of failure in the app. If there is no role then app won't generate the homescreen
class RoleProvider with ChangeNotifier {
  Role? _role;

  Role? get role => _role;

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }
}
