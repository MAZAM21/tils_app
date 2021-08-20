import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:tils_app/models/subject.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';

import 'package:tils_app/widgets/screens/teacher-screens/attendance/student-provider.dart';

class AttendancePage extends StatelessWidget {
  static const routeName = '/attpage';
  // final List<SubjectClass> allClassesAdded;
  // AttendancePage(this.allClassesAdded);
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    final classData = Provider.of<List<SubjectClass>>(context);
    final teacherData = Provider.of<TeacherUser>(context);
    final myClasses = ts.getMyAttendance(classData, teacherData.subjects);

    return classData == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: GridView.builder(
              itemCount: myClasses.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                return myClasses == null
                    ? Text('No Classes Scheduled for Attendance')
                    : GridTile(
                        child: GestureDetector(
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${myClasses[i].subjectName} ${myClasses[i].section}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 250, 235, 215),
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${DateFormat('EEE, MMM d').format(myClasses[i].startTime)}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 250, 235, 215),
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Text(
                                  'Topic: ${myClasses[i].topic}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 250, 235, 215),
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                            color: myClasses[i]
                                .getColor(), //need to add colors to all subjects
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              StudentProvider.routeName,
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
