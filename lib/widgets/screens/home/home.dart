import 'package:flutter/material.dart';

import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/widgets/screens/announcements/announcement-form.dart';
import 'package:tils_app/widgets/screens/announcements/display-announcements.dart';
import 'package:tils_app/widgets/screens/home/attendance-graph.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import './class-timer-panel.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/service/teachers-service.dart';
import '../time table/time_table.dart';
import 'package:tils_app/widgets/drawer.dart';
import '../time table/edit-timetable-form.dart';
import '../attendance/attendance_page.dart';
import '../records/choose_records_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ts = TeacherService();

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
    final meetingsList = Provider.of<List<Meeting>>(context);
    int estimateTs = 0;
    bool isActive = false;
    Meeting nextClass;
    if (meetingsList != null) {
      nextClass = ts.getNextClass(meetingsList);
      if (nextClass.eventName != 'no class') {
        estimateTs = nextClass.from.millisecondsSinceEpoch;
      }
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            drawer: AppDrawer(),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Subject Notifier
                        ClassTimerPanel(estimateTs, nextClass),
                        _buttonBuilder('Announcements', AllAnnouncements.routeName, context)
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
