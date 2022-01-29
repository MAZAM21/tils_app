import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tils_app/main.dart';

import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/class-scheduler-buttons.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-assessment-panel.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-assignment-panel.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-avatar-panel.dart';
import 'package:tils_app/widgets/screens/teacher-screens/records/choose_records_screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/results/subject-results-display.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';

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
  String _token;
  final ts = TeacherService();
  final db = DatabaseService();
  @override
  void initState() {
    super.initState();
    final teacherData = Provider.of<TeacherUser>(context, listen: false);

    ///this is for foreground notifications supposedly

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${notification.title}'),
        ));
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    if (teacherData != null) {
      for (var i = 0; i < teacherData.subjects.length; i++) {
        //print('${teacherData.subjects[i]}');
        FirebaseMessaging.instance
            .subscribeToTopic('${teacherData.subjects[i]}');
      }
      getToken(teacherData.docId);
    }
    // getTopics();
  }

  getToken(String tID) async {
    String token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    db.addTokenToTeacher(_token, tID);
    //print(_token);
  }

//   getTopics() async {
//     await FirebaseFirestore.instance
//         .collection('topics')
//         .get()
//         .then((value) => value.docs.forEach((element) {
//               if (token == element.id) {
//                 subscribed = element.data().keys.toList();
//               }
//             }));

//     setState(() {
//       subscribed = subscribed;
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser>(context);
    final meetingsList = Provider.of<List<Meeting>>(context);
    final subClassList = Provider.of<List<SubjectClass>>(context);
    final raList = Provider.of<List<RAfromDB>>(context);

    ///testing student rank
    final stdRank = Provider.of<List<StudentRank>>(context);
    //print(stdRank.length);
    int estimateTs = 0;
    int endTime = 0;
    int deployedRA = 0;
    bool isActive = false;
    List<SubjectClass> gridList = [];
    Meeting nextClass;

    if (meetingsList != null &&
        teacherData != null &&
        subClassList != null &&
        raList != null) {
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
        : SafeArea(
            child: Scaffold(
              drawer: AppDrawer(),
              body: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.915,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),

                          ///Name and avatar panel
                          TeacherAvatarPanel(teacherData: teacherData),

                          SizedBox(
                            height: 25,
                          ),

                          /// Class countdown
                          ClassTimerPanel(
                            estimateTs,
                            nextClass,
                            endTime,
                            teacherData,
                          ),

                          SizedBox(
                            height: 14,
                          ),

                          /// Classes Grid (Stored in student screens)

                          MyClassesGrid(myClasses: gridList),

                          ///Schedule Class button
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xffC54134)),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(107, 25)),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(117, 27)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                    )),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      settings: RouteSettings(
                                          name: '/edit-time-table'),
                                      builder: (BuildContext context) =>
                                          ChangeNotifierProvider.value(
                                        value: teacherData,
                                        child: EditTTForm(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Schedule Class',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xffffffff)),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(107, 25)),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(117, 27)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                    )),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      settings: RouteSettings(
                                          name: '/attpage'),
                                      builder: (BuildContext context) =>
                                          ChangeNotifierProvider.value(
                                        value: teacherData,
                                        child: AttendancePage(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Attendance',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Proxima Nova',
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,)
                            ],
                          ),

                          /// Teacher Assessment Panel
                          /// includes list of latest three assessments and buttons
                          TeacherAssessmentPanel(teacherData: teacherData),

                          const SizedBox(
                            height: 20,
                          ),

                          ///teacher assignment panel
                          ///built on same format as assessment panel
                          TeacherAssignmentPanel(teacherData: teacherData),

                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

 // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         settings:
                          //             RouteSettings(name: '/assignment-main'),
                          //         builder: (BuildContext context) =>
                          //             ChangeNotifierProvider.value(
                          //           value: teacherData,
                          //           child: AssignmentMain(),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          //   child: Text('Assignments'),
                          // ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         settings: RouteSettings(name: '/records-page'),
                          //         builder: (BuildContext context) =>
                          //             ChangeNotifierProvider.value(
                          //           value: teacherData,
                          //           child: SubjectResultsDisplay(),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          //   child: Text('Records'),
                          // )