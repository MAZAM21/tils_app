import 'package:tils_app/widgets/screens/attendance_page.dart';

import './subject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum StudentYear {
  First,
  Second,
  Third,
}

class Student with ChangeNotifier {
  final String id;
  final String name;
  final StudentYear year;

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
    @required this.regSubs,
  });

  List get attStatStud {
    return [...attendance.values];
  }

  String get getId {
    return id;
  }

  void addRec(String id, AttendanceStatus att) {
    attendance.update(id, (val)=> att, ifAbsent: () => att );
    
    print(name);
    print(attendance);
    notifyListeners();
  }
}
