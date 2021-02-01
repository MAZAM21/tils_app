import 'package:flutter/material.dart';

import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/widgets/screens/records/choose_records_screen.dart';
import 'package:tils_app/widgets/screens/time%20table/time_table.dart';
import '../announcements/display-announcements.dart';
import '../loading-screen.dart';
import '../remote-testing/display-all-ra.dart';
import './class-timer-panel.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ts = TeacherService();

  Widget _buttonBuilder(
      String buttName, Object route, BuildContext context, Icon icon) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // onPressed: () {
          //   Navigator.of(context).pushNamed(route);
          // },
          // style: ButtonStyle(
          //   minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
          //   backgroundColor:
          //       MaterialStateProperty.all(Theme.of(context).primaryColor),
          //   textStyle: MaterialStateProperty.all(
          //       Theme.of(context).textTheme.headline6),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  '$buttName',
                  style: TextStyle(
                    color: Color.fromARGB(255, 76, 76, 76),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: 'Proxima Nova',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(route);
                },
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('im called');
    // Provider.of<RemoteAssessment>(context, listen: false).allMCQs = [];
    final meetingsList = Provider.of<List<Meeting>>(context);
    int estimateTs = 0;
    int endTime = 0;
    bool isActive = false;
    Meeting nextClass;
    if (meetingsList != null) {
      nextClass = ts.getNextClass(meetingsList);
      if (nextClass.eventName != 'no class') {
        estimateTs = nextClass.from.millisecondsSinceEpoch;
        endTime = nextClass.to.millisecondsSinceEpoch;
      }
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            drawer: AppDrawer(),
            body: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //Subject Notifier
                          ClassTimerPanel(estimateTs, nextClass, endTime),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(15, 15)),
                                child: Container(
                                  height: 350,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(215, 143, 166, 203)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 219, 244, 167)
                                            .withOpacity(0.5),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      stops: [0, 1],
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _buttonBuilder(
                                        'Announcements',
                                        AllAnnouncements.routeName,
                                        context,
                                        Icon(
                                          Icons.announcement,
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                        ),
                                      ),
                                      _buttonBuilder(
                                        'Remote Assessment',
                                        AllRAs.routeName,
                                        context,
                                        Icon(
                                          Icons.border_color,
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                        ),
                                      ),
                                      _buttonBuilder(
                                        'Time Table',
                                        CalendarApp.routeName,
                                        context,
                                        Icon(
                                          Icons.calendar_today_sharp,
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                        ),
                                      ),
                                      _buttonBuilder(
                                        'Records',
                                        RecordsPage.routeName,
                                        context,
                                        Icon(
                                          Icons.book_outlined,
                                          color:
                                              Color.fromARGB(255, 76, 76, 76),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
