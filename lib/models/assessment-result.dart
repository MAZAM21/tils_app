import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tils_app/service/db.dart';

class ARDataGrid {
  /// this class will be used to display the assessment result data in SFGrid.
  /// rows will be student, columns will be assessments
  ///  for each student, we need all assessments and marks for each assessment.
  /// the object will represent all assessment results of a single subject

  /// assessmentData will contain a map of string key which is assessment name
  /// with value being a map of student name and marks
  Map<String, int> assessmentData = {};
  final String subject;
  final String assessmentTitle;
  final String assid;

  ARDataGrid({
    this.assessmentData,
    @required this.subject,
    @required this.assessmentTitle,
    @required this.assid,
  });

  factory ARDataGrid.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data();
    final title = data['title'];
    final subject = data['subject'];
    return ARDataGrid(assessmentTitle: title, subject: subject, assid: doc.id);
  }
}

class ARStudent {
  final String name;

  final Map<String, int> titleMarks;
  ARStudent({this.name, this.titleMarks});

  factory ARStudent.fromFirebase(
    QueryDocumentSnapshot studentDoc,
    Map<String, String> idTitles,
    Map<String, int> idL,
  ) {
    try {
      Map<String, int> titleMarks = {};

      ///cross reference the map of assids and marks with idTitles
      ///and then use idl to calculate marks for each title
      final data = studentDoc.data();

      //from student document,
      //contains assid and total marks
      Map totalMarks = {};
      if (data['Assessment-textqMarks'] != null) {
        totalMarks = {...data['Assessment-textqMarks']} ?? {};
      } else{
        totalMarks ={'none': 0};
      }
      
      final name = data['name'] ?? '';
      
      ///if total marks is not empty
      ///for each mark 
      ///if assid is present in the idTitle map taken from results document
      ///calculate aggregate
      ///add to the map containg all titles and marks
      if (totalMarks.isNotEmpty) {
        totalMarks.forEach((id, mark) {
          if (idTitles.containsKey(id)) {
            // print(id);
            double agmark = (mark / (idL['$id'] * 100) * 100);
            titleMarks.addAll({idTitles['$id']: agmark.toInt()});
          }
        });
      }

      return ARStudent(name: name, titleMarks: titleMarks);
    } catch (e) {
      print('error in arstudent constructor: $e'); // TODO
    }
    return null;
  }
}
