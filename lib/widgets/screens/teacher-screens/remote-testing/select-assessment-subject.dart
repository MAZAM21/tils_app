import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:provider/provider.dart';

class SelectAssessmentSubject extends StatelessWidget {
  const SelectAssessmentSubject({
    Key key,
    @required this.subjects,
    @required this.tc,
  }) : super(key: key);
  final List<String> subjects;
  final TeacherUser tc;

  Widget _buttonBuilder(
    String sub,
    TeacherUser teacherUser,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: '/deploy-assessments'),
              builder: (BuildContext context) => ChangeNotifierProvider.value(
                value: tc,
                child: AllRAs(
                  subject: sub,
                ),
              ),
            ),
          );
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
        child: Text(sub),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Subject',
          style: Theme.of(context).appBarTheme.textTheme.caption,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.915,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Subject Notifier
                      for (var x = 0; x < subjects.length; x++)
                        _buttonBuilder(subjects[x], tc, context),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
