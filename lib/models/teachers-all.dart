import 'package:cloud_firestore/cloud_firestore.dart';

class AllTeachers {
  final String? name;
  final String? year;
  final List? subjects;
  final bool? isAdmin;
  final String? section;
  final String id;

  AllTeachers({
    required this.name,
    required this.year,
    required this.subjects,
    required this.isAdmin,
    required this.section,
    required this.id,
  });

  factory AllTeachers.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<dynamic, dynamic>;

    final name = data['name'] ?? '';
    final year = data['year'] ?? '';
    final isAdmin = data['isAdmin'] ?? '';
    final Map registeredSubs = {...data['registeredSubs'] ?? {}};
    final section = data['section'] ?? '';
    print('teacher name: $name');
    List subjects = [];
    registeredSubs.forEach((k, v) {
      if (v == true) {
        subjects.add(k);
      }
    });
    print('teacher subs: $subjects');
    return AllTeachers(
        id: doc.id,
        name: name,
        year: year,
        subjects: subjects,
        isAdmin: isAdmin,
        section: section);
  }
}
