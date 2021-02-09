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

 
  Map<String, int> attendance = {};

  Student({
    @required this.id,
    @required this.name,
    @required this.year,
    @required this.batch,
    @required this.section,
    this.attendance,
  });

  factory Student.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Student(
      id: doc.id ?? '',
      name: data['name'] ?? '',
      year: data['year'] ?? '',
      batch: data['batch'],
      section: data['section'],
      attendance: {...data['attendance']} ?? {},
    );
  }

  List get attStatStud {
    return [...attendance.values];
  }

  String get getId {
    return id;
  }


}
