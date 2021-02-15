import 'package:cloud_firestore/cloud_firestore.dart';

class TextQAs {
  final String assId;
  final String assTitle;
  final bool marked;
  final bool isText;
  TextQAs(this.assId, this.assTitle, this.marked, this.isText);
  factory TextQAs.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      bool isMarked = data['marked'] ?? false;
    

      final title = data['title'];
      bool isText = data['isText'] ?? false;
      print(isText);

      return TextQAs(doc.id, title, isMarked, isText);
    } catch (e) {
      print('error in TextQAs: $e');
    }
    return null;
  }
}
