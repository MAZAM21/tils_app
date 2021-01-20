import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//class for displaying class records.
class ClassData {
  final Map<String, dynamic> allStudsAtt;
  final String subjectName;
  final DateTime time;
  ClassData(this.allStudsAtt, this.subjectName, this.time);
  factory ClassData.fromFirestore(
      DocumentSnapshot attDoc, DocumentSnapshot classDoc) {
    Map att = attDoc.data();
    String subName = classDoc['subjectName'];
    DateTime t =
        DateFormat("yyyy-MM-dd hh:mm:ss a").parse(classDoc['startTime']);
    return ClassData(att, subName, t);
  }

  int getPresent() {
    int i = 0;
    if (allStudsAtt != null) {
      allStudsAtt.forEach((k, v) {
        if (v == 1) {
          i++;
        }
      });
    }
    return i;
  }
}
