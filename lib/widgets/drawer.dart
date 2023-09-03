import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/teacher-user-data.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-avatar-panel.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/manage-students/manage-students-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/mark-answers.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/select-assessment-subject.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/results/result-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/time_table.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/add-students/add-student-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/AI_screen.dart';

class AppDrawer extends StatelessWidget {
  final TeacherUser teacherData;
  final InstituteData? instData;
  AppDrawer(this.teacherData, this.instData);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TeacherAvatarPanel(teacherData: teacherData),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text(
                          'AI',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/call-chatgpt'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: CallChatGPT(),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Mark Answers',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/mark-answers'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: MarkAnswers(),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Schedule Class',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/edit-time-table'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: EditTTForm(instData),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Attendance',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.people_alt,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/attpage'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: AttendancePage(),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'AI',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.people_alt,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/aimenu'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: AIMenu(teacherData),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Deploy Assessments',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.assignment_add,
                          color: Colors.white,
                        ),
                        onTap: () {
                          ///if there are more than one subjects reg with teacher
                          ///subject selector will open
                          ///else it will go directly to the teacher's one subject assessment list
                          if (teacherData.subjects.length > 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings:
                                    RouteSettings(name: '/select-subects-ra'),
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: teacherData,
                                  child: SelectAssessmentSubject(
                                      subjects: teacherData.subjects,
                                      tc: teacherData),
                                ),
                              ),
                            );
                          } else if (teacherData.subjects.length == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: RouteSettings(name: '/all-Ras'),
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: teacherData,
                                  child: AllRAs(
                                    subject: teacherData.subjects[0],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Results',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.bar_chart,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/all-results'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: ResultMain(),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Manage Students',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.attribution,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/manage-studs'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: ManageStudents({}),
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'TimeTable',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        leading: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/assignment-main'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: CalendarApp(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Log out',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                        Divider(),
                        if (teacherData.isAdmin == true)
                          ListTile(
                            leading: Icon(
                              Icons.supervised_user_circle,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Add Students',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AddStudent.routeName);
                            },
                          ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
