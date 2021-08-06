import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class Attendance {
  final String id;
  final Map<String, dynamic> attendanceStatus;
  Attendance({@required this.id, this.attendanceStatus});
  
  factory Attendance.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return Attendance(id: doc.id, attendanceStatus: data);
  }
  Map get attStat {
    return{...attendanceStatus};
  }
}
