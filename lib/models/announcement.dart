import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String? title;
  final String? body;
  final String? id;
  final String? category;
  final DateTime? time;
  Announcement([this.title, this.body, this.time, this.id, this.category]);
  factory Announcement.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    Timestamp time = data['dateTime'];
    String? title = data['title'];
    String? body = data['body'];
    String? category = data['category'];
    DateTime d = DateTime.parse(time.toDate().toString());
    return Announcement(title, body, d, doc.id, category);
  }
}
