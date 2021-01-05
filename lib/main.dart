import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './widgets/all_tabs.dart';
import './providers/all_students.dart';
import './widgets/attendance_page.dart';
import './widgets/student_records.dart';
import './widgets/time_table.dart';
import './widgets/edit-timetable.dart';
import './providers/all_classes.dart';
import './widgets/attendance_of_class.dart';
import './widgets/class_records.dart';
import './widgets/choose_records_screen.dart';
import './widgets/class_record_detail.dart';
import './widgets/edit-timetable-form.dart';
import './widgets/home.dart';


void main() async {
  runApp(Tapp());
}

class Tapp extends StatelessWidget {
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
        routes: {
          '/': (context) => AllTabs(),
          HomePage.routeName: (context) => HomePage(),
          AttendancePage.routeName: (context) => AttendancePage(),
          StudentRecords.routeName: (context) => StudentRecords(),
          CalendarApp.routeName: (context) => CalendarApp(),
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




