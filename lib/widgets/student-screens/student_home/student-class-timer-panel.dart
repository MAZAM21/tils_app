import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:provider/provider.dart';

import 'package:tils_app/widgets/screens/teacher-screens/home/timer-text.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/time_table.dart';
import 'package:tils_app/widgets/student-screens/time-table-student/student-calendarapp.dart';

class StudentClassTimerPanel extends StatefulWidget {
  ///start time
  final int timer;

  ///end time
  final int end;

  ///meeting object
  final Meeting meeting;

  ///student data
  final StudentUser studData;

  const StudentClassTimerPanel(
      this.timer, this.end, this.meeting, this.studData);

  @override
  _StudentClassTimerPanelState createState() => _StudentClassTimerPanelState();
}

class _StudentClassTimerPanelState extends State<StudentClassTimerPanel> {
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    final String meetingID = widget.meeting.docId;

    final subClassList = Provider.of<List<SubjectClass>>(context);
    SubjectClass subClassNext;
    bool isActive = false;
    if (subClassList != null) {
      isActive = true;
      if (meetingID != 'no class') {
        subClassNext = ts.getSubjectClass(subClassList, meetingID);
      }
    }
    return !isActive
        ? CircularProgressIndicator()
        : StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1), (i) => i),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              DateFormat format = DateFormat("mm");
              DateFormat secFormat = DateFormat('ss');

              int now = DateTime.now().millisecondsSinceEpoch;
              //Duration nowInMS = Duration(milliseconds: now);
              Duration remaining = Duration(milliseconds: widget.timer - now);
              Duration toEnd = Duration(milliseconds: widget.end - now);

              String hourString;
              if (remaining.inHours < 10) {
                hourString = '0${remaining.inHours}';
              } else {
                hourString = '${remaining.inHours}';
              }

              String ehourString;
              if (toEnd.inHours < 10 && toEnd.inHours > 0) {
                ehourString = '0${remaining.inHours}';
              } else if (toEnd.inHours <= 0) {
                ehourString = '00';
              } else {
                ehourString = '${remaining.inHours}';
              }

              /// Before class starts string
              var dateString =
                  '$hourString : ${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))} : ${secFormat.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';

              ///
              var toEndString =
                  '$ehourString : ${format.format(DateTime.fromMillisecondsSinceEpoch(toEnd.inMilliseconds))} : ${secFormat.format(DateTime.fromMillisecondsSinceEpoch(toEnd.inMilliseconds))}';

              bool timeUp = remaining <= Duration.zero;
              bool timeClose = remaining <= Duration(minutes: 30);
              bool inSession =
                  remaining <= Duration.zero && toEnd > Duration.zero;

              //print(dateString)${remaining.inHours}:;
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Classes',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff21353f),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/assignment-main'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: widget.studData,
                                child: StudentCalendar(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Time-table',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            color: Color(0xff21353f),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TimerText(
                    inSession: inSession,
                    dateString: dateString,
                    timeUp: timeUp,
                    timeClose: timeClose,
                    subClassNext: subClassNext,
                    meetingId: meetingID,
                    toEndString: toEndString,
                  ),
                ],
              );
            });
  }
}
