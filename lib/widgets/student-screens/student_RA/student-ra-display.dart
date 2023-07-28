import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student_RA/assessment-page.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-subject.dart';

class StudentRADisplay extends StatefulWidget {
  StudentRADisplay({required this.subject});
  final String subject;
  static const routeName = '/student-ra-display';

  @override
  _StudentRADisplayState createState() => _StudentRADisplayState();
}

class _StudentRADisplayState extends State<StudentRADisplay> {
  final ss = StudentService();

  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    final allRa = Provider.of<List<RAfromDB>>(context);
    final userData = Provider.of<StudentUser>(context);

    ///a list of all ra's of the subject passed in constructor
    List<RAfromDB> subRa = [];
    int? totalRa;
    bool isActive = false;
    String? uid;
    String? name;
    if (allRa != null && userData != null) {
      name = userData.name;
      uid = userData.uid;
      // filtering allra for all of the subs registered.
      isActive = true;
      subRa = ts.getRAfromSub(allRa, widget.subject);
      totalRa = subRa.length;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Assessments Main',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          Container(
                            height: 10,
                            color: Theme.of(context).canvasColor,
                          ),
                          Container(
                            color: Theme.of(context).canvasColor,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      '$totalRa',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: subRa.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              '${subRa[i].assessmentTitle}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            subtitle: Text(
                              '${subRa[i].subject}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 14,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            trailing: subRa[i].isDeployed! &&
                                    !ss.submitted(subRa[i].id, userData)
                                ? Text(
                                    'In Progress',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 16,
                                      color: Colors.green[400],
                                    ),
                                  )
                                : !subRa[i].isDeployed! &&
                                        !ss.submitted(subRa[i].id, userData)
                                    ? Text(
                                        'Not Deployed',
                                        style: TextStyle(
                                          fontFamily: 'Proxima Nova',
                                          fontSize: 16,
                                          color: Colors.orange[400],
                                        ),
                                      )
                                    : Text(
                                        'Completed',
                                        style: TextStyle(
                                          fontFamily: 'Proxima Nova',
                                          fontSize: 16,
                                          color: Colors.blue[400],
                                        ),
                                      ),
                            onTap: subRa[i].isDeployed! &&
                                    !ss.submitted(subRa[i].id, userData)
                                ? () {
                                    Navigator.popAndPushNamed(
                                        context, AssessmentPage.routeName,
                                        arguments: {
                                          'ra': subRa[i],
                                          'uid': uid,
                                          'name': name,
                                        });
                                  }
                                : () {},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
