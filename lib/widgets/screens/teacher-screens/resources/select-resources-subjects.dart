import 'package:provider/provider.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/resources/resources-main.dart';

class SelectSubjectResource extends StatelessWidget {
  const SelectSubjectResource({
    Key key,
    @required this.subs,
    @required this.teacher,
  }) : super(key: key);
  final List<String> subs;
  final TeacherUser teacher;

  Widget _buttonBuilder(
    String buttName,
    String sub,
    DateTime time,
    BuildContext context,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: '/deploy-assessments'),
                builder: (BuildContext context) => ChangeNotifierProvider.value(
                  value: teacher,
                  child: ResourcesMain(
                    sub: sub,
                  ),
                ),
              ),
            );
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          child: Text(buttName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Subject Notifier
                  for (var sub in subs) _buttonBuilder(sub, sub, time, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}