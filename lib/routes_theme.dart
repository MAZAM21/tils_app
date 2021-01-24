import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/widgets/screens/announcements/announcement-detail.dart';
import 'package:tils_app/widgets/screens/announcements/announcement-form.dart';
import 'package:tils_app/widgets/screens/announcements/display-announcements.dart';
import 'package:tils_app/widgets/screens/attendance/student-provider.dart';
import 'package:tils_app/widgets/screens/remote-testing/answer-choice-input.dart';
import 'package:tils_app/widgets/screens/remote-testing/rt-input.dart';
import 'package:tils_app/widgets/screens/remote-testing/subject-option.dart';
import 'package:tils_app/widgets/screens/role-getter.dart';

import './widgets/screens/attendance/attendance_page.dart';
import './widgets/screens/records/student_records.dart';

import './models/meeting.dart';
import './widgets/screens/records/class_records.dart';
import './widgets/screens/records/choose_records_screen.dart';
import './widgets/screens/records/class_record_detail.dart';
import './widgets/screens/time table/edit-timetable-form.dart';
import './widgets/screens/home/home.dart';

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
        StreamProvider<List<RAfromDB>>(
          create: (ctx) => db.streamRA(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          backgroundColor: Colors.black12,
          primaryColor: Color.fromARGB(255, 24, 118, 133),
          canvasColor: Color.fromARGB(255, 237, 246, 249),
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(255, 0, 109, 119),
          ),
          tabBarTheme:
              TabBarTheme(labelColor: Color.fromARGB(255, 255, 221, 210)),
          //cardcolor removed
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
              fontSize: 18,
            ),
            headline5: TextStyle(
              color: Color.fromARGB(255, 0, 0, 179),
              fontFamily: 'Proxima Nova',
              fontSize: 18,
            ),
            headline4: TextStyle(
              color: Color.fromARGB(255, 154, 23, 80),
              fontFamily: 'Proxima Nova',
              fontSize: 16,
            ),
          ),
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
        },
      ),
    );
  }
}