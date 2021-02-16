import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoteAssessment with ChangeNotifier {
  DateTime timeAdded;
  DateTime deployTime;
  DateTime deadline;
  String subject;
  String teacherId;
  String assessmentTitle;
  List<MCQ> allMCQs;
  List<String> allTextQs = [];

  RemoteAssessment({
    this.timeAdded,
    this.subject,
    this.teacherId,
    this.allMCQs,
    this.allTextQs,
    this.assessmentTitle,
  });
  void addMCQ(MCQ mcq) {
    allMCQs.add(mcq);
    print('${allMCQs.length}');
    notifyListeners();
  }

  // key is the question. the value map has a key of option category and value is the option.
  Map returnMcqs() {
    Map<String, Map<String, String>> mcqMap = {};
    allMCQs.forEach((mcq) {
      mcqMap.addAll({'${mcq.question}': mcq.answerChoices});
    });
    return mcqMap;
  }

  void deleteMCQ(MCQ mcq) {
    allMCQs.remove(mcq);
    notifyListeners();
  }
}

class MCQ with ChangeNotifier {
  Map answerChoices = {};
  String question;
  MCQ({this.question, this.answerChoices});
}

class RAfromDB {
  final String id;
  final DateTime timeAdded;
  final String subject;
  final String teacherId;
  final String assessmentTitle;
  DateTime startTime;
  DateTime endTime;
  List<MCQ> allMCQs = [];
  List allTextQs = [];
  bool isDeployed;

  RAfromDB({
    this.id,
    this.timeAdded,
    this.subject,
    this.teacherId,
    this.assessmentTitle,
    this.allMCQs,
    this.allTextQs,
    this.startTime,
    this.endTime,
    this.isDeployed,
  });

  factory RAfromDB.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      final mcqs = Map<String, dynamic>.from(data['MCQs']);
      final textQs = List<String>.from(data['TextQs']);
      List<MCQ> converted = [];
      Timestamp startTime = data['startTime'];
      Timestamp endTime = data['endTime'];
      Timestamp time = data['timeCreated'];
      DateTime d = DateTime.parse(time.toDate().toString());
      DateTime start;
      DateTime end;
      bool isDep;
      //print(startTime);
      if (startTime != null && endTime != null) {
        start =
            DateTime.parse(startTime.toDate().toString() ?? Timestamp.now());
        end = DateTime.parse(endTime.toDate().toString() ?? Timestamp.now());
      }
      mcqs.forEach((q, a) {
        converted.add(MCQ(question: q, answerChoices: a));
      });

      if (start.isBefore(DateTime.now()) && end.isAfter(DateTime.now())) {
        isDep = true;
      } else {
        isDep = false;
      }
      print(isDep);
      //print('constructor called for: ${data['title']}');
      return RAfromDB(
        id: doc.id,
        timeAdded: d,
        subject: data['subject'],
        teacherId: data['id'],
        assessmentTitle: data['title'],
        allMCQs: converted,
        allTextQs: textQs,
        startTime: start != null ? start : null,
        endTime: end != null ? end : null,
        isDeployed: isDep
      );
    } catch (e) {
      print('err in rafromdb constructor: $e');
      // TODO
    }
    return null;
  }
}
