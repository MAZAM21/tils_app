import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/widgets/screens/mark-TextQs/all-textQs.dart';

import '../models/teacher-user-data.dart';
import '../models/announcement.dart';
import '../models/attendance-chart-values.dart';
import '../models/attendance.dart';
import '../models/meeting.dart';
import '../models/subject.dart';
import '../models/remote_assessment.dart';

class TeacherService with ChangeNotifier {
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
          !meeting.to.isAtSameMomentAs(latestClass.to)) {
        latestClass = meeting;
        print(meeting.eventName);
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
    print(mcqs.runtimeType);
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
    List<SubjectClass> myClasses = [];
    allClasses.forEach((cls) {
      if (subs.contains(cls.subjectName)) {
        myClasses.add(cls);
      }
    });
    return myClasses;
  }

  List<double> getMarksList(Map marks, int l) {
    List<double> markList = [];
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
    }  catch (e) {
      print('err in getmarklist: $e');
    }
    return null;
  }

  List<TextQAs> getTeacherScripts(List<TextQAs> ques, TeacherUser tData){
    List<TextQAs> textAs = [];
          ques.forEach((q) {
            if (q.isText && tData.subjects.contains(q.subject) ) {
              textAs.add(q);
            }
          });
    return textAs;
  }
}
