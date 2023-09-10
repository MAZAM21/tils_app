import 'package:SIL_app/models/meeting.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/service/student-service.dart';
import 'package:SIL_app/widgets/student-screens/student_home/assessment_home_panel.dart';
import 'package:SIL_app/widgets/student-screens/student_home/classes-grid.dart';
import 'package:SIL_app/widgets/student-screens/student_home/student-attendance-panel.dart';
import 'package:SIL_app/widgets/student-screens/student_home/student-avatar-panel.dart';
import 'package:SIL_app/widgets/student-screens/student_home/student-class-timer-panel.dart';
import 'package:SIL_app/widgets/student-screens/student_home/student-resources-panel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StudentWebHome extends StatelessWidget {
  const StudentWebHome({
    Key? key,
    required this.studData,
    required this.estimateTs,
    required this.endTime,
    required this.nextClass,
    required this.myClasses,
    required this.ss,
  }) : super(key: key);

  final StudentUser studData;
  final int estimateTs;
  final int endTime;
  final Meeting? nextClass;
  final List<SubjectClass> myClasses;
  final StudentService ss;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.83,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: StudentClassTimerPanel(
                                  estimateTs,
                                  endTime,
                                  nextClass,
                                  studData,
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
                              child: MyClassesGrid(myClasses: myClasses),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    ///Name and avatar panel

                    SizedBox(
                      height: 30,
                    ),

                    /// Classes Grid (Stored in student screens)

                    ///Schedule Class button

                    //ButtonRowMain(teacherData: teacherData),

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
                          AssessmentHomePanel(ss: ss, studData: studData),
                          SizedBox(width: 30),
                          StudentResourcesPanel(studUser: studData),
                          SizedBox(
                            width: 30,
                          ),
                          StudentAttendancePanel(studData: studData),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ///teacher assignment panel
                    ///built on same format as assessment panel

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
