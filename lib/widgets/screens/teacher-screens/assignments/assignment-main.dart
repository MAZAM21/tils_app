import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/mark-student-assignments.dart';

class AssignmentMain extends StatefulWidget {
  const AssignmentMain({Key key}) : super(key: key);
  static const routeName = '/assignment-main';
  @override
  _AssignmentMainState createState() => _AssignmentMainState();
}

/// This needs to display total number of assgnments
/// partially checked assignments
/// to be checked
/// for eache assignment displayed, show the total students and checked ones
class _AssignmentMainState extends State<AssignmentMain> {
  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    final td = Provider.of<TeacherUser>(context);
    final amData = Provider.of<List<AMfromDB>>(context);
    final students = Provider.of<List<StudentRank>>(context);
    bool isActive = false;
    List<AMfromDB> teachersAM = [];
    int totalAM;
    if (amData != null && students != null) {
      isActive = true;
      teachersAM = ts.getTeachersAssignments(amData, td);
      totalAM = teachersAM.length;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Assignments',
                style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 22,
                    color: Color(0xff2b3443)),
              ),
             
            ),
            body: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
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
                                    '$totalAM',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeNotifierProvider.value(
                                        value: td,
                                        child: AddAssignment(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Add Assignment',
                                  style: TextStyle(
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffc54134),
                                  ),
                                ),
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
                    itemCount: teachersAM.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            '${teachersAM[i].title}',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2b3443),
                            ),
                          ),
                          subtitle: Text(
                            '${teachersAM[i].subject}',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 14,
                              color: Color(0xff2b3443),
                            ),
                          ),
                          trailing: Text(
                            'Marked: ${teachersAM[i].nameMarks.length} / ${ts.getStudentsOfSub(students, teachersAM[i].subject).length}',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 16,
                              color: Color(0xff2b3443),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: td,
                                  child: MarkStudentAssignments(
                                    students: ts.getStudentsOfSub(
                                        students, teachersAM[i].subject),
                                    subject: teachersAM[i].subject,
                                    title: teachersAM[i].title,
                                    editAM: teachersAM[i],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
          );
  }
}
