import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tils_app/models/subject.dart';
import 'package:tils_app/widgets/screens/attendance/student-provider.dart';

class AttendancePage extends StatelessWidget {
  static const routeName = '/attpage';
  // final List<SubjectClass> allClassesAdded;
  // AttendancePage(this.allClassesAdded);

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
    final classData = Provider.of<List<SubjectClass>>(context);

    // CollectionReference _allAttCollection =
    //     FirebaseFirestore.instance.collection('attendance');

    return classData == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : MaterialApp(
            theme: Theme.of(context),
            home: Scaffold(
                // appBar: AppBar(
                //   title: Text('Attendance'),
                //   actions: <Widget>[
                //     FlatButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       child: Text('HomePage'),
                //     ),
                //   ],
                // ),
                body: GridView.builder(
              itemCount: classData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                return classData == null
                    ? Text('No Classes Scheduled for Attendance')
                    : GridTile(
                        child: GestureDetector(
                          child: Card(
                            child: Text(
                              classData[i].subjectName,
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            color: classData[i]
                                .getColor(), //need to add colors to all subjects
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              StudentProvider.routeName,
                              arguments: classData[i],
                            );
                          },
                        ),
                      );
              },
            )),
          );
  }
}
