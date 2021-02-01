import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';

class StudentService {
  Map<String, List<RAfromDB>> getRAForStud(
    StudentUser userData,
    List<RAfromDB> ras,
  ) {
    Map<String, List<RAfromDB>> filtered = {};
    ras.forEach((ra) {
      if (userData.subjects.contains(ra.subject) && ra != null) {
        filtered.update('${ra.subject}', (list) {
          list.add(ra);
          return list;
        }, ifAbsent: () {
          return [ra];
        });
      }
    });
    return filtered;
  }

  String getQuestion(RAfromDB ra, int index) {
    /* 1. need to extract all questions*/
    List<String> textQs = ra.allTextQs;
    List<MCQ> mcqs = ra.allMCQs;
    List<String> mcqQs = [];
    mcqs.forEach((mcq) {
      mcqQs.add(mcq.question);
    });
    if (index < mcqQs.length) {
      return mcqQs[index];
    } else if (index >= mcqQs.length &&
        index < (textQs.length + mcqQs.length)) {
      return textQs[index - mcqQs.length];
    }
    if (index >= textQs.length) {
      return null;
    }
    return null;
  }

  Map getAnswers(RAfromDB ra, int index) {
    int tl = ra.allMCQs.length + ra.allTextQs.length;
    if (index < ra.allMCQs.length) {
      
      return ra.allMCQs[index].answerChoices;
    }
    if (index >= tl) {
      return null;
    }
    return null;
  }
}
