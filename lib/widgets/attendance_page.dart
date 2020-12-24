import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/attendance_of_class.dart';

import '../models/subject.dart';
import '../providers/all_classes.dart';
import '../providers/all_students.dart';
import '../models/student.dart';
//import '../models/dummy_data.dart';

class AttendancePage extends StatelessWidget {
  static const routeName = '/attpage';

  //
  String enToString(SubjectName name) {
    switch (name) {
      case SubjectName.Jurisprudence:
        return 'Jurisprudence';
        break;
      case SubjectName.Trust:
        return 'Trust';
        break;
      case SubjectName.Conflict:
        return 'Conflict';
        break;
      case SubjectName.Islamic:
        return 'Islamic';
        break;
      default:
        return 'Undeclared';
    }
  }

  @override
  Widget build(BuildContext context) {
    final classData = Provider.of<AllClasses>(context);
    final allClassesAdded = classData.allClassesData;
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Attendance'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('HomePage'),
              ),
            ],
          ),
          body: GridView.builder(
            itemCount: allClassesAdded.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) {
              return allClassesAdded == null
                  ? Text('No Classes Scheduled for Attendance')
                  : GridTile(
                      child: GestureDetector(
                        child: Card(
                          child: Text(
                            enToString(allClassesAdded[i].subjectName), 
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          color: allClassesAdded[i].getColor(),//need to add colors to all subjects
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AttendanceOfClass.routeName,
                            arguments: allClassesAdded[i],
                          );
                        },
                      ),
                    );
            },
          )),
    );
  }
}
