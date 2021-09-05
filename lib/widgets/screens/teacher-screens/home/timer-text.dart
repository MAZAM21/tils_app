import 'package:flutter/material.dart';
import 'package:tils_app/models/subject.dart';

import 'package:tils_app/widgets/screens/teacher-screens/home/class-timer-panel.dart';

class TimerText extends StatelessWidget {
  const TimerText({
    Key key,
    @required this.inSession,
    
    @required this.dateString,
    @required this.timeUp,
    @required this.timeClose,
    @required this.subClassNext,
    @required this.meetingId,
    @required this.toEndString,
  }) : super(key: key);

  final bool inSession;
  
  final String dateString;
  final bool timeUp;
  final bool timeClose;
  final SubjectClass subClassNext;
  final String meetingId;
  final String toEndString;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.white,
        height: 65,
        width: MediaQuery.of(context).size.width * 0.915,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          '${subClassNext.subjectName} ends in',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff5F686F),
                          ),
                        )
                      : Text(
                          '${subClassNext.subjectName} starts in:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff5F686F),
                          ),
                        ),
              ],
            ),
            inSession?Text(
              '$toEndString',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                fontStyle: FontStyle.normal,
                color: Color(0xff2a353f),
              ),
            ) :
            Text(
              '$dateString',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1,
                fontStyle: FontStyle.normal,
                color: Color(0xff2a353f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
