import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

import 'package:tils_app/widgets/screens/teacher-screens/mark-TextQs/all-student-scripts.dart';

///Main mark textq screen
class AllTextQs extends StatefulWidget {
  @override
  _AllTextQsState createState() => _AllTextQsState();
}

class _AllTextQsState extends State<AllTextQs> {
  final db = DatabaseService();
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    final tData = Provider.of<TeacherUser>(context);
    return StreamBuilder<List<TextQAs>>(
      stream: db.streamTextQAs(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Text('error in stream text QA streambuilder');
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
        if (snap.hasData) {
          List<TextQAs> textAs = ts.getTeacherScripts(snap.data!, tData);

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
                        'Answer Scripts',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Proxima Nova',
                            color: Color.fromARGB(255, 76, 76, 76)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: textAs.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                '${textAs[i].assTitle}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 235, 215),
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                '${textAs[i].subject}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 235, 215),
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: ts.getTextQCheckedStat(
                                      tData, textAs[i].assId)
                                  ? null
                                  : Icon(
                                      Icons.pending_actions,
                                      color: Color.fromARGB(255, 250, 235, 215),
                                    ),
                              tileColor: ts.getColor(textAs[i].subject),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StudentAnswerScripts(
                                        textAs[i].assId,
                                        textAs[i].assTitle,
                                        textAs[i].subject,
                                        tData),
                                  ),
                                );
                              },
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
