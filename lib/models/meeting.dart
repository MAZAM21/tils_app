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