import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentUser with ChangeNotifier {
  final attendance;
  final List completedAssessments;
  final List subjects;
  final String year;
  final String name;
  final String uid;
  final String section;
  final String batch;
  final String imageURL;

  StudentUser(
    this.name,
    this.year,
    this.subjects,
    this.attendance,
    this.uid,
    this.section,
    this.batch, [
    this.completedAssessments,
    this.imageURL,
  ]);
  factory StudentUser.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      final Map att = {...data['attendance']};
      final name = data['name'] ?? '';
      final year = data['year'] ?? '';
      final Map subs = {...data['registeredSubs']};
      List compAss;
      final section = data['section'] ?? '';
      final batch = data['batch'] ?? '';
      final url = data['profile-pic-url'] ?? '';
      List<String> regSubs = [];
      if (data.containsKey('completed-assessments')) {
        compAss = [...data['completed-assessments']];
      } else {
        compAss = [];
      }

      //takse internal hash map and checks reg status
      subs.forEach((k, v) {
        if (v == true) {
          regSubs.add(k);
        }
      });

      //print('Student user called');
      //print('$compAssessments');
      return StudentUser(
        name,
        year,
        regSubs,
        att,
        doc.id,
        section,
        batch,
        compAss,
        url,
      );
    } catch (err) {
      print('erro in student user moder: $err');
    }
    return null;
  }
}
