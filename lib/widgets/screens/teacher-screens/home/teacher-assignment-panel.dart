import 'package:flutter/material.dart';

import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/instititutemd.dart';

import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/manage-students/manage-students-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/manage-teachers/manage-teachers-main.dart';

class TeacherAssignmentPanel extends StatelessWidget {
  TeacherAssignmentPanel({
    Key? key,
    required this.teacherData,
    required this.instData,
  }) : super(key: key);

  final ts = TeacherService();

  final TeacherUser? teacherData;
  final InstituteData instData;

  @override
  Widget build(BuildContext context) {
    final amList = Provider.of<List<AMfromDB>>(context);

    int totalNumAM = amList.length;
    List<AMfromDB> topThree = [];

    if (amList.isNotEmpty) {
      topThree = ts.getTopThreeAM(amList, teacherData);
      print(topThree.length);
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/assignment-main'),
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AssignmentMain(),
                    ),
                  ),
                );
              },
              child: Text(
                'Assignments',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              '($totalNumAM)',
              style: TextStyle(
                color: Color(0xff5f686f),
                fontFamily: 'Proxima Nova',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),

            ///TODO
            ///add navigator to add assessments
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AddAssignment(),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add_circle_outline_rounded),
              color: Color(0xffC54134),
              iconSize: 20,
            ),
          ],
        ),
        Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: topThree.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.white,
                  title: Text(
                    '${topThree[i].title}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    '${topThree[i].subject}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Proxima Nova',
                      color: Color(0xff5F686F),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (teacherData!.isAdmin!)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/manage-teachers'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: ManageTeachers(instData.ranking_yearSub),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Manage Teachers',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffC54134)),
                    minimumSize: MaterialStateProperty.all(Size(107, 25)),
                    fixedSize: MaterialStateProperty.all(Size(145, 27)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    )),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/manage-studs'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: ManageStudents(instData.ranking_yearSub),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Manage Students',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffC54134)),
                    minimumSize: MaterialStateProperty.all(Size(107, 25)),
                    fixedSize: MaterialStateProperty.all(Size(145, 27)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    )),
              ),
            ],
          )
      ],
    );
  }
}
