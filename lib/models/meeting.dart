import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
      getColor(data['subjectName'])?? Colors.black,
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
Color getColor(subjectName) {
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