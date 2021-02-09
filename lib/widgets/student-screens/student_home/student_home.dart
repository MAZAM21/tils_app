import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';
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
                            Consumer<List<String>>(
                              builder: (context, allIds, _) {
                                bool idActive = false;
                                if (allIds != null) {
                                  idActive = true;
                                }
                                final pending = ss.getPendingAssessmentNum(
                                    studData.assessments, allIds);
                                return !idActive
                                    ? LoadingScreen
                                    : Flexible(
                                        fit: FlexFit.loose,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(15, 15)),
                                            child: GestureDetector(
                                              child: Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(215, 143,
                                                              166, 203)
                                                          .withOpacity(0.9),
                                                      Color.fromARGB(255, 219,
                                                              244, 167)
                                                          .withOpacity(0.5),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomCenter,
                                                    stops: [0, 1],
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Assessments',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      76,
                                                                      76,
                                                                      76),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Proxima Nova',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        if (pending != '0')
                                                          Text(
                                                            'Pending: $pending',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                     186, 18, 0),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Proxima Nova',
                                                            ),
                                                          ),
                                                        if (pending == '0')
                                                          Text(
                                                            'No pending assessments',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      76,
                                                                      76,
                                                                      76),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  'Proxima Nova',
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ChangeNotifierProvider
                                                            .value(
                                                      value: studData,
                                                      child: StudentRADisplay(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
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
