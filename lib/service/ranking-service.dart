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
   int attendancePercentage(StudentRank stud) {
    Map att = stud.attendance;
    double perc = 0;
    int presents = 0;
    int all = att.length;
    att.forEach((key, value) {
      if (value == 1 || value == 2) {
        presents++;
      }
    });

    perc = (presents / all) * 100;
    if (perc.isNaN) {
      return 0;
    }

    print('perc: $perc');
    int pint = perc.toInt();
    print('pint: $pint');
    return pint;
  }

  /// number of presents
   int presents(Map att) {
    int p = 0;
    att.forEach((key, value) {
      if (value == 1) {
        p++;
      }
    });
    return p;
  }

  /// number of lates
  int lates(Map att) {
    int l = 0;
    att.forEach((key, value) {
      if (value == 2) {
        l++;
      }
    });
    return l;
  }

  /// number of absents
  int absents(Map att) {
    int a = 0;
    att.forEach((key, value) {
      if (value == 3) {
        a++;
      }
    });
    return a;
  }

  List<StudentRank> getStudentAssignmentScore(List<StudentRank> studlist) {
    studlist.sort((a, b) => b.assignmentScore.compareTo(a.assignmentScore));
    for (var i = 0; i < studlist.length; i++) {
      //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

      studlist[i].position = i + 1;
      double s = studlist[i].assignmentScore;

      for (var x = i + 1; x < studlist.length; x++) {
        if (studlist[x].assignmentScore == s) {
          studlist[i].position = x + 1;
        }
      }
    }

    return studlist;
  }

  List<StudentRank> getStudentBySub(String sub, List<StudentRank> studList) {
    List<StudentRank> studSubs = [];
    studList.forEach((stud) {
      if (stud.subjects.contains(sub) && stud.raSubScore.containsKey('$sub')) {
        studSubs.add(stud);
      }
    });
    studSubs
        .sort((a, b) => b.raSubScore['$sub'].compareTo(a.raSubScore['$sub']));

    for (var i = 0; i < studSubs.length; i++) {
      //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

      studSubs[i].position = i + 1;
      int s = studSubs[i].raSubScore['$sub'];

      //to account for same scores we will iterate through the studlist to see where are the other same scores
      //we will only go bellow the current positon as all studs are already sorted
      //once we find same score we just set it to x+1

      for (var x = i + 1; x < studSubs.length; x++) {
        if (studSubs[x].raSubScore['$sub'] == s) {
          studSubs[i].position = x + 1;
        }
      }
    }
    return studSubs;
  }

  List<StudentRank> getStudentYearScore(
    String year,
    List<StudentRank> studlist,
  ) {
    List<StudentRank> yearList = [];
    studlist.forEach((stud) {
      if (stud.year == year) {
        yearList.add(stud);
      }
    });

    yearList.sort((a, b) => b.yearScore.compareTo(a.yearScore));

    for (var i = 0; i < yearList.length; i++) {
      //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

      yearList[i].position = i + 1;
      double s = yearList[i].yearScore;

      //to account for same scores we will iterate through the studlist to see where are the other same scores
      //we will only go bellow the current positon as all studs are already sorted
      //once we find same score we just set it to x+1

      for (var x = i + 1; x < yearList.length; x++) {
        if (yearList[x].yearScore == s) {
          yearList[i].position = x + 1;
        }
      }
    }
    return yearList;
  }

  List<StudentRank> getStudentAttendanceScore(List<StudentRank> studlist) {
    List<StudentRank> attList = studlist;
    attList.sort((a, b) => b.attendanceScore.compareTo(a.attendanceScore));

    for (var i = 0; i < attList.length; i++) {
      //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

      attList[i].position = i + 1;
      double s = attList[i].attendanceScore;

      //to account for same scores we will iterate through the studlist to see where are the other same scores
      //we will only go bellow the current positon as all studs are already sorted
      //once we find same score we just set it to x+1

      for (var x = i + 1; x < attList.length; x++) {
        if (attList[x].attendanceScore == s) {
          attList[i].position = x + 1;
        }
      }
    }

    return attList;
  }

  List<AssessmentResult> completedAssessmentsParent(
    List<RAfromDB> raList,
    ParentUser parentData,
  ) {
    try {
      List<RAfromDB> compList = [];
      List<AssessmentResult> arList = [];
      
     
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

  // / studPositions adds the students postion to the studentrank object
  // / if two students have the same score, they will be given the lowest position of the two e.g:
  // / if 4th and 5th have same score, both will be 5th
  // / the function recieves an already sorted list
  // List<StudentRank> _studPositions(List<StudentRank> studList) {
  //   try {
  //     for (var i = 0; i < studList.length; i++) {
  //       //by default postion is i + 1 since list is sorted. if all scores are unique this will suffice.

  //       studList[i].position = i + 1;
  //       double s = studList[i].score;

  //       //to account for same scores we will iterate through the studlist to see where are the other same scores
  //       //we will only go bellow the current positon as all studs are already sorted
  //       //once we find same score we just set it to x+1

  //       for (var x = i + 1; x < studList.length; x++) {
  //         if (studList[x].score == s) {
  //           studList[i].position = x + 1;
  //         }
  //       }
  //     }

  //     return studList;
  //   } on Exception catch (e) {
  //     print('error in _studpositn ranking service: $e');
  //   }
  //   return null;
  // }

  //goes through the list of all completed assessments.
  //for each assement checks number of text qs and calculates percentage attained per assessment and adds to tqscore
  /// first takes l which is length of the list of textqs i.e. the number of text qs
  /// then adds to tqscore the existing score from previous iteration and the textmarks obtained on this divided by l*100

 
  /// uses the studrank mcq map to check correctly answered mcqs
  /// each correct answer earns 70 points.
  /// note = correct answer is signified by 1 as value.
  /// there may be an error if the the db function is called again on another attempt of the same assessment

 

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
