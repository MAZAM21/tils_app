import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/student.dart';

import 'package:firebase_auth/firebase_auth.dart';

class StudentDB with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
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

  //get all student docs from student collection
  Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot ref = await _db.collection('students').get();
      return ref.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('err in getallstudents $err');
    }
    return null;
  }

  //adds profile picture download url to users collection
  //the reason for not adding to student's collection is because the uid referst to the document name in users and because we need it globally.
  Future<void> addProfileURL(String url, String uid) async {
    DocumentReference userRef = _db.collection('users').doc('$uid');
    QuerySnapshot stuQuery = await _db
        .collection('students')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    try {
      await userRef.set({'profile-pic-url': url}, SetOptions(merge: true));
      await stuQuery.docs.first.reference.set(
        {'profile-pic-url': url},
        SetOptions(merge: true),
      );
    } catch (err) {
      print('error in addProfileURL');
    }
  }
}
