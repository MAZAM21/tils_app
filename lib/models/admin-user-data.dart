import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUser with ChangeNotifier {
  final String name;

  final String uid;

  final String docId;

  AdminUser({
    @required this.name,
    @required this.uid,
    @required this.docId,
  });

  factory AdminUser.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      final name = data['name'];     
      final uid = data['uid'];

      //print(doc.id);

      return AdminUser(
        name: name,
        uid: uid,
        docId: doc.id,
      );
    } catch (err) {
      print('error in teacher user model: $err');
    }
    return null;
  }
}
