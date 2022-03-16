import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudentAnswers {
  //Map of MCQ as key and answer as value
  Map<String, dynamic> mcqAnsMap;

  // a map of questions as keys and answers as values
  Map<String, String> tqaMap;

  //a map of qs as keys and marks as values
  Map<String, int> qMarks;

  //bool value to determine whether assessment has mcqs
  final bool isMcq;

  //Total correct mcqs
  int mcqMarks;

  //total text q marks
  int totalQMarks;

  //student firebase collection id
  final String studentId;

  //student name
  final String name;

  StudentAnswers({
    this.isMcq,
    @required this.studentId,
    @required this.name,
    this.mcqAnsMap,
    this.mcqMarks,
    this.qMarks,
    this.tqaMap,
    this.totalQMarks,
  });

  factory StudentAnswers.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      final id = doc.id;
      String name = data['name'] ?? '';

      Map<String, dynamic> mcqAnsMap = {};
      Map<String, String> qas = {};
      Map<String, int> qMarks = {};
      int marks = 0;
      int tqMarks =0;

      if (data.containsKey('TQMarks')) {
        Map tQmarks = {...data['TQMarks']} ?? {};
        if (tQmarks != null) {
          tQmarks.forEach((q, m) {
            qMarks['$q'] = m.toInt() ?? 0;
          });
          tqMarks = tQmarks.values.fold(0, (a, b) => a + b);
        }

      }

      if (doc.data().containsKey('MCQAns')) {
        Map mcqAns = {...data['MCQAns']} ?? {};
        if (mcqAns.isNotEmpty) {
          mcqAns.forEach((mcq, ans) {
            // print(mcq);
            // print(ans);
            mcqAnsMap['$mcq'] = ans;
          });
        }
      }

      if (data.containsKey('MCQmarks')) {
        marks = data['MCQmarks'] ?? 0;
      }

      if (data.containsKey('TQAs')) {
        Map dbMap = {...data['TQAs']} ?? {};
        if (dbMap != null) {
          dbMap.forEach((q, a) {
            qas['$q'] = a;
          });
        }
      }

      bool isMCQ = false;

      ///check whether there are mcq and then
      ///make isMcq true. if its true, the result
      ///will be displayed
      if (mcqAnsMap.isNotEmpty) {
        isMCQ = true;
      }

      return StudentAnswers(
        isMcq: isMCQ,
        mcqAnsMap: mcqAnsMap,
        mcqMarks: marks,
        name: name,
        studentId: id,
        qMarks: qMarks,
        tqaMap: qas,
        totalQMarks: tqMarks,
      );
    } on Exception catch (e) {
      print('error in student-answers model: $e');
    }
    return null;
  }
}
