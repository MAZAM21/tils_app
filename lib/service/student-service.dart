import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject-class.dart';

class StudentService {
  ///Get attendance percentage
  ///The idea here is that we only need to consider marked attendance.
  ///We need not take into account all classes of the student because
  ///if the stud is absent then he will be marked absent by teacher and the
  ///attendance map will show it
  int attendancePercentage(StudentUser sd) {
    Map att = sd.attendance;
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

  /// num present
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

  ///Gets top three classes for which attendance would have been marked
  ///to display on homepage attendance panel of student
  List<SubjectClass> getTopThreeAtt(
      List<SubjectClass> classList, StudentUser stud) {
    List<SubjectClass> req = [];
    classList.forEach((cls) {
      if (stud.subjects.contains(cls.subjectName) &&
          cls.startTime!.isBefore(DateTime.now()) &&
          stud.section == cls.section) {
        req.add(cls);
      }
    });
    req.sort((a, b) => b.startTime!.compareTo(a.startTime!));
    List<SubjectClass> topthree;
    if (req.length > 3) {
      topthree = req.sublist(0, 3);
    } else {
      topthree = req;
    }
    return topthree;
  }

  ///Get deadline status
  String? getdeadlineStatus(RAfromDB ra, StudentUser studData) {
    if (ra.endTime!.isAfter(DateTime.now()) &&
        !studData.completedAssessments!.contains(ra.id)) {
      return 'Pending';
    } else if (ra.endTime!.isAfter(DateTime.now()) &&
        studData.completedAssessments!.contains(ra.id)) {
      return 'Submitted';
    } else if (ra.endTime!.isBefore(DateTime.now())) {
      return 'Closed';
    }
    return null;
  }

  bool submitted(String? raId, StudentUser stud) {
    bool stat = false;
    if (stud.completedAssessments!.contains(raId)) {
      stat = true;
    }
    return stat;
  }

  ///Gets top three assessments for students assessment panel
  List<RAfromDB> getTopThree(
    List<RAfromDB> allRa,
    StudentUser stdata,
  ) {
    List<RAfromDB> myRA = [];
    final List subjects = stdata.subjects;
    allRa.forEach((ra) {
      if (subjects.contains(ra.subject)) {
        myRA.add(ra);
      }
    });
    myRA.sort((a, b) => b.endTime!.compareTo(a.endTime!));
    List<RAfromDB> topthree;
    if (myRA.length > 3) {
      topthree = myRA.sublist(0, 3);
    } else {
      topthree = myRA;
    }
    return topthree;
  }

  List<Meeting> getMyClassesforTimer(
      List<Meeting> allClasses, List subs, String section) {
    List<Meeting> myClasses = [];
    allClasses.forEach((cls) {
      if (subs.contains(cls.eventName) && cls.section == section) {
        myClasses.add(cls);
      }
    });
    return myClasses;
  }

  Meeting getNextClass(List<Meeting> list) {
    final now = DateTime.now();
    Meeting latestClass = list.firstWhere(
      (meeting) {
        return meeting.to!.isAfter(now);
      },
      orElse: () => Meeting(
        'no class',
        null,
        null,
        null,
        false,
        'no class',
        null,
      ),
    );

    list.forEach((meeting) {
      if (meeting.to!.isAfter(now) &&
          meeting.to!.isBefore(latestClass.to!) &&
          meeting.docId != latestClass.docId) {
        latestClass = meeting;
        //print('${meeting.eventName} latest class');
      }
    });
    if (latestClass.eventName == 'no class') {
      print('no class');
      return latestClass;
    }
    return latestClass;
  }

  ///
  List<SubjectClass> getMarkedClasses(List<SubjectClass> allClasses, Map att) {
    List<SubjectClass> marked = [];
    allClasses.forEach((element) {
      if (att.containsKey(element.id)) {
        marked.add(element);
      }
    });
    marked.sort((a, b) => b.startTime!.compareTo(
        a.startTime!)); // easy sorting of dates. Use in attendance grid as well
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

  String? getQuestion(RAfromDB ra, int index) {
    /* 1. need to extract all questions*/
    List<String>? textQs = ra.allTextQs as List<String>?;
    List<MCQ> mcqs = ra.allMCQs!;
    List<String?> mcqQs = [];
    mcqs.forEach((mcq) {
      mcqQs.add(mcq.question);
    });
    if (index < mcqQs.length) {
      return mcqQs[index];
    } else if (index >= mcqQs.length &&
        index < (textQs!.length + mcqQs.length)) {
      return textQs[index - mcqQs.length];
    }
    if (index >= textQs!.length) {
      return null;
    }
    return null;
  }

  Map? getAnswers(RAfromDB ra, int index) {
    //tl is total length of assessment q maps
    int tl = ra.allMCQs!.length + ra.allTextQs!.length;
    if (index < ra.allMCQs!.length) {
      
      return ra.allMCQs![index].answerChoices;
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
        if (z != i && list[i].startTime!.isBefore(list[z].startTime!)) {
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
          cls.startTime!.isAfter(now)) {
        myClasses.add(cls);
      }
    });
    return orderSubjectClass(myClasses);
  }

  String getPendingAssessmentNum(
      List comp, List<RAfromDB> all, String subject) {
    int a = 0;
    all.forEach((ra) {
      if (!comp.contains(ra.id)) {
        a++;
      }
    });
    return a.toString();
  }
}
