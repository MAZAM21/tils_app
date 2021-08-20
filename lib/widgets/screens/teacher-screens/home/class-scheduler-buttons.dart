import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';
import 'package:tils_app/widgets/screens/teacher-screens/time%20table/time_table.dart';

import 'package:provider/provider.dart';

class ClassSchedulerButtons extends StatelessWidget {
  const ClassSchedulerButtons({
    Key key,
    @required this.teacherData,
  }) : super(key: key);

  final TeacherUser teacherData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: CalendarApp(),
                      ),
                    ),
                  );
                },
                child: Text('Time Table'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: EditTTForm(),
                      ),
                    ),
                  );
                },
                child: Text('Schedule Class'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
