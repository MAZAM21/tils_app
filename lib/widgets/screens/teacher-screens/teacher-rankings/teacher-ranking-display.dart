import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/ranking-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';


// This needs to be the page where the students with the top score are displayed
class TeacherRankingDisplay extends StatelessWidget {
  static const routeName = '/rankingDiplay';
  final rs = RankingService();
  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    List<StudentRank> students = [];
    try {
      final studsFromdb = Provider.of<List<StudentRank>>(context);
      final assessments = Provider.of<List<RAfromDB>>(context);

      if (studsFromdb != null && assessments != null) {
        isActive = true;
       // students = rs.getStudentScores(studsFromdb, assessments);
      }
    } catch (e) {
      print('error in ranking display students: $e');
    }
    return isActive == true
        ? Scaffold(
            appBar: AppBar(),
            body: ListView.builder(
              itemBuilder: (ctx, i) {
                return i == 0
                    ? null //top
                    : i == 1
                        ? null //second
                        : i == 2
                            ? SizedBox( // because third was with second in the row widget this was only a sized box 
                                height: 10,
                              )
                            : ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: students[i].imageUrl != ''
                                      ? NetworkImage(students[i].imageUrl)
                                      : null,
                                ),
                                title: Text('${students[i].name}') ?? Text(''),
                                trailing: Text('${students[i]}'),
                              );
              },
              itemCount: students.length,
            ),
          )
        : LoadingScreen();
  }
}
