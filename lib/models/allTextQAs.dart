import 'package:cloud_firestore/cloud_firestore.dart';

class TextQAs {
  final String? subject;
  final String assId;
  final String? assTitle;
  final bool marked;
  final bool isText;
  TextQAs(this.subject, this.assId, this.assTitle, this.marked, this.isText);
  factory TextQAs.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();

      final sub = data['subject'];
      final title = data['title'];
      bool isText = false;

      if (data['isText'] == null) {
        isText = false;
      } else if (data['isText'] == true) {
        isText = true;
      } else {
        isText = false;
      }

      //print(isText);

      return TextQAs(sub, doc.id, title, false, isText);
    } catch (e) {
      print('error in TextQAs: $e');
    }
    throw Exception;
  }
}
