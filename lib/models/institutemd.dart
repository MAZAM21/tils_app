import 'package:cloud_firestore/cloud_firestore.dart';

class InstituteData {
  final String name;
  final Map<String, Map<String, dynamic>> year_subjects;
  final Map<String, dynamic> ranking_yearSub;
  final List<String> inst_subjects;
  final String instId;
  InstituteData({
    required this.name,
    required this.year_subjects,
    required this.inst_subjects,
    required this.ranking_yearSub,
    required this.instId,
  });

  factory InstituteData.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<dynamic, dynamic>;
      final String name = data['name'];
      final inst_subs = List<String>.from(data['institute_subjects']);
      final year_subjects =
          Map<String, Map<String, dynamic>>.from(data['year_subjects']) ?? {};
      print('in institutedata constructor:${year_subjects}');
      print('inst subs: $inst_subs');
      final ranking_yearSub =
          Map<String, dynamic>.from(data['ranking_yearSub']);
      print(
          'ranking year_sub in institutedata constructor: ${ranking_yearSub}');

      return InstituteData(
        instId: doc.id,
        name: name,
        year_subjects: year_subjects,
        inst_subjects: inst_subs,
        ranking_yearSub: ranking_yearSub,
      );
    } on Exception catch (e) {
      print('error in institutedata.fromfirstore: $e');
    }
    throw Exception();
  }
}
