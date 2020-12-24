import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import './dummy_data.dart';
import './student.dart';

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
  final SubjectName subjectName;
  final String id;
  Map<Student, AttendanceStatus> attendanceStatus = {};

  SubjectClass({
    @required this.id,
    @required this.subjectName,
    // @required this.regStuds,
  });

  Map<Student, AttendanceStatus> get attStat {
    return attendanceStatus;
  }

  void addStatus(Student stud, AttendanceStatus stat) {
    //if the attendance status is null for stud, adds stat
    attStat.update(stud, (val) => stat, ifAbsent: () => stat);
    print(attendanceStatus.values.length.toString());
    notifyListeners();
  }

  Color getColor() {
     switch (subjectName) {
      case SubjectName.Jurisprudence:
        return Colors.indigo;
        break;
      case SubjectName.Trust:
        return Colors.amber[900];
        break;
      case SubjectName.Conflict:
        return Colors.teal;
        break;
      case SubjectName.Islamic:
        return Colors.lime[800];
        break;
      default:
        return Colors.black;
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
