import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student_RA/assessment-page.dart';

class StudentRADisplay extends StatelessWidget {
  static const routeName = '/student-ra-display';
  final db = DatabaseService();
  final ss = StudentService();
  final ts = TeacherService();

  Widget buildAssessmentListView(List<RAfromDB> raList, Color col,
      String subName, BuildContext context, String uid, List completed) {
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
                                tileColor: completed.contains(raList[i].id)
                                    ? Colors.green[100]
                                    : col,
                                title: Text(
                                  '${raList[i].assessmentTitle}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                    'MCQ: ${raList[i].allMCQs.length} , Text Questions: ${raList[i].allTextQs.length}'),
                              ),
                              onTap: !completed.contains(raList[i].id)
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AssessmentPage(raList[i], uid),
                                          ));
                                    }
                                  : () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text(
                                                  'This assessment has been submitted \n \n No taksies backsies!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontFamily: 'Raleway', color: Colors.pinkAccent),
                                                ),
                                              ));
                                    },
                            ),
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
    return StreamProvider(
      create: (context) => db.streamRA(),
      builder: (context, _) {
        final allRa = Provider.of<List<RAfromDB>>(context);
        final userData = Provider.of<StudentUser>(context);
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
                                myRa.keys.toList()[x],
                                context,
                                userData.uid,
                                completed,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
