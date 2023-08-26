import 'package:flutter/material.dart';
import 'package:SIL_app/models/subject-class.dart';

class TimerText extends StatelessWidget {
  const TimerText({
    Key? key,
    required this.inSession,
    required this.dateString,
    required this.timeUp,
    required this.timeClose,
    required this.subClassNext,
    required this.meetingId,
    required this.toEndString,
  }) : super(key: key);

  final bool inSession;

  final String dateString;
  final bool timeUp;
  final bool timeClose;
  final SubjectClass? subClassNext;
  final String meetingId;
  final String toEndString;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.20,
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
                      fontSize: 18,
                      letterSpacing: 1,
                      fontStyle: FontStyle.normal,
                      color: Color(0xff5F686F),
                    ),
                  ),
                if (meetingId != 'no class')
                  inSession
                      ? Text(
                          '${subClassNext!.subjectName} ends in',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff5F686F),
                          ),
                        )
                      : Text(
                          '${subClassNext!.subjectName} starts in:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff5F686F),
                          ),
                        ),
              ],
            ),
            inSession && meetingId != 'no class'
                ? Text(
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
                  )
                : !inSession && meetingId != 'no class'
                    ? Text(
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
                      )
                    : Text(''),
          ],
        ),
      ),
    );
  }
}
