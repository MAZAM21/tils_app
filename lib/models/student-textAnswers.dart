import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTextAns {
  // a map of questions as keys and answers as values
  final Map<String, String> qaMap;

  //student firebase collection id
  final String studentId;

  //student name
  final String name;

  //a map of qs as keys and marks as values
  Map<String, int?>? qMarks;

  //bool indicating marking status
  bool marked;

  StudentTextAns(
    this.qaMap,
    this.studentId,
    this.marked,
    this.name, [
    this.qMarks,
  ]);
  factory StudentTextAns.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    ///if Tqas not empty creates map
    ///if marks not empty creates map

    try {
      final data = doc.data();
      final String name = data['name'] ?? '';
      final Map dbMap = {...data['TQAs']};
      Map marks = {...data['TQMarks']};
      Map<String, int?> qMarks = {};
      Map<String, String> qas = {};
      bool marked = false;
      if (dbMap.isNotEmpty) {
        dbMap.forEach((q, a) {
          qas['$q'] = a;
        });
      }
      if (marks.isNotEmpty) {
        marked = true;
        marks.forEach((q, m) {
          qMarks['$q'] = m.toInt();
        });
      } else if (marks.isEmpty) {
        marked = false;
      }
      //print(name);
      return StudentTextAns(qas, doc.id, marked, name, qMarks);
    } catch (e) {
      print('err in student text ans: $e');
    }
    throw Exception;
  }
}
