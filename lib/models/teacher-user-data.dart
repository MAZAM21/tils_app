import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherUser with ChangeNotifier{
  final String name;
  final String year;
  final List<String> subjects;
  final String uid;
  final bool isAdmin;
  TeacherUser({
    @required this.name,
    @required this.year,
    @required this.uid,
    @required this.isAdmin,
    @required this.subjects,
  });

  factory TeacherUser.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      final name = data['name'];
      final year = data['year'];
      final uid = data['uid'];
      final isAdmin = data['isAdmin'];
      final Map subs = {...data['subjects']};
      List<String> tsubs = [];
      subs.forEach((k, v) {
        if (v == true) {
          tsubs.add(k);
        }
      });
      return TeacherUser(
        name: name,
        year: year,
        uid: uid,
        subjects: tsubs,
        isAdmin: isAdmin,
      );
    } catch (err) {
      print('error in teacher user model: $err');
    }
    return null;
  }
}
