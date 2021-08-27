import 'package:flutter/material.dart';

import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/class-scheduler-buttons.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-assessment-panel.dart';

import 'package:tils_app/widgets/student-screens/student_home/classes-grid.dart';

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

  Widget _buttonBuilder(String buttName, BuildContext context, Icon icon,
      Widget wid, TeacherUser prov) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                //in order to extend scope of provider use MaterialPageRoute and apple ChangeNotifierProvider as done below
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: prov,
                      child: wid,
                    ),
                  ),
                );
              },
            ),
            icon,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser>(context);
    final meetingsList = Provider.of<List<Meeting>>(context);
    final subClassList = Provider.of<List<SubjectClass>>(context);
    final raList = Provider.of<List<RAfromDB>>(context);

    int estimateTs = 0;
    int endTime = 0;
    int deployedRA = 0;
    bool isActive = false;
    List<SubjectClass> gridList = [];
    Meeting nextClass;

    if (meetingsList != null && teacherData != null && subClassList!=null) {
      gridList = ts.getClassesForGrid(subClassList);
      final myClasses = ts.getMyClasses(meetingsList, teacherData.subjects);
      nextClass = ts.getNextClass(myClasses);
      deployedRA = ts.getDeployedRA(raList, teacherData);

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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Subject Notifier
                        ClassTimerPanel(estimateTs, nextClass, endTime),
                        Container(
                          child: MyClassesGrid(myClasses: gridList),
                          height: 100,
                        ),
                        SizedBox(height: 30),
                        ClassSchedulerButtons(teacherData: teacherData),
                        Divider(),
                        TeacherAssessmentPanel(teacherData: teacherData),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  settings: RouteSettings(name: '/assignment-main'),
                                  builder: (BuildContext context) =>
                                      ChangeNotifierProvider.value(
                                    value: teacherData,
                                    child: AssignmentMain(),
                                  ),
                                ),
                              );
                            },
                            child: Text('Assignments'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}






///         Old button box
// ClipRRect(
//                           borderRadius:
//                               BorderRadius.all(Radius.elliptical(15, 15)),
//                           child: Container(
//                             height: 450,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color.fromARGB(215, 143, 166, 203)
//                                       .withOpacity(0.9),
//                                   Color.fromARGB(255, 219, 244, 167)
//                                       .withOpacity(0.5),
//                                 ],
//                                 begin: Alignment.bottomRight,
//                                 end: Alignment.topLeft,
//                                 stops: [0, 1],
//                               ),
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 _buttonBuilder(
//                                   'Announcements',
//                                   context,
//                                   Icon(
//                                     Icons.announcement,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   AllAnnouncements(),
//                                   teacherData,
//                                 ),
//                                 _buttonBuilder(
//                                   'Remote Assessment',
//                                   context,
//                                   Icon(
//                                     Icons.border_color,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   AllRAs(),
//                                   teacherData,
//                                 ),
//                                 _buttonBuilder(
//                                   'Time Table',
//                                   context,
//                                   Icon(
//                                     Icons.calendar_today_sharp,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   CalendarApp(),
//                                   teacherData,
//                                 ),
//                                 _buttonBuilder(
//                                   'Records',
//                                   context,
//                                   Icon(
//                                     Icons.book_outlined,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   RecordsPage(),
//                                   teacherData,
//                                 ),
//                                 _buttonBuilder(
//                                   'Check Answers',
//                                   context,
//                                   Icon(
//                                     Icons.assignment_turned_in_outlined,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   AllTextQs(),
//                                   teacherData,
//                                 ),
//                                 _buttonBuilder(
//                                   'My Results',
//                                   context,
//                                   Icon(
//                                     Icons.list_alt_sharp,
//                                     color:
//                                         Color.fromARGB(255, 76, 76, 76),
//                                   ),
//                                   SubjectResultsDisplay(),
//                                   teacherData,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),