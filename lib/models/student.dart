import 'package:cloud_firestore/cloud_firestore.dart';

import './subject.dart';
import 'package:flutter/material.dart';

enum StudentYear {
  First,
  Second,
  Third,
}

class Student with ChangeNotifier {
  final String id;
  final String name;
  final String year;

  Map<SubjectName, bool> regSubs = {
    SubjectName.Jurisprudence: true,
    SubjectName.Conflict: true,
    SubjectName.Islamic: true,
    SubjectName.Trust: true,
  };
  Map<String, AttendanceStatus> attendance = {};

  Student({
    @required this.id,
    @required this.name,
    @required this.year,
  });

  factory Student.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Student(
      id: doc.id,
      name: data['studentName'],
      year: data['year'],
    );
  }

  List get attStatStud {
    return [...attendance.values];
  }

  String get getId {
    return id;
  }

  void addRec(String id, AttendanceStatus att) {
    attendance.update(id, (val) => att, ifAbsent: () => att);

    print(name);
    print(attendance);
    notifyListeners();
  }
}
