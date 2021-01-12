import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tils_app/models/attendance.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/models/student.dart';

import 'package:tils_app/models/subject.dart';

import 'package:tils_app/widgets/screens/attendance/student-provider.dart';
import 'package:tils_app/widgets/screens/role-getter.dart';
import 'package:tils_app/widgets/screens/student-screens/student_home.dart';
import './widgets/subject-class_builder.dart';

import './widgets/screens/all_tabs.dart';
import './providers/all_students.dart';
import './widgets/screens/attendance_page.dart';
import './widgets/screens/student_records.dart';
import './widgets/screens/time table/time_table.dart';
import './widgets/edit-timetable.dart';
import './providers/all_classes.dart';

import './widgets/screens/class_records.dart';
import './widgets/screens/choose_records_screen.dart';
import './widgets/screens/class_record_detail.dart';
import './widgets/screens/time table/edit-timetable-form.dart';
import './widgets/screens/home.dart';
import './widgets/screens/auth_page.dart';

import './service/db.dart';

class RoutesAndTheme extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AllClasses(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AllStudents(),
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
      ],
      child: MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          backgroundColor: Colors.black12,
          primaryColor: Color.fromARGB(255, 115, 149, 174),
          canvasColor: Color.fromARGB(255, 222, 242, 241),
          cardColor: Colors.greenAccent,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontSize: 16,
            ),
            headline5: TextStyle(
              color: Color.fromARGB(255, 0, 0, 179),
              fontFamily: 'Lato',
              fontSize: 18,
            ),
            headline4: TextStyle(
              color: Color.fromARGB(255, 154, 23, 80),
              fontFamily: 'Lato',
              fontSize: 16,
            ),
          ),
        ),
        home: RoleGetter(),

        /*StreamBuilder<User>(
            stream: auth.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return AllTabs();
              }
              return AuthScreen();
            }),*/
        routes: {
          //'/': (context) => AllTabs(),
          AttendancePage.routeName: (context) => AttendancePage(),
          HomePage.routeName: (context) => HomePage(),
          SubjectClassBuilder.routeName: (context) => SubjectClassBuilder(),
          StudentRecords.routeName: (context) => StudentRecords(),
          CalendarApp.routeName: (context) => CalendarApp(),
          EditTT.routeName: (context) => EditTT(),
          StudentProvider.routeName: (context) => StudentProvider(),
          RecordsPage.routeName: (context) => RecordsPage(),
          ClassRecords.routeName: (context) => ClassRecords(),
          ClassRecordDetail.routeName: (context) => ClassRecordDetail(),
          EditTTForm.routeName: (context) => EditTTForm(),
        },
      ),
    );
  }
}
