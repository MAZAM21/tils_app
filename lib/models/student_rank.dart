import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

enum StudentRankYear {
  First,
  Second,
  Third,
}

class StudentRank with ChangeNotifier {
  final String id;
  final String name;
  final String batch;
  final String section;
  final String year;
  String imageUrl;
  Map attendance = {};
  Map textMarks = {};
  Map mcqMarks = {};
  List completedAssessements;
  double score;
  int position;
  List subjects;

  StudentRank({
    @required this.id,
    @required this.name,
    @required this.year,
    @required this.batch,
    @required this.section,
    this.imageUrl,
    this.attendance,
    this.textMarks,
    this.mcqMarks,
    this.completedAssessements,
    this.score,
    this.position,
    this.subjects,
  });

  factory StudentRank.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      Map data = doc.data();
      Map att = {...data['attendance'] ?? {}};
      Map tqm = {};
      Map mcqm = {};
      final Map subs = {...data['registeredSubs'] ?? {}};
      final completed = List<String>.from(data['completed-assessments'] ?? []);
      List regSubs = [];

      //takse internal hash map and checks reg status
      subs.forEach((k, v) {
        if (v == true) {
          regSubs.add(k);
        }
      });

      if (data['Assessment-textqMarks'] != null) {
        tqm = {...data['Assessment-textqMarks']?? {}} ;
      } else {
        tqm = {'none': 0};
      }

      if (data['Assessment-MCQMarks'] != null) {
        mcqm = {...data['Assessment-MCQMarks']?? {}} ;
      } else {
        mcqm = {'none': 0};
      }
      if (data['attendance'] != null) {
        att = {...data['attendance']?? {}} ;
      } else {
        att = {'none': 0};
      }

      //print('${data['name']}');
      return StudentRank(
          id: doc.id ?? '',
          name: data['name'] ?? '',
          year: data['year'] ?? '',
          batch: data['batch'] ?? '',
          section: data['section'] ?? '',
          imageUrl: data['profile-pic-url'] ?? '',
          attendance: att,
          textMarks: tqm,
          mcqMarks: mcqm,
          completedAssessements: completed,
          subjects: regSubs);
    } catch (e) {
      print('error in StudentRank model: $e');
    }

    return null;
  }
}



/// This model is to have all StudentRank data so that it can be used for score, attendance, and assessment. 
/// TODO: Instead of sorting through all of the maps in Ranking service, methods can be added here that serve up the required data
/// like total and obtained marks per subject, Overall total score. Excellent Idea. Was missing this. 