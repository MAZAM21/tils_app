import 'package:tils_app/models/remote_assessment.dart';

import 'package:tils_app/models/student_rank.dart';

import '../models/remote_assessment.dart';

///To-do
/// Attach attendance to score, maybe 15 marks per present, 10 late

class RankingService {
  ///this function should branch into to others
  ///one for text qs and the other for mcqs
  ///each function should return an integer which is the score. make that a double.

  List<StudentRank> getStudentScores(
    List<StudentRank> studlist,
    List<RAfromDB> ralist,
  ) {
    List<StudentRank> sortedStuds = [];
    studlist.forEach((stud) {
      double tqscore = studentTQScore(stud, ralist);
      double mcqscore = mcqScore(stud);
      stud.score = tqscore + mcqscore;
    });
    studlist.sort((a, b) => a.score.compareTo(b.score));
    sortedStuds = studlist.reversed.toList();
    List<StudentRank> postionsAdded = studPositions(sortedStuds);


    return postionsAdded;
  }

  /// studPositions adds the students postion to the studentrank object
  /// if two students have the same score, they will be given the lowest position of the two e.g:
  /// if 4th and 5th have same score, both will be 5th
  /// the function recieves an already sorted list
  /// 
  List<StudentRank> studPositions(List<StudentRank> studList) {
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
  }

  //goes through the list of all completed assessments.
  //for each assement checks number of text qs and calculates percentage attained per assessment and adds to tqscore
  /// first takes l which is length of the list of textqs i.e. the number of text qs
  /// then adds to tqscore the existing score from previous iteration and the textmarks obtained on this divided by l*100

  double studentTQScore(
    StudentRank stud,
    List<RAfromDB> ralist,
  ) {
    try {
      double tqscore = 0;
      if (stud.completedAssessements.isNotEmpty) {
        stud.completedAssessements.forEach((assid) {
          if (stud.textMarks != null) {
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

  double mcqScore(StudentRank stud) {
    double mcqscore = 0;
    if (stud.mcqMarks.isNotEmpty) {
      stud.mcqMarks.forEach((key, value) {
        if (value == 1) {
          mcqscore = mcqscore + 70;
        }
      });
    }
    return mcqscore;
  }
}
