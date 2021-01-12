import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


enum SubjectName {
  Trust,
  Jurisprudence,
  Islamic,
  Conflict,
  Undeclared,
}
enum AttendanceStatus {
  Present,
  Absent,
  Late,
}

class SubjectClass with ChangeNotifier {
  final String subjectName;
  final String id;
  Map<String, dynamic> attendanceStatus = {};

  SubjectClass({
    @required this.id,
    @required this.subjectName,
    this.attendanceStatus,
  });

  factory SubjectClass.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();

    return SubjectClass(
      id: doc.id,
      subjectName: data['subjectName'],
    );
  }

  Map<dynamic, dynamic> get attStat {
    return attendanceStatus;
  }

  // void addStatus(Student stud, AttendanceStatus stat) {
  //   //if the attendance status is null for stud, adds stat
  //   attStat.update(stud, (val) => stat, ifAbsent: () => stat);
  //   print(attendanceStatus.values.length.toString());
  //   notifyListeners();
  // }

  Color getColor() {
    switch (subjectName) {
      case 'Jurisprudence':
        return Colors.indigo;
        break;
      case 'Trust':
        return Colors.amber[900];
        break;
      case 'Conflict':
        return Colors.teal;
        break;
      case 'Islamic':
        return Colors.lime[800];
        break;
      default:
        return Colors.black;
    }
  }

  SubjectName setSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return SubjectName.Jurisprudence;
        break;
      case 'Trust':
        return SubjectName.Trust;
        break;
      case 'Conflict':
        return SubjectName.Conflict;
        break;
      case 'Islamic':
        return SubjectName.Islamic;
        break;
      default:
        return SubjectName.Undeclared;
    }
  }

  String getAllPresent() {
    final studs = attendanceStatus.keys.toList();
    final stats = attendanceStatus.values.toList();
    int allP = 0;
    for (var i = 0; i < studs.length; i++) {
      if (stats[i] == AttendanceStatus.Present) {
        allP++;
      }
    }
    return allP.toString();
  }

  // List<String> get allStudIDs {
  //   return regStuds;
  // }
}
