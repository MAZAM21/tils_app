import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/role.dart';
import 'package:SIL_app/models/teachers-all.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/AI_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SIL_app/models/assignment-marks.dart';
import 'package:SIL_app/models/metrics.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/resource.dart';
import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/widgets/screens/role-getter.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/add-students/add-student-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/announcements/announcement-detail.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/announcements/announcement-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/announcements/display-announcements.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/attendance/attendance-marker-builder.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/attendance/student-provider.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/home/teacher-home.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/records/choose_records_screen.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/records/class_record_detail.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/records/class_records.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/records/student_records.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/answer-choice-input.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/rt-input.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/time_table.dart';
import 'package:SIL_app/widgets/student-screens/edit-student-profile.dart';
import 'package:SIL_app/widgets/student-screens/rankings/student-ranking-display.dart';
import 'package:SIL_app/widgets/student-screens/student_RA/assessment-page.dart';
import 'package:SIL_app/widgets/student-screens/student_home/student_home.dart';
import './models/meeting.dart';
import './service/genDB.dart';
import './service/db.dart';

class RoutesAndTheme extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final String uid = auth.currentUser.uid;
  final genDb = GeneralDatabase();

  final InstProvider instProvider = InstProvider();

  @override
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InstProvider>.value(
          value: instProvider,
        ),
        ChangeNotifierProxyProvider<InstProvider, DatabaseService>(
          create: (ctx) => DatabaseService(),
          update: (context, rProvider, _) =>
              DatabaseService(instProvider.instID),
        ),

        ChangeNotifierProvider<RemoteAssessment>(
          create: (ctx) => RemoteAssessment(),
        ),
        ChangeNotifierProvider<AssignmentMarks>(
          create: (ctx) => AssignmentMarks(),
        ),
        // Use ProxyProvider to create the DatabaseService with the Role object
        StreamProvider<List<Meeting>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamMeetings(),
          initialData: [],
        ),
        StreamProvider<List<ResourceDownload>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamResource(),
          initialData: [],
        ),
        StreamProvider<List<SubjectClass>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamClasses(),
          initialData: [],
        ),
        StreamProvider<User?>(
          create: (ctx) => genDb.authStateStream(),
          initialData: null,
        ),
        StreamProvider<List<StudentRank>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamStudents(),
          initialData: [],
        ),
        StreamProvider<List<AllTeachers>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamTeachers(),
          initialData: [],
        ),
        StreamProvider<List<RAfromDB>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamRA(),
          initialData: [],
        ),
        StreamProvider<List<AMfromDB>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamAM(),
          initialData: [],
        ),
        StreamProvider<List<StudentMetrics>>(
          create: (ctx) =>
              Provider.of<DatabaseService>(ctx, listen: false).streamMetrics(),
          initialData: [],
        ),
        FutureProvider<InstituteData?>(
          create: (ctx) => Provider.of<DatabaseService>(ctx, listen: false)
              .getInstituteData(),
          initialData: InstituteData(
              name: 'Fluency',
              instId: '',
              year_subjects: {},
              inst_subjects: [],
              ranking_yearSub: {}),
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
          primaryColor: Color(0xffC54134),
          canvasColor: Color(0xfff4f6f9),
          appBarTheme: AppBarTheme(
              toolbarTextStyle: TextStyle(
                  color: Color(0xff161616),
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              elevation: 0,
              color: Color(0xfff4f6f9),
              iconTheme: IconThemeData(color: Color.fromARGB(255, 76, 76, 76))),

          tabBarTheme:
              TabBarTheme(labelColor: Color.fromARGB(255, 24, 118, 133)),
          //cardcolor removed
          textTheme: TextTheme(
            //previously hl6
            titleLarge: TextStyle(
              color: Color.fromARGB(255, 76, 76, 76),
              fontFamily: 'Proxima Nova',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),

            //previously hl5
            titleMedium: TextStyle(
              fontSize: 18,
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.w700,
              color: Color(0xff21353f),
            ),

            /// HL4 is for descriptive text
            /// e.g subject names and assessment titles

            /// previously headline 4
            titleSmall: TextStyle(
                color: Color(0xff161616),
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 14),

            // previously headLine 3
            bodyLarge: TextStyle(
              color: Color(0xffC54134),
              fontFamily: 'Proxima Nova',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            labelMedium: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),

            //previously headline 2
            bodySmall: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        home: RoleGetter(),
        routes: {
          //'/': (context) => AllTabs(),
          AttendancePage.routeName: (context) => AttendancePage(),

          StudentRecords.routeName: (context) => StudentRecords(),
          AnnouncementForm.routeName: (context) => AnnouncementForm(),
          StudentProvider.routeName: (context) => StudentProvider(),
          RecordsPage.routeName: (context) => RecordsPage(),
          ClassRecords.routeName: (context) => ClassRecords(),
          ClassRecordDetail.routeName: (context) => ClassRecordDetail(),
          // EditTTForm.routeName: (context) => EditTTForm(),
          AllAnnouncements.routeName: (context) => AllAnnouncements(),
          AnnouncementDetail.routeName: (context) => AnnouncementDetail(),
          RemoteAssessmentInput.routeName: (context) => RemoteAssessmentInput(),
          AnswerChoiceInput.routeName: (context) => AnswerChoiceInput(),
          RASubject.routeName: (context) => RASubject(),
          //AllRAs.routeName: (context) => AllRAs(),
          //StudentRADisplay.routeName: (context) => StudentRADisplay(),
          CalendarApp.routeName: (context) => CalendarApp(),
          AddStudent.routeName: (context) => AddStudent(),
          StudentHome.routeName: (context) => StudentHome(),
          AssessmentPage.routeName: (context) => AssessmentPage(),
          EditStudentProfile.routeName: (context) => EditStudentProfile(),
          // StudentRankingDisplay.routeName: (context) => StudentRankingDisplay(),
          AssignmentMain.routeName: (context) => AssignmentMain(),
          AddAssignment.routeName: (context) => AddAssignment(),
          AttendanceMarkerBuilder.routeName: (context) =>
              AttendanceMarkerBuilder(),
        },
      ),
    );
  }
}
