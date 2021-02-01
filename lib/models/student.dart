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
  final String year;

 
  Map<String, int> attendance = {};

  Student({
    @required this.id,
    @required this.name,
    @required this.year,
    this.attendance,
  });

  factory Student.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Student(
      id: doc.id ?? '',
      name: data['studentName'] ?? '',
      year: data['year'] ?? '',
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
