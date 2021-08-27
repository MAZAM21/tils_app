import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/mark-TextQs/all-textQs.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';

class TeacherAssessmentPanel extends StatelessWidget {
  const TeacherAssessmentPanel({
    Key key,
    @required this.teacherData,
  }) : super(key: key);

  final TeacherUser teacherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            Text(
              'Assessment in Progress',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 1,
                fontStyle: FontStyle.normal,
                color: Color.fromARGB(255, 76, 76, 76),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 76, 76, 76),
                            ),
                          ),
                          Text(
                            'Certainty of Objects',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 76, 76, 76),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Deadline: ',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 76, 76, 76),
                          ),
                        ),
                        Text(
                          '24th August, 5:00 PM',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 76, 76, 76),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
          height: 70,
        ),
        Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AllTextQs(),
                    ),
                  ),
                );
              },
              child: Text('Mark Answers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider.value(
                      value: teacherData,
                      child: AllRAs(),
                    ),
                  ),
                );
              },
              child: Text('Deploy Assessments'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create New Assessments'),
            ),
          ],
        ),
      ],
    );
  }
}
