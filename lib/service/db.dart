import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/models/student.dart';
import '../providers/all_classes.dart';
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

  Stream<User> authStateStream() {
    return auth.authStateChanges();
  }

  //gets students collection data as per the registeration status of student
  Future<List<Student>> getStudentsBySub(String subName) async {
    CollectionReference ref = _db.collection('students');
    QuerySnapshot query =
        await ref.where('registeredSubs.$subName', isEqualTo: true).get();
    return query.docs.map((doc) => Student.fromFirestore(doc)).toList();
  }

  //adds attendance status to database
  Future<void> addAttToCF(String name, int status, String id) {
    CollectionReference ref = _db.collection('attendance');
    return ref.doc(id).set({'$name': status}, SetOptions(merge: true));
  }
  //gets user role as string
  Future<Role> getRole(String uid)async{
    CollectionReference ref = _db.collection('users');
    DocumentSnapshot query = await ref.doc(uid).get();
    Role role = Role.fromFirestore(query);
    return role ;
  }

}
