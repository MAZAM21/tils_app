import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/widgets/screens/remote-testing/edit-ra.dart';
import 'package:tils_app/widgets/screens/remote-testing/subject-option.dart';

class AllRAs extends StatefulWidget {
  static const routeName = '/all-remote-assessments';

  @override
  _AllRAsState createState() => _AllRAsState();
}

class _AllRAsState extends State<AllRAs> {
  final db = DatabaseService();

  final ts = TeacherService();

  Widget buildAssessmentListTile(List subList, Color col) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromARGB(50, 172, 216, 211),
        height: 250,
        child: subList.isEmpty
            ? Text('No Assessments')
            : ListView.builder(
                itemCount: subList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        child: ListTile(
                          tileColor: col,
                          title: Text(
                            '${subList[i].assessmentTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                              'MCQ: ${subList[i].allMCQs.length} , Text Questions: ${subList[i].allTextQs.length}'),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRA(subList[i]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildAssessmentListView(
    List<RAfromDB> raList,
    String subName,
    BuildContext context,
    String uid,
  ) {
    return Container(
      height: 320,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$subName',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Color.fromARGB(50, 172, 216, 211),
              height: 250,
              child: raList.isEmpty
                  ? Text('No Assessments')
                  : ListView.builder(
                      itemCount: raList.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(
                                    '${raList[i].assessmentTitle}', style: TextStyle(fontFamily: 'Proxima Nova'),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: raList[i].startTime == null
                                      ? null
                                      : Text(
                                          '${DateFormat('d/M/yy, hh:mm a').format(raList[i].startTime)}'),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRA(raList[i]),
                                    ),
                                  );
                                }),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    return StreamProvider(
      create: (context) => db.streamRA(),
      builder: (context, _) {
        final allRa = Provider.of<List<RAfromDB>>(context);
        final userData = Provider.of<TeacherUser>(context);

        Map<String, List<RAfromDB>> myRa =
            {}; //a map with subjects as keys and assessment associated with sub as values

        bool isActive = false;
        if (allRa != null && userData != null) {
          // filtering allra for all of the subs registered.
          isActive = true;
          myRa = ts.getRAForTeacher(userData, allRa);
        }
        return !isActive
            ? LoadingScreen()
            : Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'Add Assessment',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(RASubject.routeName);
                      },
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            for (var x = 0; x < myRa.length; x++)
                              buildAssessmentListView(
                                myRa.values.toList()[x],
                                myRa.keys.toList()[x],
                                context,
                                userData.uid,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
