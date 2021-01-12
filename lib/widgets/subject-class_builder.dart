import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:tils_app/providers/all_classes.dart';
import 'package:tils_app/models/student.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/widgets/screens/attendance_page.dart';

class SubjectClassBuilder extends StatelessWidget {
  static const routeName = '/student-builder';
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

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<AllClasses>(context);

    CollectionReference _allClassesCollection =
        FirebaseFirestore.instance.collection('classes');
    CollectionReference _allAttCollection =
        FirebaseFirestore.instance.collection('attendance');
    List<SubjectClass> _allClasses = [];

    return StreamBuilder<QuerySnapshot>(
      stream: _allClassesCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error in subject class builder');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        }
        final allDocs = snapshot.data.docs;
        print('all docs instantiated');
        allDocs.forEach((doc) {
          // classProvider.addClassFromCF(doc.id, doc['subjectName']);
          print('$doc.id added');
        });
        return StreamBuilder<QuerySnapshot>(
            stream: _allAttCollection.snapshots(),
            builder: (context, snapshot2) {
              if (snapshot2.hasError) {
                print('Error in subject class builder');
              }
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: CircularProgressIndicator(),
                );
              }
              if (snapshot2.data == null) {
                return Scaffold(
                  body: CircularProgressIndicator(),
                );
              }
              final attendanceDocs = snapshot2.data.docs;
              attendanceDocs.forEach((doc) {
                if (doc.data() != null) {
                  classProvider.addAttFromCF(doc.id, doc.data());
                }
              });
              return AttendancePage();
            });
      },
    );
  }
}
