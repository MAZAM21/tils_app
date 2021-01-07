import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './widgets/screens/all_tabs.dart';
import './providers/all_students.dart';
import './widgets/screens/attendance_page.dart';
import './widgets/screens/student_records.dart';
import './widgets/screens/time_table.dart';
import './widgets/edit-timetable.dart';
import './providers/all_classes.dart';
import './widgets/screens/attendance_of_class.dart';
import './widgets/screens/class_records.dart';
import './widgets/screens/choose_records_screen.dart';
import './widgets/screens/class_record_detail.dart';
import './widgets/screens/edit-timetable-form.dart';
import './widgets/screens/home.dart';
import './widgets/screens/auth_page.dart';
import './widgets/time_table_builder.dart';


class RoutesAndTheme extends StatelessWidget {
  
final FirebaseAuth auth = FirebaseAuth.instance;
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
        home: StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return AllTabs();
              }
              return AuthScreen();
            }),
        routes: {
          //'/': (context) => AllTabs(),
          HomePage.routeName: (context) => HomePage(),
          AttendancePage.routeName: (context) => AttendancePage(),
          StudentRecords.routeName: (context) => StudentRecords(),
          TimeTableBuilder.routeName: (context) => TimeTableBuilder(),
          EditTT.routeName: (context) => EditTT(),
          AttendanceOfClass.routeName: (context) => AttendanceOfClass(),
          RecordsPage.routeName: (context) => RecordsPage(),
          ClassRecords.routeName: (context) => ClassRecords(),
          ClassRecordDetail.routeName: (context) => ClassRecordDetail(),
          EditTTForm.routeName: (context) => EditTTForm(),
        },
      ),
    );
  }
}
