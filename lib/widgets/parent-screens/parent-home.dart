import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/parent-service.dart';
import 'package:tils_app/service/ranking-service.dart';
import 'package:tils_app/widgets/parent-screens/ar-parent-panel.dart';
import 'package:tils_app/widgets/parent-screens/parent-attendance-grid.dart';
import 'package:tils_app/widgets/parent-screens/parent-attendance-panel.dart';
import 'package:tils_app/widgets/parent-screens/parent-classposition-panel.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import './parent-drawer.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({Key key}) : super(key: key);

  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  final ps = ParentService();
  final rs = RankingService();
  @override
  Widget build(BuildContext context) {
    final parentData = Provider.of<ParentUser>(context);
    final allClasses = Provider.of<List<SubjectClass>>(context);
    final allStudRanks = Provider.of<List<StudentRank>>(context);
    final raList = Provider.of<List<RAfromDB>>(context);
    List<SubjectClass> marked = [];
    List<StudentRank> sorted = [];
    List<AssessmentResult> compRaList = [];
    StudentRank myStud;

    bool isActive = false;
    if (parentData != null) {
      if (allClasses != null) {
        marked = ps.getMarkedClasses(allClasses, parentData.attendance);
      }
      if (allStudRanks != null && raList != null) {
        sorted = rs.getStudentScores(allStudRanks, raList);
        myStud = rs.getSingleStudentPos(sorted, parentData.studId);
        compRaList = rs.completedAssessmentsParent(raList, parentData);
        isActive = true;
      }
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            drawer: ParentDrawer(),
            appBar: AppBar(
              title: Text(
                'TILS Parent\'s Portal',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${parentData.studentName}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 76, 76),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(50),
                        elevation: 10,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(parentData.imageUrl),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ParentAttendancePanel(parentData),
                      SizedBox(
                        height: 10,
                      ),
                      ParentAttendanceGrid(
                        myClasses: marked,
                        attMap: parentData.attendance,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClassPositionPanel(
                        position: '${myStud.position}',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ARParentPanel(compRaList: compRaList),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
