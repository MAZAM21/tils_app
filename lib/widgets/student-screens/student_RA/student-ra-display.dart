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

class StudentRADisplay extends StatefulWidget {
  static const routeName = '/student-ra-display';

  @override
  _StudentRADisplayState createState() => _StudentRADisplayState();
}

class _StudentRADisplayState extends State<StudentRADisplay> {
  final db = DatabaseService();

  final ss = StudentService();

  final ts = TeacherService();

  Widget buildAssessmentListView(
      List<RAfromDB> raList,
      Color col,
      String subName,
      BuildContext context,
      String uid,
      List completed,
      String name) {
    if (subName == 'Trust') {
      //print(raList.length);
    }
    return Container(
      height: 286,
      child: Column(
        children: <Widget>[
          Container(
            width: 300,
            color: Theme.of(context).canvasColor,
            child: Text(
              '$subName',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: BoxConstraints(maxHeight: 250),
              color: Color.fromARGB(50, 172, 216, 211),
              height: 250,
              child: raList.isEmpty
                  ? Text('No Assessments')
                  : Container(
                    height: 250,
                    child: ListView.builder(
                      cacheExtent: 0.0,
                        itemCount: raList.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                child: ListTile(
                                  tileColor: completed.contains(raList[i].id)
                                      ? Colors.green[100]
                                      : !raList[i].isDeployed
                                          ? Colors.grey[300]
                                          : col,
                                  title: Text(
                                    '${raList[i].assessmentTitle} ',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: raList[i].startTime == null
                                      ? null
                                      : Text(
                                          'Deadline: (${DateFormat('EEE, hh:mm a').format(raList[i].endTime)})'),
                                ),
                                onTap: !completed.contains(raList[i].id) &&
                                        raList[i].isDeployed
                                    ? () {
                                        Navigator.popAndPushNamed(
                                            context, AssessmentPage.routeName,
                                            arguments: {
                                              'ra': raList[i],
                                              'uid': uid,
                                              'name': name,
                                            });
                                      }
                                    : completed.contains(raList[i].id)
                                        ? () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                  'This assessment has been submitted \n \n No taksies backsies!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      color: Colors.pinkAccent),
                                                ),
                                              ),
                                            );
                                          }
                                        : !raList[i].isDeployed
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    content: Text(
                                                      'This assessment has not been deployed',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'Raleway',
                                                          color:
                                                              Colors.pinkAccent),
                                                    ),
                                                  ),
                                                );
                                              }
                                            : {},
                              ),
                            ),
                          );
                        },
                      ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRa = Provider.of<List<RAfromDB>>(context);
    final userData = Provider.of<StudentUser>(context);

    //when student attempts an assessment the id is logged in his doc in cf.
    //this list of attempted assessment id is stored in completed.
    List completed = userData.assessments;

    Map<String, List<RAfromDB>> myRa =
        {}; //a map with subjects as keys and assessment associated with sub as values

    bool isActive = false;
    if (allRa != null && userData != null) {
      // filtering allra for all of the subs registered.
      isActive = true;
      myRa = ss.getRAForStud(userData, allRa);
    }

    return !isActive
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (var x = 0; x < myRa.length; x++)
                          buildAssessmentListView(
                            myRa.values.toList()[x],
                            Colors.white,
                            myRa.keys.toList()[x], //list of ras per sub
                            context,
                            userData.uid,
                            completed,
                            userData.name,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
