import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/attendance/student-provider.dart';

import 'package:tils_app/widgets/screens/time%20table/edit-timetable-form.dart';

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
    final meetingID = widget.meeting.docId;
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
        : isActive && meetingID != 'no class'
            ? StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  DateFormat format = DateFormat("mm");

                  int now = DateTime.now().millisecondsSinceEpoch;
                  //Duration nowInMS = Duration(milliseconds: now);
                  Duration remaining =
                      Duration(milliseconds: widget.timer - now);
                  Duration toEnd = Duration(milliseconds: widget.end - now);
                  var dateString =
                      '${remaining.inHours}h ${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}m';
                  bool timeUp = remaining <= Duration.zero;
                  bool timeClose = remaining <= Duration(minutes: 30);
                  bool inSession =
                      remaining <= Duration.zero && toEnd > Duration.zero;

                  //print(dateString)${remaining.inHours}:;
                  return Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: ClipRRect(
                        //change this to shape rounded rect
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(15, 15)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(215, 143, 166, 203)
                                    .withOpacity(0.5),
                                Color.fromARGB(255, 219, 244, 167)
                                    .withOpacity(0.9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0, 1],
                            ),
                          ),
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: inSession
                                    ? Text(
                                        '${widget.meeting.eventName} is in session',
                                        style: TextStyle(
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 1,
                                          fontStyle: FontStyle.normal,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Text(
                                        '${widget.meeting.eventName} in $dateString',
                                        style: TextStyle(
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 1,
                                          fontStyle: FontStyle.normal,
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    textColor: Color.fromARGB(255, 76, 76, 76),

                                    child: Text('Reschedule'),
                                    // style: Theme.of(context).buttonTheme,
                                    onPressed: timeUp
                                        ? null
                                        : () {
                                            Navigator.pushNamed(
                                                context, EditTTForm.routeName,
                                                arguments: widget.meeting);
                                          },
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  FlatButton(
                                    textColor: Color.fromARGB(255, 76, 76, 76),
                                    child: Text('Attendance'),
                                    onPressed: !timeClose
                                        ? null
                                        : () {
                                            Navigator.pushNamed(context,
                                                StudentProvider.routeName,
                                                arguments: subClassNext);
                                          },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : widget.meeting.eventName == 'no class'
                ? Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Container(
                        height: 150,
                        child: ClipRRect(
                          child: Card(
                            color: Theme.of(context).canvasColor,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'No classes scheduled',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 1,
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Text('Error in ternary expression is class timer panel');
  }
}
