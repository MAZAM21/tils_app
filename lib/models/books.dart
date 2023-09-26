import 'package:cloud_firestore/cloud_firestore.dart';

class Books {
  String name;
  String author;
  String? category;
  Books({required this.name, required this.author, this.category});

  factory Books.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    final name = data["bookname"] ?? '';
    final author = data["author"] ?? '';
    final category = data["category"] ?? '';

    return Books(name: name, author: author, category: category);
  }
}
