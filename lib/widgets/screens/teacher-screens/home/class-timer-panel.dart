import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/teachers-service.dart';

import 'package:tils_app/widgets/screens/teacher-screens/home/timer-text.dart';



class ClassTimerPanel extends StatefulWidget {
  final int timer;
  final int end;
  final Meeting meeting;
  ClassTimerPanel(this.timer, this.meeting, this.end);

  @override
  _ClassTimerPanelState createState() => _ClassTimerPanelState();
}

class _ClassTimerPanelState extends State<ClassTimerPanel> {
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

              int now = DateTime.now().millisecondsSinceEpoch;
              //Duration nowInMS = Duration(milliseconds: now);
              Duration remaining = Duration(milliseconds: widget.timer - now);
              Duration toEnd = Duration(milliseconds: widget.end - now);
              var dateString =
                  '${remaining.inHours}h ${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}m';
              bool timeUp = remaining <= Duration.zero;
              bool timeClose = remaining <= Duration(minutes: 30);
              bool inSession =
                  remaining <= Duration.zero && toEnd > Duration.zero;

              //print(dateString)${remaining.inHours}:;
              return TimerText(
                  inSession: inSession,
                  widget: widget,
                  dateString: dateString,
                  timeUp: timeUp,
                  timeClose: timeClose,
                  subClassNext: subClassNext,
                  meetingId: meetingID,);
            });
  }
}



///   decoration. 

// decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(215, 143, 166, 203).withOpacity(0.5),
//                   Color.fromARGB(255, 219, 244, 167).withOpacity(0.9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0, 1],
//               ),
//             ),

///     Buttons row on old timer panel
// Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     TextButton(
//                       child: Text(
//                         'Reschedule',
//                         style:
//                             TextStyle(color: Color.fromARGB(255, 76, 76, 76)),
//                       ),
//                       // style: Theme.of(context).buttonTheme,
//                       onPressed: timeUp
//                           ? null
//                           : () {
//                               Navigator.pushNamed(context, EditTTForm.routeName,
//                                   arguments: widget.meeting);
//                             },
//                     ),
//                     SizedBox(
//                       width: 50,
//                     ),
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         textStyle: TextStyle(
//                           color: Color.fromARGB(255, 76, 76, 76),
//                         ),
//                       ),
//                       child: Text('Attendance'),
//                       onPressed: !timeClose
//                           ? null
//                           : () {
//                               Navigator.pushNamed(
//                                   context, StudentProvider.routeName,
//                                   arguments: subClassNext);
//                             },
//                     ),
//                   ],
//                 )