import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/class-data.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/models/student.dart';
import '../models/meeting.dart';
import '../models/subject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //gets classes collection data and converts to Meeting list for TT
  Stream<List<Meeting>> streamMeetings() {
    CollectionReference ref = _db.collection('classes');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Meeting.fromFirestore(doc)).toList());
  }

  //gets classes collection data and converts to subjectclass for attendance
  Stream<List<SubjectClass>> streamClasses() {
    CollectionReference ref = _db.collection('classes');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => SubjectClass.fromFirestore(doc)).toList());
  }

  //gets attendance collection and converts to attendance for attendance status
  Stream<List<Attendance>> streamAttendance() {
    CollectionReference ref = _db.collection('attendance');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Attendance.fromFirestore(doc)).toList());
  }

  //gets auth state stream
  Stream<User> authStateStream() {
    return auth.authStateChanges();
  }

  //gets students collection data as per the registeration status of student
  Future<List<Student>> getStudentsBySub(String subName) async {
    CollectionReference ref = _db.collection('students');
    try {
      QuerySnapshot query =
          await ref.where('registeredSubs.$subName', isEqualTo: true).get();
      return query.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('error in getstudbysub $err');
    }
    return null;
  }

  Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot ref = await _db.collection('students').get();
      return ref.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('err in getallstudents $err');
    }
    return null;
  }

  //adds attendance status to database in attendance and individual student document
  Future<void> addAttToCF(String name, int status, String id) async {
    CollectionReference ref = _db.collection('attendance');
    CollectionReference studentRef = _db.collection('students');
    try {
      QuerySnapshot q =
          await studentRef.where('studentName', isEqualTo: '$name').get();
      DocumentSnapshot stDoc = q.docs.firstWhere((doc) {
        return doc['studentName'] == '$name';
      });
      studentRef.doc(stDoc.id).set({
        'attendance': {'$id': status}
      }, SetOptions(merge: true));
      return ref.doc(id).set({'$name': status}, SetOptions(merge: true));
    } catch (err) {
      print('error in addAtttoCF $err');
    }
  }

  //adds class name and date to att page
  Future<void> addClassDetailToAttColl(
    String className,
    String id,
    DateTime date,
  ) async {
    String dateString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(date);
    try {
      CollectionReference ref = _db.collection('attendance');
      return await ref.doc(id).set(
          {'subName': className, 'classDate': dateString},
          SetOptions(merge: true));
    } catch (err) {
      print('err in addclassdetail $err');
    }
  }

  //gets user role as string
  Future<Role> getRole(String uid) async {
    CollectionReference ref = _db.collection('users');
    DocumentSnapshot query = await ref.doc(uid).get();
    Role role = Role.fromFirestore(query);
    return role;
  }

  //adds class data from edit tt to cf
  Future<void> addToCF(
    SubjectName name,
    DateTime start,
    DateTime end,
  ) async {
    final _classCollection = _db.collection('classes');
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

  //adds edited class to cf
  Future<void> editInCF(
    String id,
    String name,
    DateTime start,
    DateTime end,
  ) async {
    final _classCollection = _db.collection('classes');
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

  Future<ClassData> getClassRecord(String id) async {
    DocumentSnapshot attDoc = await _db.collection('attendance').doc(id).get();
    DocumentSnapshot classDoc = await _db.collection('classes').doc(id).get();
    ClassData cd = ClassData.fromFirestore(attDoc, classDoc);
    return cd;
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
