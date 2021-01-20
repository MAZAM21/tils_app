import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/meeting.dart';

class AttChartVals {
  final String day;
  final int allPresent;
  AttChartVals(this.day, this.allPresent);
  //fromMeetings constructer takes meeting object and attendance object and converts to chart value
  factory AttChartVals.fromMeetings(Meeting meeting, Attendance att) {
    int i = 0;
    if (att.attStat != null) {
      att.attStat.forEach((k, v) {
        if (v == 1) {
          i++;
        }
      });
    }
    return AttChartVals(setWeekday(meeting.from.weekday), i);
  }
}

String setWeekday(int a) {
  switch (a) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thur';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return 'xx';
  }
}
