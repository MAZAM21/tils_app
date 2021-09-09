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
import 'package:tils_app/widgets/parent-screens/parent-home-avatar-panel.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import './parent-drawer.dart';

///Unlike teacher homes, each widget here defines its width with the help of mediaquery.
/// It is yet to be determined which is the better approach.
//TODO
/// add notifications
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

    // If all lists are null, I need to
    if (allStudRanks != null &&
        raList != null &&
        allClasses != null &&
        parentData != null) {
      marked = ps.getMarkedClasses(allClasses, parentData.attendance);
      sorted = rs.getStudentScores(allStudRanks, raList);
      if (sorted.isNotEmpty) {
        myStud = rs.getSingleStudentPos(sorted, parentData.studId);
        if (myStud != null) {
          isActive = true;
        }
      }
      compRaList = rs.completedAssessmentsParent(raList, parentData);
    }

    return !isActive
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            drawer: ParentDrawer(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'TILS Parent\'s Portal',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Proxima Nova',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Color(0xffc54134),
            ),
            body: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ParentHomeAvatarPanel(parentData: parentData),
                      SizedBox(
                        height: 10,
                      ),
                      ParentAttendancePanel(parentData),
                      SizedBox(
                        height: 30,
                      ),
                     ParentAttendanceGrid(
                        myClasses: marked,
                        attMap: parentData.attendance,
                      ),
                      SizedBox(
                        height: 20,
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
