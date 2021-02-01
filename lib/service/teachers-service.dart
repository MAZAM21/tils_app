import 'package:flutter/material.dart';
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

  String mapToStrings(Map mcqs) {
    print(mcqs.runtimeType);
    String ans = '';
    mcqs.forEach((k, v) {
      ans = ans + '$v ($k)\n';
    });
    return ans;
  }
}
