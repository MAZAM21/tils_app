
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/student-user-data.dart';


import 'package:SIL_app/widgets/student-screens/student_RA/student-ra-display.dart';



class StudentRASubject extends StatelessWidget {
  const StudentRASubject({
    Key? key,
    required this.subjects,
    required this.studentUser,
  }) : super(key: key);
  final List<String> subjects;
  final StudentUser studentUser;

 Widget _buttonBuilder(
    String sub,
    StudentUser teacherUser,
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
                value: studentUser,
                child: StudentRADisplay(
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
              MaterialStateProperty.all(Theme.of(context).textTheme.titleLarge),
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
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
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
                        _buttonBuilder(subjects[x], studentUser, context),
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
