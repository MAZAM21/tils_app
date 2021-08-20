import 'package:flutter/material.dart';
import 'package:tils_app/models/subject.dart';

import 'package:tils_app/widgets/screens/teacher-screens/home/class-timer-panel.dart';

class TimerText extends StatelessWidget {
  const TimerText(
      {Key key,
      @required this.inSession,
      @required this.widget,
      @required this.dateString,
      @required this.timeUp,
      @required this.timeClose,
      @required this.subClassNext,
      @required this.meetingId})
      : super(key: key);

  final bool inSession;
  final ClassTimerPanel widget;
  final String dateString;
  final bool timeUp;
  final bool timeClose;
  final SubjectClass subClassNext;
  final String meetingId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              if (meetingId == 'no class')
                Text(
                  'Schedule is clear',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: 1,
                    fontStyle: FontStyle.normal,
                    color: Color.fromARGB(255, 76, 76, 76),
                  ),
                ),
              if (meetingId != 'no class')
                inSession
                    ? Text(
                        '${subClassNext.subjectName} is in session',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 1,
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(255, 76, 76, 76),
                        ),
                      )
                    : Text(
                        '${subClassNext.subjectName} in $dateString',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          decoration: TextDecoration.underline,
                          letterSpacing: 1,
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(255, 76, 76, 76),
                        ),
                      ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
