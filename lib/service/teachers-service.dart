import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/student_rank.dart';

import '../models/teacher-user-data.dart';
import '../models/announcement.dart';
import '../models/attendance-chart-values.dart';
import '../models/attendance.dart';
import '../models/meeting.dart';
import '../models/subject.dart';
import '../models/remote_assessment.dart';

class TeacherService with ChangeNotifier {
  ///Get number of students registered with the subject
  String getAttendanceIndicator(List<StudentRank> studList, SubjectClass cls) {
    String clsId = cls.id;
    int marked = 0;
    int total = 0;
    studList.forEach((stud) {
      if (stud.subjects.contains(cls.subjectName)) {
        total++;
      }
      if (stud.attendance['$clsId'] == 1 || stud.attendance['$clsId'] == 2) {
        marked++;
      }
    });
    String stat = '$marked / $total';
    return stat;
  }

  ///Get top three assingments for teachers assignment panel
  List<AMfromDB> getTopThreeAM(
    List<AMfromDB> allAm,
    TeacherUser tdata,
  ) {
    List<AMfromDB> myAM = [];
    final List<String> subjects = tdata.subjects;
    allAm.forEach((am) {
      if (subjects.contains(am.subject)) {
        myAM.add(am);
      }
    });
    myAM.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
    List<AMfromDB> topthree;
    if (myAM.length > 3) {
      topthree = myAM.sublist(0, 3);
    } else {
      topthree = myAM;
    }
    return topthree;
  }

  ///Get deadline status
  String getdeadlineStatus(RAfromDB ra) {
    if (ra.endTime.isAfter(DateTime.now())) {
      return 'Pending';
    } else if (ra.endTime.isBefore(DateTime.now())) {
      return 'Finished';
    }
    return null;
  }

  ///Gets top three assessments for teachers assessment panel
  List<RAfromDB> getTopThree(
    List<RAfromDB> allRa,
    TeacherUser tdata,
  ) {
    List<RAfromDB> myRA = [];
    final List<String> subjects = tdata.subjects;
    allRa.forEach((ra) {
      if (subjects.contains(ra.subject)) {
        myRA.add(ra);
      }
    });
    myRA.sort((a, b) => a.startTime.compareTo(b.startTime));
    List<RAfromDB> topthree;
    if (myRA.length > 3) {
      topthree = myRA.sublist(0, 3);
    } else {
      topthree = myRA;
    }
    return topthree;
  }

  ///Gets teachers assignments
  List<AMfromDB> getTeachersAssignments(
      List<AMfromDB> amList, TeacherUser tdata) {
    List subs = tdata.subjects;
    List<AMfromDB> tam = [];
    amList.forEach((element) {
      if (subs.contains(element.subject)) {
        tam.add(element);
      }
    });
    return tam;
  }

  ///Gets students registered for the subject
  List<StudentRank> getStudentsOfSub(
      List<StudentRank> students, String subject) {
    List<StudentRank> regStuds = [];
    students.forEach((stud) {
      if (stud.subjects.contains(subject)) {
        regStuds.add(stud);
      }
    });
    regStuds.sort((a, b) => a.name.compareTo(b.name));
    return regStuds;
  }

  Meeting getNextClass(List<Meeting> list) {
    final now = DateTime.now();
    Meeting latestClass = list.firstWhere(
      (meeting) {
        return meeting.to.isAfter(now);
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
      if (meeting.to.isAfter(now) &&
          meeting.to.isBefore(latestClass.to) &&
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

  SubjectClass getSubjectClass(List<SubjectClass> list, String id) {
    return list.firstWhere(
      (cls) {
        return cls.id == id;
      },
      orElse: () => SubjectClass(
        id: 'no class',
        subjectName: 'no class',
        startTime: null,
        section: null,
      ),
    );
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

  List<SubjectClass> getClassesForGrid(List<SubjectClass> all) {
    List<SubjectClass> myClasses = [];
    var now = DateTime.now();
    all.forEach((cls) {
      if (cls.startTime.isAfter(now)) {
        myClasses.add(cls);
      }
    });
    return orderSubjectClass(myClasses);
  }

  List<AttChartVals> getChartVals(
    List<Meeting> meetings,
    List<Attendance> att,
  ) {
    final now = DateTime.now();
    List<AttChartVals> chartVals = [];
    Attendance attSelected;
    meetings.forEach((m) {
      if (m.from.isBefore(now)) {
        attSelected = att.firstWhere((a) {
          return a.id == m.docId;
        }, orElse: () => null);
        chartVals.add(AttChartVals.fromMeetings(m, attSelected));
      }
    });
    return chartVals;
  }

  Map randomiseChoices(Map ansChoices) {
    List keys = ansChoices.keys.toList();

    Map<String, String> randomised = {};
    keys.shuffle();
    keys.forEach((k) {
      randomised.addAll({k: ansChoices['$k']});
    });
    return randomised;
  }

  List<Announcement> orderAnnouncement(List<Announcement> listIn) {
    final list = listIn;
    for (int i = 0; i < list.length; i++) {
      Announcement temp = list[i];
      for (int z = 0; z < list.length; z++) {
        Announcement tempZ = list[z];
        if (z != i && list[i].time.isBefore(list[z].time)) {
          list[i] = list[z];
          list[z] = temp;
          temp = tempZ;
        }
      }
    }
    return list.reversed.toList();
  }

  List<String> valueList(Map map) {
    return map.values.toList();
  }

  List<String> keyList(Map map) {
    return map.keys.toList();
  }

  List<RAfromDB> getRAfromSub(List<RAfromDB> allRAs, String sub) {
    List<RAfromDB> subRAs = [];
    allRAs.forEach((ra) {
      if (sub == ra.subject) {
        subRAs.add(ra);
      }
    });
    return subRAs;
  }

  Map<String, List<RAfromDB>> getRAForTeacher(
    TeacherUser userData,
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

  String mapToStrings(Map mcqs) {
    //print(mcqs.runtimeType);
    String ans = '';
    mcqs.forEach((k, v) {
      ans = ans + '$v ($k)\n';
    });
    return ans;
  }

  List<Meeting> getMyClasses(List<Meeting> allClasses, List subs) {
    List<Meeting> myClasses = [];
    allClasses.forEach((cls) {
      if (subs.contains(cls.eventName)) {
        myClasses.add(cls);
      }
    });
    return myClasses;
  }

  List<SubjectClass> getMyAttendance(List<SubjectClass> allClasses, List subs) {
    ///TODO
    ///implement algo where:
    ///the class next up is shown but the classes after that are not shown
    ///the classes that are done are also shown.

    List<SubjectClass> myClasses = [];
    List<SubjectClass> displayClasses = [];
    allClasses.sort((a, b) => b.startTime.compareTo(a.startTime));
    int x;
    int y;
    int clsAfterNext;

    /// all classes with teachers subs get separated
    allClasses.forEach((cls) {
      if (subs.contains(cls.subjectName)) {
        myClasses.add(cls);
      }
    });

    /// the class id of the class after the next one is extracted
    for (int i = 0; i < myClasses.length; i++) {
      x = i + 1;
      y = i - 1;
      if (myClasses[i].startTime.isAfter(DateTime.now()) &&
          myClasses[x].startTime.isBefore(DateTime.now())) {
        clsAfterNext = y;
      }
    }

    /// display classes are the next up and the rest (hopefully)
    myClasses.forEach((cls) {
      if (cls.startTime.isBefore(myClasses[clsAfterNext].startTime)) {
        displayClasses.add(cls);
      }
    });

    displayClasses.sort((a, b) => b.startTime.compareTo(a.startTime));
    return displayClasses;
  }

  List<int> getMarksList(Map marks, int l) {
    List<int> markList = [];
    try {
      if (marks.isEmpty) {
        print('marks = null');
        for (var x = 0; x < l; x++) {
          markList.add(0);
        }
      } else {
        print('marks!=null');
        markList = marks.values.toList();
      }
      return markList;
    } catch (e) {
      print('err in getmarklist: $e');
    }
    return null;
  }

  ///List of textQAs sorted on the basis of whether the teacher has the subject
  List<TextQAs> getTeacherScripts(List<TextQAs> ques, TeacherUser tData) {
    List<TextQAs> textAs = [];
    ques.forEach((q) {
      if (q.isText && tData.subjects.contains(q.subject)) {
        textAs.add(q);
      }
    });
    return textAs;
  }

  ///Number of Remote assessments deployed.
  int getDeployedRA(List<RAfromDB> raList, TeacherUser tData) {
    int num = 0;
    raList.forEach((ra) {
      if (ra.startTime.isAfter(DateTime.now()) &&
          ra.endTime.isBefore(DateTime.now()) &&
          tData.subjects.contains(ra.subject)) {
        num++;
      }
    });
    return num;
  }

  Color getColor(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return Color.fromARGB(255, 56, 85, 89);
        break;
      case 'Trust':
        return Color.fromARGB(255, 68, 137, 156);
        break;
      case 'Conflict':
        return Color.fromARGB(255, 37, 31, 87);
        break;
      case 'Islamic':
        return Color.fromARGB(255, 39, 59, 92);
        break;
      case 'Company':
        return Color.fromARGB(255, 50, 33, 58);
        break;
      case 'Tort':
        return Color.fromARGB(255, 56, 59, 83);
        break;
      case 'Property':
        return Color.fromARGB(255, 102, 113, 126);
        break;
      case 'EU':
        return Color.fromARGB(255, 206, 185, 146);
        break;
      case 'HR':
        return Color.fromARGB(255, 143, 173, 136);
        break;
      case 'Contract':
        return Color.fromARGB(255, 36, 79, 38);
        break;
      case 'Criminal':
        return Color.fromARGB(255, 37, 109, 27);
        break;
      case 'LSM':
        return Color.fromARGB(255, 189, 213, 234);
        break;
      case 'Public':
        return Color.fromARGB(255, 201, 125, 96);
        break;
      default:
        return Colors.black;
    }
  }
}
