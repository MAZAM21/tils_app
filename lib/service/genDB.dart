import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/parent-user-data.dart';
import 'package:SIL_app/models/role.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralDatabase with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<Role> getRole(String uid) async {
    try {
      print('getting role in db: $uid');
      CollectionReference ref = _db.collection('users');
      DocumentSnapshot query = await ref.doc(uid).get();
      Role role = Role.fromFirestore(query);
      return role;
    } on Exception catch (e) {
      print('error in getrole gendb: $e');
    }
    throw Exception();
  }

  Stream<User?> authStateStream() {
    return auth.authStateChanges();
  }

  Stream<TeacherUser> streamTeacherUser(String? uid, String? instID) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('teachers');
    return ref.snapshots().map((list) => TeacherUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Stream<ParentUser> streamParentUser(String? uid, String? instID) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('students');
    return ref.snapshots().map((list) => ParentUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['parent-uid'] == uid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Stream<StudentUser> streamStudentUser(String? uid, String? instID) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('students');
    return ref.snapshots().map((list) => StudentUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Future<InstituteData?> getInstituteDataforAllTabs(
      String? instIDfromTDS) async {
    if (instIDfromTDS != null) {
      DocumentReference ref = _db.collection('institutes').doc(instIDfromTDS);
      try {
        print('in getinsititutedataforalltabs: ${ref.id}');
        final instDataDoc = await ref.get();
        return InstituteData.fromFirestore(instDataDoc);
      } catch (e) {
        print('error in getInstituteData: ${e}');
      }
      throw Exception('try catch error in streaminstdataforalltabs');
    } else {
      throw Exception('in getinstitutedata alltabs error');
    }
  }
}
