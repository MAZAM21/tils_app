import 'package:flutter/material.dart';

import './time table/time_table.dart';
import '../drawer.dart';
import './time table/edit-timetable-form.dart';
import './attendance_page.dart';
import './choose_records_screen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

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
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          child: Text(buttName),
        ),
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('HomePage'),

      // ),
      drawer: AppDrawer(),
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
                _buttonBuilder('Attendance', AttendancePage.routeName,  context),
                _buttonBuilder('Records', RecordsPage.routeName, context),
                _buttonBuilder('Time Table', CalendarApp.routeName, context),
                _buttonBuilder('Edit TT', EditTTForm.routeName, context),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}
