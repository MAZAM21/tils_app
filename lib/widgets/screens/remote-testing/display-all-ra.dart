

import 'package:flutter/material.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/widgets/screens/remote-testing/edit-ra.dart';
import 'package:tils_app/widgets/screens/remote-testing/subject-option.dart';

class AllRAs extends StatelessWidget {
  static const routeName = '/all-remote-assessments';
  final db = DatabaseService();
  final ts = TeacherService();
  Widget buildAssessmentListTile(List subList, Color col) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromARGB(50,172, 216, 211),
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
                              ));
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text('Add Assessment', style: Theme.of(context).textTheme.headline6,),
            onPressed: () {
              Navigator.of(context).pushNamed(RASubject.routeName);
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: db.streamRA(),
        builder: (context, raSnap) {
          if (raSnap.hasError) {
            print('ra stream builder has error:${raSnap.error}');
          }
          if (raSnap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (raSnap.hasData) {
            List<RAfromDB> jurisList = ts.getRAfromSub(
              raSnap.data,
              'Jurisprudence',
            );
            List<RAfromDB> conflictList = ts.getRAfromSub(
              raSnap.data,
              'Conflict',
            );
            List<RAfromDB> islamicList = ts.getRAfromSub(
              raSnap.data,
              'Islamic',
            );
            List<RAfromDB> trustList = ts.getRAfromSub(
              raSnap.data,
              'Trust',
            );
            return SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth * 0.85,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Jurisprudence',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        buildAssessmentListTile(
                          jurisList,
                          Color.fromARGB(100, 56, 85, 89),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Conflict',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        buildAssessmentListTile(
                          conflictList,
                          Color.fromARGB(100, 37, 31, 87),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Islamic',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        buildAssessmentListTile(
                          islamicList,
                          Color.fromARGB(100, 39, 59, 92),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Trust',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        buildAssessmentListTile(
                          trustList,
                          Color.fromARGB(100, 68, 137, 156),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Text('No Data');
        },
      ),
    );
  }
}
