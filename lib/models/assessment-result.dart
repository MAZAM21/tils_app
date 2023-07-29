import 'package:cloud_firestore/cloud_firestore.dart';

class ARStudent {
  final String? name;

  final Map<String?, int>? titleMarks;
  ARStudent({this.name, this.titleMarks});

  factory ARStudent.fromFirebase(
    QueryDocumentSnapshot<Map<String, dynamic>> studentDoc,
    Map<String, String?> idTitles,
    Map<String, int> idL,
  ) {
    try {
      Map<String?, int> titleMarks = {};

      ///cross reference the map of assids and marks with idTitles
      ///and then use idl to calculate marks for each title
      final data = studentDoc.data();

      //from student document,
      //contains assid and total marks
      Map totalMarks = {};
      if (data['Assessment-textqMarks'] != null) {
        totalMarks = {...data['Assessment-textqMarks']};
      } else {
        totalMarks = {'none': 0};
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
            double agmark = (mark / (idL['$id']! * 100) * 100);
            titleMarks.addAll({idTitles['$id']: agmark.toInt()});
          }
        });
      }

      return ARStudent(name: name, titleMarks: titleMarks);
    } catch (e) {
      print('error in arstudent constructor: $e');
    }
    throw Exception;
  }
}
