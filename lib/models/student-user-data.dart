import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentUser with ChangeNotifier {
  final attendance;
  final assessments;
  final List subjects;
  final String year;
  final String name;
  final String uid;
  StudentUser(
    this.name,
    this.year,
    this.subjects,
    this.attendance,
    this.uid, [
    this.assessments,
  ]);
  factory StudentUser.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      final Map att = {...data['attendance']} ?? {};
      final name = data['studentName'];
      final year = data['year'];
      final Map subs = {...data['registeredSubs']};
      final compAssessments = [...data['completed-assessment']];
      List regSubs = [];

      //takse internal hash map and checks reg status
      subs.forEach((k, v) {
        if (v == true) {
          regSubs.add(k);
        }
      });
      //print('Student user called');
      print('$compAssessments');
      return StudentUser(name, year, regSubs, att, doc.id, compAssessments);
    } catch (err) {
      print('erro in student user moder: $err');
    }
    return null;
  }
}
