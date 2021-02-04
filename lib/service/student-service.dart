import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';

class StudentService {
  Map<String, List<RAfromDB>> getRAForStud(
    StudentUser userData,
    List<RAfromDB> ras,
  ) {
    //function returns a map containing subjects registered against user and all assessments for that particular subject
    Map<String, List<RAfromDB>> filtered = {};
    //iterating through each ra.
    ras.forEach((ra) {
      //if userdata reg subs contains subject of this particular ra
      if (userData.subjects.contains(ra.subject) && ra != null) {
        //add the ra to the list of assessments in value. key is the string sub name. 
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
