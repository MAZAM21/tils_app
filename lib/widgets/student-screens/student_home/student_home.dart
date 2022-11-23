import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/models/metrics.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

import 'package:tils_app/widgets/student-screens/student_home/assessment_home_panel.dart';
import 'package:tils_app/widgets/student-screens/student_home/metric_panel.dart';
import 'package:tils_app/widgets/student-screens/student_home/student-attendance-panel.dart';
import 'package:tils_app/widgets/student-screens/student_home/student-avatar-panel.dart';
import 'package:tils_app/widgets/student-screens/student_home/student-class-timer-panel.dart';

import './classes-grid.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tils_app/main.dart';

class StudentHome extends StatefulWidget {
  static const routeName = '/student-home';

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final ss = StudentService();
  String _token;
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    final studDatainit = Provider.of<StudentUser>(context, listen: false);

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
                
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    if (studDatainit != null) {
      for (var i = 0; i < studDatainit.subjects.length; i++) {
        print('${studDatainit.subjects[i]}');
        FirebaseMessaging.instance
            .subscribeToTopic('${studDatainit.subjects[i]}');
      }
      getToken(studDatainit.uid);
    }
    // getTopics();
  }

  getToken(studID) async {
    String token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    //print(token);
    db.addTokenToStudent(token, studID);
  }

  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentUser>(context, listen: true);
    final allClasses = Provider.of<List<SubjectClass>>(context);
    final meetingsList = Provider.of<List<Meeting>>(context);
    final metrics = Provider.of<List<StudentMetrics>>(context);

    int estimateTs = 0;
    int endTime = 0;
    Meeting nextClass;
    bool isActive = false;
    bool mActive = false;
    List<SubjectClass> myClasses = [];

    if (studData != null && allClasses != null && meetingsList != null) {
      myClasses =
          ss.getMyClasses(allClasses, studData.subjects, studData.section);
      final myMeets = ss.getMyClassesforTimer(
          meetingsList, studData.subjects, studData.section);
      nextClass = ss.getNextClass(myMeets);
      if (nextClass.eventName != 'no class') {
        estimateTs = nextClass.from.millisecondsSinceEpoch;
        endTime = nextClass.to.millisecondsSinceEpoch;
      }
      isActive = true;
    }
    if (metrics != null) {
      mActive = true;
    }
    

    return !isActive
        ? LoadingScreen()
        : Scaffold(
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
                        SizedBox(
                          height: 10,
                        ),
                        StudentAvatarPanel(studData: studData),
                        SizedBox(
                          height: 25,
                        ),
                        if (mActive && isActive)
                        MetricDisplay(metrics: metrics, studData: studData),

                        ///Class timer panel widget is same as for teachers
                        ///stored in teachers HP
                        ///just passed different postional argument object student user
                        StudentClassTimerPanel(
                          estimateTs,
                          endTime,
                          nextClass,
                          studData,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        if (myClasses != null)
                          MyClassesGrid(myClasses: myClasses),
                        SizedBox(
                          height: 15,
                        ),
                        AssessmentHomePanel(ss: ss, studData: studData),
                        StudentAttendancePanel(studData: studData),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
