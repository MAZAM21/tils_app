import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/ranking-service.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({Key key}) : super(key: key);

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  String _yearFilter;

  Map<String, List<String>> yearSub = {
    '1': ['Contract', 'LSM', 'Criminal', 'Public'],
    '2': ['Tort', 'Property', 'HR', 'EU'],
    '3': ['Jurisprudence', 'Trust', 'Company', 'Conflict', 'Islamic']
  };

  @override
  void didChangeDependencies() {
    final teacherData = Provider.of<TeacherUser>(context);

    _yearFilter = teacherData.year;

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final studsFromdb = Provider.of<List<StudentRank>>(context);
    final assessments = Provider.of<List<RAfromDB>>(context);
    final teacherData = Provider.of<TeacherUser>(context);
    bool isActive = false;
    if (studsFromdb.isNotEmpty) {
      isActive = true;
      print('active in manage students');
    }

    return 
        Scaffold(
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: studsFromdb.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          child: Row(
                            children: [
                              Text(studsFromdb[i].name),
                            ],
                          ),
                        );
                      }),
                )
              ],
            )),
          );
        // : LoadingScreen();
  }
}

///filter determines the year students displayed 