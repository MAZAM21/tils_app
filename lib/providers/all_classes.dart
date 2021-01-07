import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../widgets/screens/time_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // List<Meeting> get timeTable {
  //   //return [...allClassMeetings];

  //   return[...getFromCF()];
  // }

  CollectionReference _classCollection =
      FirebaseFirestore.instance.collection('classes');

  Future<void> addToCF(
    SubjectName name,
    DateTime start,
    DateTime end,
  ) async {
    String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
    String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);

    try {
      return await _classCollection.add({
        'subjectName': enToString(name),
        'startTime': startString,
        'endTime': endString,
      });
    } catch (err) {
      print('error in adding to database: $err');
    }
  }

  Future<void> editInCF(
      String id, String name, DateTime start, DateTime end) async {
    String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
    String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);
    try {
      return await _classCollection.doc(id).set({
        'subjectName': name,
        'startTime': startString,
        'endTime': endString,
      });
    } catch (err) {
      print('error in adding edited class: $err');
    }
    
  }

  // List<Meeting> getFromCF() {
  //   List<Meeting> inFuncList;
  //   _classCollection.get().then((snapShot) {
  //     return snapShot.docs.forEach((meeting) {
  //       return inFuncList.add(Meeting(

  //         meeting['subjectName'],
  //         DateFormat("yyyy-MM-dd hh:mm:ss a").parse(meeting['startTime']),
  //         DateFormat("yyyy-MM-dd hh:mm:ss a").parse(meeting['endTime']),
  //         Colors.grey,
  //         false,
  //       ));
  //     });
  //   });
  //   return inFuncList;
  // }

  // void deleteFromCF() {
  //   _classCollection.
  // }

  // void addClass(
  //   String id,
  //   SubjectName name,
  // ) {
  //   SubjectClass addToAll = SubjectClass(
  //     id: id,
  //     subjectName: name,
  //   );
  //   allClasses.add(addToAll);
  //   notifyListeners();
  // }

  // void addMeeting(DateTime start, SubjectName name, DateTime endTime) {
  //   if (start != null && name != null) {
  //     // Meeting m = Meeting(
  //     //   enToString(name),
  //     //   start,
  //     //   endTime,
  //     //   assignCol(name),
  //     //   false,
  //     // );
  //     addToCF(name, start, endTime);
  //     addClass(
  //       DateTime.now().toString(),
  //       name,
  //     );
  //     // allClassMeetings.add(m);

  //     notifyListeners();
  //   }
  // }

  // int findMeetingIndex(String docId) {
  //   int i = allClassMeetings.firstWhere((x) {
  //     return x.docId ==docId;
  //   });
  //   return i;
  // }

  // void editMeeting(int i, DateTime start, SubjectName name, DateTime end) {
  //   allClassMeetings[i] = Meeting(
  //     enToString(name),
  //     start,
  //     end,
  //     assignCol(name),
  //     false,
  //   );
  //   notifyListeners();
  // }

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
}
