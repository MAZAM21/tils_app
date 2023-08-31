import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstituteID with ChangeNotifier {
  final String instID;
  InstituteID({required this.instID});

  factory InstituteID.fromFirebase(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    final String id = data['instID'];
    return InstituteID(instID: id);
  }
}
