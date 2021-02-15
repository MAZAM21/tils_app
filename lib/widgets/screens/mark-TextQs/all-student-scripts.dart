import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/student-textAnswers.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/mark-TextQs/mark-script.dart';

class StudentAnswerScripts extends StatefulWidget {
  final assid;
  final title;
  StudentAnswerScripts(this.assid, this.title);
  @override
  _StudentAnswerScriptsState createState() => _StudentAnswerScriptsState();
}

class _StudentAnswerScriptsState extends State<StudentAnswerScripts> {
  final db = DatabaseService();

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
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${widget.title}',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Proxima Nova',
                            color: Theme.of(context).textTheme.headline4.color),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MarkScript(snap.data[i], widget.assid),
                                  ));
                                },
                                title: Text('${snap.data[i].name}'),
                                tileColor: Colors.teal[100],
                              ),
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
