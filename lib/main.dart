import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/subject.dart';

// import 'package:tils_app/models/subject.dart';
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
              color: Color.fromARGB(255, 47, 255, 0),
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
          AttendancePage.routeName: (context) => AttendancePage(),
          StudentRecords.routeName: (context) => StudentRecords(),
          CalendarApp.routeName: (context) => CalendarApp(),
          EditTT.routeName: (context) => EditTT(),
          AttendanceOfClass.routeName: (context) => AttendanceOfClass(),
          RecordsPage.routeName: (context) => RecordsPage(),
          ClassRecords.routeName: (context) => ClassRecords(),
          ClassRecordDetail.routeName: (context) => ClassRecordDetail(),
        },
        home: HomePage(),
      ),
    );
  }
}

Widget _buttonBuilder(String buttName, Object route, BuildContext context) {
  return Flexible(
    fit: FlexFit.loose,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
        child: Text(buttName),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buttonBuilder('Attendance', AttendancePage.routeName, context),
                _buttonBuilder('Records', RecordsPage.routeName, context),
                _buttonBuilder('Time Table', CalendarApp.routeName, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
