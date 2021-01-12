

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AllClasses with ChangeNotifier {
  //_allClasses will have a list of SubjectClass elements which will be displayed for attendance and records
  //allClassMeetings will be used for Syncfusion Calendar widget
  //addClass adds to _allClasses

  List<SubjectClass> _allClasses = [
    SubjectClass(id: 'test', subjectName: 'Islamic'),
  ];

  final List<Meeting> allClassMeetings = [];

  List<Meeting> get allMeetings {
    return [...allClassMeetings];
  }

  List<SubjectClass> get allClassesData {
    return [..._allClasses];
  }

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

  void addMeetingFromCF(String name, String start, String end, String id) {
    allClassMeetings.add(Meeting(
      name,
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(start),
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(end),
      Colors.amberAccent,
      false,
      id,
    ));
  }

  // void addClassFromCF(String id, String subName) {
  //   _allClasses.add(SubjectClass(
  //     id: id,
  //     subjectName: setSubject(subName),
  //   ));
  // }

  void addAttFromCF(String id, Map<dynamic, dynamic> attendance) {
    
    _allClasses.forEach((cls) {
      if (id == cls.id) {
        cls.attendanceStatus = attendance;
      }
    });
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
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.docId);

  factory Meeting.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Meeting(
      data['subjectName'] ?? '',
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']),
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['endTime']),
      Colors.lightGreen,
      false,
      doc.id,
    );
  }

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  /// Firestore doc ID.
  String docId;
}
