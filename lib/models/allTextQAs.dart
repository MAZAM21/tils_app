import 'package:cloud_firestore/cloud_firestore.dart';

class TextQAs {
  final String subject;
  final String assId;
  final String assTitle;
  final bool marked;
  final bool isText;
  TextQAs(this.subject, this.assId, this.assTitle, this.marked, this.isText);
  factory TextQAs.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      bool isMarked = data['marked'] ?? false;

      final sub = data['subject'];
      final title = data['title'];
      bool isText = data['isText'] ?? false;
      print(isText);

      return TextQAs(sub,doc.id, title, isMarked, isText);
    } catch (e) {
      print('error in TextQAs: $e');
    }
    return null;
  }
}
