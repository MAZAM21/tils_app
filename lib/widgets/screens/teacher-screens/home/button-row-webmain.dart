import 'package:flutter/material.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/manage-students/manage-students-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/select-assessment-subject.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/results/result-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/time_table.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/MCQ-generation.dart';

class ButtonRowMain extends StatelessWidget {
  const ButtonRowMain({
    Key? key,
    required this.teacherData,
  }) : super(key: key);

  final TeacherUser? teacherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: RedButtonMain(
                //     child: 'Schedule Class',
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           settings: RouteSettings(name: '/edit-time-table'),
                //           builder: (BuildContext context) =>
                //               ChangeNotifierProvider.value(
                //             value: teacherData,
                //             child: EditTTForm(),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WhiteButtonMain(
                    child: 'Time-table',
                    onPressed: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WhiteButtonMain(
                    child: 'Attendance',
                    onPressed: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RedButtonMain(
                    child: 'Deploy Assessments',
                    onPressed: () {
                      ///if there are more than one subjects reg with teacher
                      ///subject selector will open
                      ///else it will go directly to the teacher's one subject assessment list
                      if (teacherData!.subjects.length > 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/select-subects-ra'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: SelectAssessmentSubject(
                                  subjects: teacherData!.subjects,
                                  tc: teacherData),
                            ),
                          ),
                        );
                      } else if (teacherData!.subjects.length == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/all-Ras'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: AllRAs(
                                subject: teacherData!.subjects[0],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WhiteButtonMain(
                    child: 'AI',
                    onPressed: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WhiteButtonMain(
                    child: 'Results',
                    onPressed: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RedButtonMain(
                    child: 'Manage Students',
                    onPressed: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RedButtonMain(
                    child: 'Manage Students',
                    onPressed: () {
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
