import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/widgets/screens/role-getter.dart';
import 'package:tils_app/widgets/screens/teacher-screens/add-students/add-student-form.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-detail.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/announcement-form.dart';
import 'package:tils_app/widgets/screens/teacher-screens/announcements/display-announcements.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:tils_app/widgets/screens/teacher-screens/attendance/student-provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/home.dart';
import 'package:tils_app/widgets/screens/teacher-screens/records/choose_records_screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/records/class_record_detail.dart';
import 'package:tils_app/widgets/screens/teacher-screens/records/class_records.dart';
import 'package:tils_app/widgets/screens/teacher-screens/records/student_records.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/answer-choice-input.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/rt-input.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/time_table.dart';
import 'package:tils_app/widgets/student-screens/edit-student-profile.dart';
import 'package:tils_app/widgets/student-screens/rankings/ranking-display.dart';
import 'package:tils_app/widgets/student-screens/student_RA/assessment-page.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';
import 'package:tils_app/widgets/student-screens/student_home/student_home.dart';
import './models/meeting.dart';
import './service/db.dart';

class RoutesAndTheme extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
          create: (ctx) => DatabaseService(),
        ),
        ChangeNotifierProvider<RemoteAssessment>(
          create: (ctx) => RemoteAssessment(),
        ),
        ChangeNotifierProvider<AssignmentMarks>(
          create: (ctx) => AssignmentMarks(),
        ),
        StreamProvider<List<Meeting>>(
          create: (ctx) => db.streamMeetings(),
        ),
        StreamProvider<List<SubjectClass>>(
          create: (ctx) => db.streamClasses(),
        ),
        StreamProvider<List<Attendance>>(
          create: (ctx) => db.streamAttendance(),
        ),
        StreamProvider<User>(
          create: (ctx) => db.authStateStream(),
        ),
        StreamProvider<List<StudentRank>>(
          create: (ctx) => db.streamStudents(),
        ),
        StreamProvider<List<RAfromDB>>(
          create: (ctx) => db.streamRA(),
        ),
        StreamProvider<List<AMfromDB>>(
          create: (ctx) => db.streamAM(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 76, 76, 76)))),
          //backgroundColor: Colors.black12,
          primaryColor: Color.fromARGB(255, 24, 118, 133),
          canvasColor: Color.fromARGB(255, 237, 246, 249),
          appBarTheme: AppBarTheme(
            
              elevation: 0,
              color: Color.fromARGB(255, 237, 246, 249),
              iconTheme: IconThemeData(color: Color.fromARGB(255, 76, 76, 76))),

          tabBarTheme:
              TabBarTheme(labelColor: Color.fromARGB(255, 24, 118, 133)),
          //cardcolor removed
          textTheme: TextTheme(
              headline6: TextStyle(
                color: Color.fromARGB(255, 76, 76, 76),
                fontFamily: 'Proxima Nova',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              headline5: TextStyle(
                color: Color.fromARGB(255, 0, 0, 179),
                fontFamily: 'Proxima Nova',
                fontSize: 18,
              ),
              headline4: TextStyle(
                color: Color.fromARGB(255, 154, 23, 80),
                fontFamily: 'Proxima Nova',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline3: TextStyle(
                color: Color.fromARGB(255, 10, 50, 0),
                fontFamily: 'Proxima Nova',
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              headline2: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova',
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
        ),
        home: RoleGetter(),
        routes: {
          //'/': (context) => AllTabs(),
          AttendancePage.routeName: (context) => AttendancePage(),
          HomePage.routeName: (context) => HomePage(),
          StudentRecords.routeName: (context) => StudentRecords(),
          AnnouncementForm.routeName: (context) => AnnouncementForm(),
          StudentProvider.routeName: (context) => StudentProvider(),
          RecordsPage.routeName: (context) => RecordsPage(),
          ClassRecords.routeName: (context) => ClassRecords(),
          ClassRecordDetail.routeName: (context) => ClassRecordDetail(),
          EditTTForm.routeName: (context) => EditTTForm(),
          AllAnnouncements.routeName: (context) => AllAnnouncements(),
          AnnouncementDetail.routeName: (context) => AnnouncementDetail(),
          RemoteAssessmentInput.routeName: (context) => RemoteAssessmentInput(),
          AnswerChoiceInput.routeName: (context) => AnswerChoiceInput(),
          RASubject.routeName: (context) => RASubject(),
          AllRAs.routeName: (context) => AllRAs(),
          StudentRADisplay.routeName: (context) => StudentRADisplay(),
          CalendarApp.routeName: (context) => CalendarApp(),
          AddStudent.routeName: (context) => AddStudent(),
          StudentHome.routeName: (context) => StudentHome(),
          AssessmentPage.routeName: (context) => AssessmentPage(),
          EditStudentProfile.routeName: (context) => EditStudentProfile(),
          RankingDisplay.routeName: (context) => RankingDisplay(),
          AssignmentMain.routeName: (context) => AssignmentMain(),
          AddAssignment.routeName: (context) => AddAssignment(),
        },
      ),
    );
  }
}
