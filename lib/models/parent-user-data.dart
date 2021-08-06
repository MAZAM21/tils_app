import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentUser with ChangeNotifier {
  final String studentName;
  final String year;
  final String section;
  final String imageUrl;
  final attendance;
  final Map textQMarks;
  final Map mcqMarks;
  final String studId;
  final List completedAssessments;

  ParentUser({
    @required this.studentName,
    @required this.year,
    @required this.section,
    @required this.studId,
    this.imageUrl,
    this.attendance,
    this.textQMarks,
    this.mcqMarks,
    this.completedAssessments,
  });

  factory ParentUser.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      final name = data['name'] ?? '';
      final year = data['year'] ?? '';
      final section = data['section'] ?? '';
      final Map att = {...data['attendance']} ?? {};
      final url = data['profile-pic-url'];
      Map tqm = {};
      Map mcqm = {};
      List compAss = [];

      if (data['Assessment-textqMarks'] != null) {
        tqm = {...data['Assessment-textqMarks']} ?? {};
      } else {
        tqm = {'none': 0};
      }

      if (data['Assessment-MCQMarks'] != null) {
        mcqm = {...data['Assessment-MCQMarks']} ?? {};
      } else {
        mcqm = {'none': 0};
      }
      if (data['completed-assessments'] != null) {
        compAss = [...data['completed-assessments']] ?? [];
      } else {
        compAss = [];
      }

      return ParentUser(
        studentName: name,
        year: year,
        section: section,
        attendance: att,
        imageUrl: url,
        textQMarks: tqm,
        mcqMarks: mcqm,
        studId: doc.id,
        completedAssessments: compAss,
      );
    } catch (err) {
      print('error in parent user data: $err');
    }
    return null;
  }
}
