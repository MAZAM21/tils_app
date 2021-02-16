import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tils_app/widgets/student-screens/student_RA/assessment-page.dart';

class AssessmentResult {
  //student name
  final String studentName;

  //assessment name
  final String assName;

  //assessment Id
  final String assId;

  //assessment subject
  final String assSub;

  //text questions and answers map
  final Map<String, String> qaMap;

  //text questions marks
  final Map<String, double> qaMarks;

  //all mcqs
  final int totalMCQs;

  //correctly chosen
  final int correctMCQs;

  AssessmentResult(
    this.studentName,
    this.assName,
    this.assId,
    this.assSub, [
    this.qaMap,
    this.qaMarks,
    this.correctMCQs,
    this.totalMCQs,
  ]);

  factory AssessmentResult.fromFirestore(QueryDocumentSnapshot doc){
    final data = doc.data();
    
    
    return AssessmentResult();
  }
}
