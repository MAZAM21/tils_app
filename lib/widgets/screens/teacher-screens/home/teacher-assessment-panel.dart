import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/teacher-user-data.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/teacher-screens/mark-TextQs/all-textQs.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';

class TeacherAssessmentPanel extends StatelessWidget {
  final ts = TeacherService();
  TeacherAssessmentPanel({
    Key key,
    @required this.teacherData,
  }) : super(key: key);

  final TeacherUser teacherData;

  @override
  Widget build(BuildContext context) {
    final raList = Provider.of<List<RAfromDB>>(context);

    int totalNumRA = raList.length;
    List<RAfromDB> topThree = [];

    if (raList.isNotEmpty) {
      topThree = ts.getTopThree(raList, teacherData);
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
                    settings: RouteSettings(name: '/all-ras'),
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AllRAs(),
                    ),
                  ),
                );
              },
              child: Text(
                'Assessements',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Text(
              '($totalNumRA)',
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
                      child: RASubject(),
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
            itemCount: topThree.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              String dStat = ts.getdeadlineStatus(topThree[i]);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.white,
                  title: Text(
                    '${topThree[i].assessmentTitle}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    'Deadline: ${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].endTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Proxima Nova',
                      color: Color(0xff5F686F),
                    ),
                  ),
                  trailing: Text(
                    '$dStat',
                    style: TextStyle(
                      color: Color(0xffC54134),
                      fontFamily: 'Proxima Nova',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 19,
        ),
        Row(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffC54134)),
                  minimumSize: MaterialStateProperty.all(Size(107, 25)),
                  fixedSize: MaterialStateProperty.all(Size(145, 27)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)),
                  )),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/deploy-assessments'),
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AllRAs(),
                    ),
                  ),
                );
              },
              child: Text(
                'Deploy Assessments',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffffffff)),
                  minimumSize: MaterialStateProperty.all(Size(107, 25)),
                  fixedSize: MaterialStateProperty.all(Size(140, 27)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)),
                  )),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/deploy-assessments'),
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AllRAs(),
                    ),
                  ),
                );
              },
              child: Text(
                'Mark Assessment',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,

                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
