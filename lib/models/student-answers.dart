import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudentAnswers {
  //Map of MCQ as key and answer as value
  Map<String, String> mcqAnsMap;

  // a map of questions as keys and answers as values
  Map<String, String> tqaMap;

  //a map of qs as keys and marks as values
  Map<String, int> qMarks;

  //bool value to determine whether assessment has mcqs
  final bool isMcq;

  //Total correct mcqs
  int mcqMarks;

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
  });

  factory StudentAnswers.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();

      final Map mcqAns = Map<String, dynamic>.from(data['MCQAns']) ?? {};
      final id = doc.id;
      final String name = data['name'] ?? {};
      final int marks = data['MCQmarks'] ?? {};
      final Map dbMap = {...data['TQAs']} ?? {};
      Map TQmarks = {...data['TQMarks']} ?? {};

      Map<String, int> qMarks = {};
      Map<String, String> qas = {};

      if (dbMap.isNotEmpty) {
        dbMap.forEach((q, a) {
          qas['$q'] = a;
        });
      }
      if (TQmarks.isNotEmpty) {
        TQmarks.forEach((q, m) {
          qMarks['$q'] = m.toInt();
        });
      }

      bool isMCQ = false;

      ///check whether there are mcq and then
      ///make isMcq true. if its true, the result
      ///will be displayed
      if (mcqAns.isNotEmpty) {
        isMCQ = true;
      }

      return StudentAnswers(
        isMcq: isMCQ,
        mcqAnsMap: mcqAns,
        mcqMarks: marks,
        name: name,
        studentId: id,
        qMarks: qMarks,
        tqaMap: qas,
      );
    } on Exception catch (e) {
      print('error in student-answers model: $e');
    }
    return null;
  }
}
