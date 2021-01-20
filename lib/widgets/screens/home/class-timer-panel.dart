import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/attendance/student-provider.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/time%20table/edit-timetable-form.dart';

class ClassTimerPanel extends StatefulWidget {
  final int timer;
  final Meeting meeting;
  ClassTimerPanel(this.timer, this.meeting);

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
                  Duration remaining =
                      Duration(milliseconds: widget.timer - now);
                  var dateString =
                      '${remaining.inHours}h ${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}m';
                  bool timeUp = remaining <= Duration.zero;
                  bool timeClose = remaining <= Duration(minutes: 30);
                  //print(dateString)${remaining.inHours}:;
                  return Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.elliptical(15,15)),
                        child: Container(
                          height: 150,
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    '${widget.meeting.eventName} in $dateString',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 1,
                                      fontStyle: FontStyle.normal,
                                      color: Color.fromARGB(255, 220, 238, 209),
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
                                    ElevatedButton(
                                      child: Text('Reschedule'),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, EditTTForm.routeName,
                                            arguments: widget.meeting);
                                      },
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    ElevatedButton(
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
                            color: Theme.of(context).primaryColor,
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
                                      color: Color.fromARGB(255, 220, 238, 209),
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
