import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/subject.dart';

import '../models/student.dart';
import '../models/dummy_data.dart';
import '../providers/all_classes.dart';
import '../providers/all_students.dart';

class StudentRecords extends StatelessWidget {
  static const routeName = '/student-records';

  @override
  Widget build(BuildContext context) {
    final _allStudentsData = Provider.of<AllStudents>(context);
    final _allStuds = _allStudentsData.allInClass;
    // final _allStudNames = _allStuds.keys.toList();
    // final _allStudStats = _allStuds.values.toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student records'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('HomePage'),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _allStuds.length,
          itemBuilder: (ctx, i) {
            return Card(
              child: InkWell(
                child: ListTile(
                  leading: Text(_allStuds[i].name),
                  trailing: Container(
                    width: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (var x = 0;
                              x < _allStuds[i].attStatStud.length;
                              x++)
                            CircleAvatar(
                              child: Text(_allStuds[i].attStatStud[x] ==
                                      AttendanceStatus.Present
                                  ? 'P'
                                  : _allStuds[i].attStatStud[x] ==
                                          AttendanceStatus.Absent
                                      ? 'A'
                                      : 'L'),
                              backgroundColor: _allStuds[i].attStatStud[x] ==
                                      AttendanceStatus.Present
                                  ? Colors.green
                                  : _allStuds[i].attStatStud[x] == AttendanceStatus.Absent
                                      ? Colors.red
                                      : Colors.yellow,
                            )
                        ]),
                  ),
                  onTap: () {
                    //Navigator.of(context).pushNamed();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//  ListView.builder(
//           itemCount: _allStudents.length,
//           itemBuilder: (ctx, i) {
//             List disp = _allStudents[i].attendance.reversed.toList();
//             return Card(
//               child: ListTile(
//                 leading: Text(_allStudents[i].name),
//                 trailing: Container(
//                   width: 200,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       for (var x = 0;
//                           x < _allStudents[i].attendance.length && x <= 3;
//                           x++)
//                         CircleAvatar(
//                           child: Text(disp[x]),
//                           backgroundColor: disp[x] == 'P'
//                               ? Colors.green
//                               : disp[x] == 'A'
//                                   ? Colors.red
//                                   : Colors.yellow,
//                         )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
