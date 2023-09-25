import 'package:cloud_firestore/cloud_firestore.dart';

class Books {
  String name;
  String author;
  Books({required this.name, required this.author});

  factory Books.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    final name = data["bookname"];
    final author = data["author"];

    return Books(name: name, author: author);
  }
}
