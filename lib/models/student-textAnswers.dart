import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTextAns {
  final Map<String, String> qaMap;
  final String studentId;
  final String name;
  Map<String, int> qMarks;

  StudentTextAns(
    this.qaMap,
    this.studentId,
    this.name, [
    this.qMarks,
  ]);
  factory StudentTextAns.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      final String name = data['name'] ?? '';
      final Map dbMap = {...data['TQAs']} ?? '';
      Map marks = {...data['TQMarks']} ?? {};
      Map<String, int> qMarks = {};
      Map<String, String> qas = {};
      if (dbMap.isNotEmpty) {
        dbMap.forEach((q, a) {
          qas['$q'] = a;
        });
      }
      if (marks.isNotEmpty) {
        marks.forEach((q, m) {
          qMarks['$q'] = m.toInt();
        });
      }
      print(name);
      return StudentTextAns(qas, doc.id, name, qMarks);
    } catch (e) {
      // TODO
      print('err in student text ans: $e');
    }
    return null;
  }
}
