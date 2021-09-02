import 'package:flutter/material.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';

class AssessmentHomePanel extends StatelessWidget {
  const AssessmentHomePanel({
    Key key,
    @required this.ss,
    @required this.studData,
  }) : super(key: key);

  final StudentService ss;
  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    final raList = Provider.of<List<RAfromDB>>(context);
    bool idActive = false;
    String pending;
        if (raList != null) {
          idActive = true;
          pending = ss.getPendingAssessmentNum(
            studData.assessments, raList);
        }
        return !idActive
            ? CircularProgressIndicator()
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
     
  }
}
