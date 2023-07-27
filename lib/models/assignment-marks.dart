import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/student_rank.dart';

class AssignmentMarks with ChangeNotifier {
  /// title of assignment
  String? title;

  /// subject
  String? subject;

  /// Name of teacher who uploaded marks
  String? teacherName;

  /// DB id of teacher
  String? teacherId;

  /// A map of student names as keys and marks entered as values
  /// to be uploaded to assignment-marks collection
  Map<String, int>? marks;

  /// A map of student IDs as keys and marks as values
  Map<String, int>? uidMarks;

  /// List of studentrank objects for ui display of names and pics
  List<StudentRank>? studentList;

  /// The max marks of the assignment
  int? totalMarks;

  AssignmentMarks(
      {this.title,
      this.subject,
      this.teacherName,
      this.teacherId,
      this.marks,
      this.studentList,
      this.uidMarks});
}

class AMfromDB {
  /// title of assignment
  final String? title;

  /// subject
  final String? subject;

  /// Name of teacher who uploaded marks
  final String? teacherName;

  /// DB id of teacher
  final String? teacherId;

  /// A map of student names as keys and marks entered as values
  /// to be uploaded to assignment-marks collection
  Map<String, int>? nameMarks;

  /// A map of student IDs as keys and marks as values
  Map<String, int>? uidMarks;

  /// List of studentrank objects for ui display of names and pics
  List<StudentRank>? studentList;

  /// The max marks of the assignment
  int? totalMarks;

  /// doc Id
  String? docId;

  /// time created
  final DateTime? timeCreated;

  AMfromDB({
    this.timeCreated,
    this.title,
    this.subject,
    this.teacherName,
    this.teacherId,
    this.nameMarks,
    this.studentList,
    this.uidMarks,
    this.totalMarks,
    this.docId,
  });

  factory AMfromDB.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      String t = data['title'] ?? '';
      String? sub = data['subject'];
      Map stmarks = Map<String, int>.from(data['student-marks']) ?? {};
      Map umarks = Map<String, int>.from(data['uid-marks']) ?? {};
      String? teachid = data['uploader-id'];
      String? teacherName = data['uploader'];
      int? totalMarks = data['totalMarks'];
      Timestamp timeCreated = data['time-created'] ?? Timestamp.now();
      DateTime time;
      if (timeCreated != null) {
        time = DateTime.parse(
            timeCreated.toDate().toString() ?? Timestamp.now() as String);
      } else {
        time = DateTime.now();
      }
      return AMfromDB(
        timeCreated: time,
        title: t,
        subject: sub,
        teacherId: teachid,
        teacherName: teacherName,
        nameMarks: stmarks as Map<String, int>?,
        uidMarks: umarks as Map<String, int>?,
        totalMarks: totalMarks,
        docId: doc.id,
      );
    } catch (e) {
      print('error in AMfromDB constructor: $e');
    }
    throw Exception;
  }
}
