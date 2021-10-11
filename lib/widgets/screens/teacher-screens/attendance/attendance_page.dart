import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/student_rank.dart';

import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/attendance/attendance-marker-builder.dart';


class AttendancePage extends StatelessWidget {
  static const routeName = '/attpage';
  // final List<SubjectClass> allClassesAdded;
  // AttendancePage(this.allClassesAdded);
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    final classData = Provider.of<List<SubjectClass>>(context);
    final studList = Provider.of<List<StudentRank>>(context);
    final teacherData = Provider.of<TeacherUser>(context);
    final myClasses = ts.getMyAttendance(classData, teacherData.subjects);
    bool isActive = false;
    bool classesAdded = false;
    if (classData != null && studList != null) {
      isActive = true;
    }
    if (myClasses != null) {
      classesAdded = true;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            body: ListView.builder(
              itemCount: myClasses.length,
              itemBuilder: (ctx, i) {
                String trail =
                    ts.getAttendanceIndicator(studList, myClasses[i]);
                return !classesAdded
                    ? Text(
                        'No Classes Scheduled',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                          tileColor: Colors.white,
                          title: myClasses[i].topic == ''
                              ? Text(
                                  '${myClasses[i].subjectName} ${myClasses[i].section}',
                                  style: TextStyle(
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2b3443),
                                  ),
                                )
                              : Text(
                                  '${myClasses[i].subjectName} ${myClasses[i].section} (${myClasses[i].topic})',
                                  style: TextStyle(
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2b3443),
                                  ),
                                ),
                          subtitle: Text(
                            '${DateFormat('hh:mm a - EEE, MMM d').format(myClasses[i].startTime)}',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text('$trail'),
                          // title: Text(
                          //   'Topic: ${myClasses[i].topic}',
                          //   style: TextStyle(
                          //     fontFamily: 'Proxima Nova',
                          //     fontSize: 14,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AttendanceMarkerBuilder.routeName,
                              arguments: myClasses[i],
                            );
                          },
                        ),
                    );
              },
            ),
          );
  }
}
