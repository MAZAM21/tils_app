import 'dart:math';

import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject.dart';

class StudentService {

  /// 
  List<SubjectClass> getMarkedClasses(List<SubjectClass> allClasses, Map att) {
    List<SubjectClass> marked = [];
    allClasses.forEach((element) {
      if (att.containsKey(element.id)) {
        marked.add(element);
      }
    });
    marked.sort((a, b) => b.startTime.compareTo(
        a.startTime)); // easy sorting of dates. Use in attendance grid as well
    return marked;
  }

  /// Student Get classes for timetable
  List<Meeting> getMyClassesForTT(
    List<Meeting> allClasses,
    List subs,
  ) {
    List<Meeting> myClasses = [];
    allClasses.forEach((cls) {
      if (subs.contains(cls.eventName)) {
        myClasses.add(cls);
      }
    });
    return myClasses;
  }

  Map<String, List<RAfromDB>> getRAForStud(
    StudentUser userData,
    List<RAfromDB> ras,
  ) {
    ///function returns a map containing subjects registered against user and all assessments for that particular subject
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
    //tl is total length of assessment q maps
    int tl = ra.allMCQs.length + ra.allTextQs.length;
    if (index < ra.allMCQs.length) {
      return ra.allMCQs[index].answerChoices;
    }
    if (index >= tl) {
      return null;
    }
    return null;
  }

  List<SubjectClass> orderSubjectClass(List<SubjectClass> listIn) {
    final list = listIn;
    for (int i = 0; i < list.length; i++) {
      SubjectClass temp = list[i];
      for (int z = 0; z < list.length; z++) {
        SubjectClass tempZ = list[z];
        if (z != i && list[i].startTime.isBefore(list[z].startTime)) {
          list[i] = list[z];
          list[z] = temp;
          temp = tempZ;
        }
      }
    }
    return list.toList();
  }

  List<SubjectClass> getMyClasses(
    List<SubjectClass> all,
    List subs,
    String section,
  ) {
    List<SubjectClass> myClasses = [];
    var now = DateTime.now();
    all.forEach((cls) {
      if (subs.contains(cls.subjectName) &&
          cls.section == section &&
          cls.startTime.isAfter(now)) {
        myClasses.add(cls);
      }
    });
    return orderSubjectClass(myClasses);
  }

  String getPendingAssessmentNum(List comp, List<RAfromDB> all) {
    int a = 0;
    all.forEach((ra) {
      if (!comp.contains(ra.id)) {
        a++;
      }
    });
    return a.toString();
  }
}
