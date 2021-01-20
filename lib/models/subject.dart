import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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
  final DateTime startTime;
  Map<String, dynamic> attendanceStatus = {};

  SubjectClass({
    @required this.id,
    @required this.subjectName,
    @required this.startTime,
    this.attendanceStatus,
  });

  factory SubjectClass.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();

    return SubjectClass(
      id: doc.id,
      subjectName: data['subjectName'],
      startTime: DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']),
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
        return Color.fromARGB(255, 56, 85, 89);
        break;
      case 'Trust':
        return Color.fromARGB(255, 68, 137, 156);
        break;
      case 'Conflict':
        return Color.fromARGB(255, 37, 31, 87);
        break;
      case 'Islamic':
        return Color.fromARGB(255, 39, 59, 92);
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

  // String getAllPresent() {
  //   final studs = attendanceStatus.keys.toList();
  //   final stats = attendanceStatus.values.toList();
  //   int allP = 0;
  //   for (var i = 0; i < studs.length; i++) {
  //     if (stats[i] == AttendanceStatus.Present) {
  //       allP++;
  //     }
  //   }
  //   return allP.toString();
  // }

  // List<String> get allStudIDs {
  //   return regStuds;
  // }
}
