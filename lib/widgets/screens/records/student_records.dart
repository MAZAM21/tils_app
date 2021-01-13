import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tils_app/models/student.dart';
import 'package:tils_app/models/subject.dart';


import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class StudentRecords extends StatelessWidget {
  static const routeName = '/student-records';
  
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);
    return db==null ? LoadingScreen(): FutureBuilder(
      future: db.getAllStudents(),
      builder: (context, studentsSnapshot) =>
          studentsSnapshot.connectionState == ConnectionState.waiting
              ? LoadingScreen()
              : studentsSnapshot.hasError
                  ? Text('error in get all student records builder')
                  : Scaffold(
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
                        itemCount: studentsSnapshot.data.length,
                        itemBuilder: (ctx, i) {
                          return Card(
                            child: InkWell(
                              child: ListTile(
                                leading: Text(studentsSnapshot.data[i].name),
                                trailing: Container(
                                  width: 200,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        for (var x = 0;
                                            x <
                                                studentsSnapshot
                                                    .data[i].attStatStud.length;
                                            x++)
                                          CircleAvatar(
                                            child: Text(studentsSnapshot.data[i]
                                                        .attStatStud[x] ==
                                                    1
                                                ? 'P'
                                                : studentsSnapshot.data[i]
                                                            .attStatStud[x] ==
                                                        3
                                                    ? 'A'
                                                    : 'L'),
                                            backgroundColor: studentsSnapshot
                                                        .data[i]
                                                        .attStatStud[x] ==
                                                    1
                                                ? Colors.green
                                                : studentsSnapshot.data[i]
                                                            .attStatStud[x] ==
                                                        3
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

