import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoteAssessment with ChangeNotifier {
  DateTime timeAdded;
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
  Map<String, String> answerChoices = {};
  String question;
  MCQ({this.question, this.answerChoices});
}

class RAfromDB {
  final String id;
  final DateTime timeAdded;
  final String subject;
  final String teacherId;
  final String assessmentTitle;
  List<MCQ> allMCQs;
  List<String> allTextQs = [];
  RAfromDB(
      {this.id,
      this.timeAdded,
      this.subject,
      this.teacherId,
      this.assessmentTitle,
      this.allMCQs,
      this.allTextQs});

  factory RAfromDB.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data();
    List<Map> mcqList = data['MCQs'];
    List<String> textQs = data['TextQs'];
    List<MCQ> converted = [];
    Timestamp time = data['timeCreated'];
    DateTime d = DateTime.parse(time.toDate().toString());

    mcqList.forEach((mcqMap) {
      converted.add(MCQ(
        question: mcqMap.keys.first as String,
        answerChoices: mcqMap.values.first as Map,
      ));
    });

    return RAfromDB(
      id: doc.id,
      timeAdded: d,
      subject: data['subject'],
      teacherId: data['id'],
      assessmentTitle: data['title'],
      allMCQs: converted,
      allTextQs: textQs,
    );
  }
}
