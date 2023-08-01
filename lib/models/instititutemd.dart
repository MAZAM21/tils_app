import 'package:cloud_firestore/cloud_firestore.dart';

class InstituteData {
  final String name;
  final Map<String, Map<String, dynamic>> year_subjects;
  final List<String> inst_subjects;
  InstituteData({
    required this.name,
    required this.year_subjects,
    required this.inst_subjects,
  });

  factory InstituteData.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<dynamic, dynamic>;
      final String name = data['name'];
      final inst_subs = List<String>.from(['institute_subjects']);
      final year_subjects =
          Map<String, Map<String, dynamic>>.from(data['year_subjects']) ?? {};
      print(year_subjects);

      return InstituteData(
        name: name,
        year_subjects: year_subjects,
        inst_subjects: inst_subs,
      );
    } on Exception catch (e) {
      print('error in institutedata.fromfirstore: $e');
    }
    throw Exception();
  }
}
