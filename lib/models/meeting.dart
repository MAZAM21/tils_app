import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.docId,
    this.section, [
    this.topic,
  ]);

  factory Meeting.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return Meeting(
      data['subjectName'] ?? '',
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']),
      DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['endTime']),
      getColor(data['subjectName']),
      false,
      doc.id,
      data['section'],
      data['topic'] ?? '',
    );
  }

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime? from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime? to;

  /// Background which is equivalent to color property of [Appointment].
  Color? background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  /// Firestore doc ID.
  String docId;

  /// Topic of class
  String? topic;

  /// Section
  String? section;
}

Color getColor(subjectName) {
  switch (subjectName) {
    case 'Jurisprudence':
      return Color.fromARGB(255, 56, 85, 89);

    case 'Trust':
      return Color.fromARGB(255, 68, 137, 156);

    case 'Conflict':
      return Color.fromARGB(255, 37, 31, 87);

    case 'Islamic':
      return Color.fromARGB(255, 39, 59, 92);

    case 'Company':
      return Color.fromARGB(255, 50, 33, 58);

    case 'Tort':
      return Color.fromARGB(255, 56, 59, 83);

    case 'Property':
      return Color.fromARGB(255, 102, 113, 126);

    case 'EU':
      return Color.fromARGB(255, 206, 185, 146);

    case 'HR':
      return Color.fromARGB(255, 143, 173, 136);

    case 'Contract':
      return Color.fromARGB(255, 36, 79, 38);

    case 'Criminal':
      return Color.fromARGB(255, 37, 109, 27);

    case 'LSM':
      return Color.fromARGB(255, 189, 213, 234);

    case 'Public':
      return Color.fromARGB(255, 201, 125, 96);

    default:
      return Colors.black;
  }
}
