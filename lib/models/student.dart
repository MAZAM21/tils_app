import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

enum StudentYear {
  First,
  Second,
  Third,
}

class Student with ChangeNotifier {
  final String id;
  final String name;
  final String batch;
  final String section;
  final String year;
  Map attendance = {};
  Map textMarks = {};
  Map mcqMarks = {};

  Student({
    @required this.id,
    @required this.name,
    @required this.year,
    @required this.batch,
    @required this.section,
    this.attendance,
    this.textMarks,
    this.mcqMarks,
  });

  factory Student.fromFirestore(
      QueryDocumentSnapshot doc) {
    try {
      Map data = doc.data();
      

      return Student(
        id: doc.id ?? '',
        name: data['name'] ?? '',
        year: data['year'] ?? '',
        batch: data['batch'] ?? '',
        section: data['section'] ?? '',
        attendance: {...data['attendance'] ?? {}} ?? {},
        textMarks: {...data['Assessment-textqMarks'] ?? {}} ?? {},
        mcqMarks: {...data['Assessment-MCQMarks'] ?? {}} ?? {},
      );
    } catch (e) {
      print('error in Student model:' + e);
      return null;
    }
  }

  List get attStatStud {
    return [...attendance.values];
  }

  String get getId {
    return id;
  }
}



/// This model is to have all student data so that it can be used for score, attendance, and assessment. 