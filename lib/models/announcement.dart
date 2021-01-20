import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String title;
  final String body;
  final String id;
  final DateTime time;
  Announcement(this.title, this.body, this.time, this.id);
  factory Announcement.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    Timestamp time = data['dateTime'];
    DateTime d = DateTime.parse(time.toDate().toString());
    return Announcement(data['title'], data['body'], d, doc.id);
  }
}
