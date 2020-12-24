import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../widgets/time_table.dart';

class AllClasses with ChangeNotifier {
  //_allClasses will have a list of SubjectClass elements which will be displayed for attendance and records
  //allClassMeetings will be used for Syncfusion Calendar widget
  //addClass adds to _allClasses

  List<SubjectClass> allClasses = [
    SubjectClass(id: 'test', subjectName: SubjectName.Islamic),
  ];

  final List<Meeting> allClassMeetings = [];

  List<SubjectClass> get allClassesData {
    return [...allClasses];
  }

  List<Meeting> get timeTable {
    return [...allClassMeetings];
  }

  void addClass(
    String id,
    SubjectName name,
  ) {
    SubjectClass addToAll = SubjectClass(
      id: id,
      subjectName: name,
    );
    allClasses.add(addToAll);
    notifyListeners();
  }

  Color assignCol(SubjectName sub) {
    switch (sub) {
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

  void addMeeting(DateTime start, SubjectName name, int durationHours) {
    DateTime endTime = start.add(Duration(hours: durationHours));
    if (start != null && name != null) {
      Meeting m =
          Meeting(enToString(name), start, endTime, assignCol(name), false);
      addClass(
        DateTime.now().toString(),
        name,
      );
      allClassMeetings.add(m);
      notifyListeners();
    }
  }

  String enToString(SubjectName name) {
    switch (name) {
      case SubjectName.Jurisprudence:
        return 'Jurisprudence';
        break;
      case SubjectName.Trust:
        return 'Trust';
        break;
      case SubjectName.Conflict:
        return 'Conflict';
        break;
      case SubjectName.Islamic:
        return 'Islamic';
        break;
      default:
        return 'Undeclared';
    }
  }
}
