import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';
import 'package:tils_app/widgets/student-screens/student_home/assessment_home_panel.dart';
import './classes-grid.dart';

class StudentHome extends StatelessWidget {
  static const routeName = '/student-home';
  final ss = StudentService();
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentUser>(context);
    final allClasses = Provider.of<List<SubjectClass>>(context);
    bool isActive = false;
    List<SubjectClass> myClasses = [];
    if (studData != null && allClasses != null) {
      myClasses =
          ss.getMyClasses(allClasses, studData.subjects, studData.section);
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()

        ///futureprovider for a list of strings of all doc ids of assessments
        ///will be used to display pending assessments
        : FutureProvider(
            create: (context) => db.getAllAssessmentIds(),
            builder: (ctx, _) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'Welcome ${studData.name}',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 76, 76, 76),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Proxima Nova',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                height: 100,
                                child: MyClassesGrid(myClasses: myClasses),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            AssessmentHomePanel(ss: ss, studData: studData),
                            Divider(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
  }
}

