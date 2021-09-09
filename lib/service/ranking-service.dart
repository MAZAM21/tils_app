import 'package:flutter/cupertino.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/models/remote_assessment.dart';

import 'package:tils_app/models/student_rank.dart';

import '../models/remote_assessment.dart';

///To-do
/// Attach attendance to score, maybe 15 marks per present, 10 late
/// Important note:
/// If a remote assessment file is deleted from the database, it must also be deleted from student

class RankingService {
  ///this function should branch into to others
  ///one for text qs and the other for mcqs
  ///each function should return an integer which is the score. make that a double.
  List<StudentRank> getStudentScores(
    List<StudentRank> studlist,
    List<RAfromDB> ralist,
  ) {
    try {
      List<StudentRank> sortedStuds = [];
      studlist.forEach((stud) {
        double tqscore = _studentTQScore(stud, ralist) ?? 0;
        double mcqscore = _mcqScore(stud) ?? 0;
        stud.score = tqscore + mcqscore;
      });
      studlist.sort((a, b) => a.score.compareTo(b.score));
      sortedStuds = studlist.reversed.toList();
      List<StudentRank> postionsAdded = _studPositions(sortedStuds);

      return postionsAdded;
    } on Exception catch (e) {
      print('error in getStudentScore ranking service: $e');
    }
    return null;
  }

  List<AssessmentResult> completedAssessmentsParent(
    List<RAfromDB> raList,
    ParentUser parentData,
  ) {
    try {
      List<RAfromDB> compList = [];
      List<AssessmentResult> arList = [];
      Map assidPercMap = _individualPercentages(parentData, raList);
      compList = raList
          .where((ra) => parentData.completedAssessments.contains(ra.id))
          .toList();
      compList.forEach((ra) {
        arList.add(AssessmentResult(
          subject: ra.subject,
          title: ra.assessmentTitle,
          percentage: assidPercMap['${ra.id}'],
        ));
      });
      return arList;
    } on Exception catch (e) {
      print('error in completet assessment parent ranking service: $e');
    }
    return null;
  }

  /// this function is to provide a map of each assessment id as value and overall percentage scored on that assessment
  Map<String, int> _individualPercentages(
    ParentUser pd,
    List<RAfromDB> raList,
  ) {
    try {
      Map<String, int> assidPerc = {};
      final Map mcqRes = pd.mcqMarks;
      final Map textQ = pd.textQMarks;

      raList.forEach((ra) {
        int totalMarks = (ra.allTextQs.length + ra.allMCQs.length) * 100;
        int obtained;

        /// where there are no text qs,
        /// obtained marks will only be taken from mcqs
        if (textQ['${ra.id}'] == null && mcqRes['${ra.id}'] != null) {
          obtained = (mcqRes['${ra.id}'] * 100) ?? 0;
          print('obtained: $obtained');
        } else if (mcqRes['${ra.id}'] == null && textQ['${ra.id}'] != null) {
          obtained = textQ['${ra.id}'];
        } else if (textQ['${ra.id}'] != null && mcqRes['${ra.id}'] != null) {
          obtained = textQ['${ra.id}'] + (mcqRes['${ra.id}'] * 100) ?? 0;
        } else {
          obtained = 0;
        }
        double perc = (obtained / totalMarks) * 100;
        assidPerc['${ra.id}'] = perc.toInt();
      });
      return assidPerc;
    } on Exception catch (e) {
      print('error in _individualPercentages ranking service: $e');
    }
    return null;
  }

  ///For Parent's portal
  StudentRank getSingleStudentPos(List<StudentRank> studlist, String id) {
    StudentRank stud = studlist.firstWhere((s) => s.id == id, orElse: () {
      return null;
    });
    return stud;
  }

  /// studPositions adds the students postion to the studentrank object
  /// if two students have the same score, they will be given the lowest position of the two e.g:
  /// if 4th and 5th have same score, both will be 5th
  /// the function recieves an already sorted list
  List<StudentRank> _studPositions(List<StudentRank> studList) {
    try {
      for (var i = 0; i < studList.length; i++) {
        //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

        studList[i].position = i + 1;
        double s = studList[i].score;

        //to account for same scores we will iterate through the studlist to see where are the other same scores
        //we will only go bellow the current positon as all studs are already sorted
        //once we find same score we just set it to x+1

        for (var x = i + 1; x < studList.length; x++) {
          if (studList[x].score == s) {
            studList[i].position = x + 1;
          }
        }
      }

      return studList;
    } on Exception catch (e) {
      print('error in _studpositn ranking service: $e');
    }
    return null;
  }

  //goes through the list of all completed assessments.
  //for each assement checks number of text qs and calculates percentage attained per assessment and adds to tqscore
  /// first takes l which is length of the list of textqs i.e. the number of text qs
  /// then adds to tqscore the existing score from previous iteration and the textmarks obtained on this divided by l*100

  double _studentTQScore(
    StudentRank stud,
    List<RAfromDB> ralist,
  ) {
    try {
      double tqscore = 0;
      if (stud.completedAssessements.isNotEmpty) {
        stud.completedAssessements.forEach((assid) {
          if (stud.textMarks.isNotEmpty) {
            int l =
                ralist.firstWhere((a) => a.id == assid).allTextQs.length ?? 0;
            //print('${stud.name}');
            if (stud.textMarks['$assid'] != null) {
              tqscore =
                  tqscore + ((stud.textMarks['$assid'] / (l * 100)) * 100) ?? 0;
            }
          }
          //print('assessment id: $assid');
          //print('tqscore: $tqscore');
        });
      }
      return tqscore;
    } on Exception catch (e) {
      print('error in studentTQscore:$e');
    }
    return null;
  }

  /// uses the studrank mcq map to check correctly answered mcqs
  /// each correct answer earns 70 points.
  /// note = correct answer is signified by 1 as value.
  /// there may be an error if the the db function is called again on another attempt of the same assessment

  double _mcqScore(StudentRank stud) {
    try {
      double mcqscore = 0;
      if (stud.mcqMarks.isNotEmpty) {
        stud.mcqMarks.forEach((key, value) {
          if (value > 1) {
            mcqscore = mcqscore + (70 * value);
          }
        });
      }
      return mcqscore;
    } on Exception catch (e) {
      print('error in _mcqScore ranking service: $e');
    }
    return null;
  }

  //main body
}

class AssessmentResult {
  ///This class is created to easily display individual assessment results.
  ///May also be used for assignments.

  final String subject;
  final int percentage;
  final String title;
  AssessmentResult({
    @required this.subject,
    @required this.percentage,
    @required this.title,
  });
}
