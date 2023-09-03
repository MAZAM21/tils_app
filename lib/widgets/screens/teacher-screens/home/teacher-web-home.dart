import 'package:SIL_app/models/meeting.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/class-timer-panel.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-assessment-panel.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-assignment-panel.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-resources-panel.dart';
import 'package:SIL_app/widgets/student-screens/student_home/classes-grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TeacherWebHome extends StatelessWidget {
  const TeacherWebHome({
    Key? key,
    required this.teacherData,
    required this.estimateTs,
    required this.nextClass,
    required this.endTime,
    required this.gridList,
  }) : super(key: key);

  final TeacherUser? teacherData;
  final int estimateTs;
  final Meeting? nextClass;
  final int endTime;
  final List<SubjectClass> gridList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // drawer: AppDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClassTimerPanel(
                                    estimateTs,
                                    nextClass,
                                    endTime,
                                    teacherData,
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              dragStartBehavior: DragStartBehavior.start,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.59,
                                child: MyClassesGrid(myClasses: gridList),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     TeacherAvatarPanel(teacherData: teacherData),

                      //     // SizedBox(
                      //     //   height: 25,
                      //     // ),

                      //     /// Class countdown
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      // ClassTimerPanel(
                      //   estimateTs,
                      //   nextClass,
                      //   endTime,
                      //   teacherData,
                      // ),

                      ///Name and avatar panel

                      SizedBox(
                        height: 30,
                      ),

                      /// Classes Grid (Stored in student screens)

                      ///Schedule Class button

                      /// Teacher Assessment Panel
                      /// includes list of latest three assessments and buttons
                      SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TeacherAssessmentPanel(teacherData: teacherData),
                            SizedBox(width: 30),
                            TeacherResourcesPanel(teacherData: teacherData),
                            SizedBox(width: 30),
                            TeacherAssignmentPanel(teacherData: teacherData),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      //ButtonRowMain(teacherData: teacherData),

                      ///teacher assignment panel
                      ///built on same format as assessment panel

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
