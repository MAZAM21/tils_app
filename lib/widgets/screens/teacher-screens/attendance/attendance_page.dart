import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:tils_app/models/subject.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

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
    bool isActive = false;
    bool classesAdded = false;
    if (classData != null) {
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
                return  ListTile(
                      leading: Text(
                        '${myClasses[i].subjectName} ${myClasses[i].section}',
                        style: TextStyle(
                            
                            fontFamily: 'Proxima Nova',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        '${DateFormat('EEE, MMM d').format(myClasses[i].startTime)}',
                        style: TextStyle(
                          
                          fontFamily: 'Proxima Nova',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      title: Text(
                        'Topic: ${myClasses[i].topic}',
                        style: TextStyle(
                          
                          fontFamily: 'Proxima Nova',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          StudentProvider.routeName,
                          arguments: myClasses[i],
                        );
                      },
                    );
              },
            ),
          );
  }
}
