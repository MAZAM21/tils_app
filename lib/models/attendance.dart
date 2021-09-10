import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Attendance {
  final String id;
  final Map attendanceStatus;
  final String classID;
  final String subject;
  Attendance(
      {@required this.id, this.attendanceStatus, this.subject, this.classID});

  factory Attendance.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    Map attStat = {};
    String classID = data['classId'] ?? '';
    String subject = data['subject'] ?? '';

    if (data.containsKey('attStat')) {
      attStat = data['attStat'];
    }
    return Attendance(
      id: doc.id,
      attendanceStatus: attStat,
      classID: classID,
      subject: subject,
    );
  }
  Map get attStat {
    return {...attendanceStatus};
  }
}

class AttendanceInput {
  Map attendanceStatus;
  String classID;
  String subject;
  AttendanceInput({
    this.attendanceStatus,
    this.subject,
    this.classID,
  });
}
