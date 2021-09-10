import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/student-textAnswers.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

import 'package:tils_app/widgets/screens/teacher-screens/mark-TextQs/mark-script.dart';

class StudentAnswerScripts extends StatefulWidget {
  final assid;
  final title;
  final String subject;
  final TeacherUser tUser;
  StudentAnswerScripts(this.assid, this.title, this.subject, this.tUser);
  @override
  _StudentAnswerScriptsState createState() => _StudentAnswerScriptsState();
}

class _StudentAnswerScriptsState extends State<StudentAnswerScripts> {
  final db = DatabaseService();
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudentTextAns>>(
      stream: db.streamAnsFromID(widget.assid),
      builder: (context, snap) {
        if (snap.hasError) {
          print('error in stream text QA streambuilder: ${snap.error}');
          return Text('error in stream text QA streambuilder: ${snap.error}');
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        if (snap.hasData) {
          List<StudentTextAns> allScripts = snap.data;
          return Scaffold(
            appBar: AppBar(),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.915,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${widget.title}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Proxima Nova',
                          color: Color.fromARGB(255, 76, 76, 76),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MarkScript(
                                      snap.data[i],
                                      widget.assid,
                                      widget.subject,
                                      widget.tUser.docId),
                                ));
                              },
                              title: Text('${snap.data[i].name}',
                                  style: Theme.of(context).textTheme.headline5),
                              trailing: ts.getStudentScriptMarkedStat(
                                      snap.data[i].studentId,
                                      widget.assid,
                                      widget.tUser)
                                  ? Icon(Icons.check)
                                  : null,
                              tileColor: Colors.teal[100],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Text('no Data');
      },
    );
  }
}
