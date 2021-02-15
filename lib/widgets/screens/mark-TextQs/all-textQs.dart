import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/mark-TextQs/all-student-scripts.dart';

class AllTextQs extends StatefulWidget {
  @override
  _AllTextQsState createState() => _AllTextQsState();
}

class _AllTextQsState extends State<AllTextQs> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
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
          List<TextQAs> textAs = [];
          snap.data.forEach((q) {
            if (q.isText) {
              textAs.add(q);
            }
          });
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
                        'Answer Scripts',
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
                        itemCount: textAs.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                child: ListTile(
                                  title: Text('${textAs[i].assTitle}'),
                                  tileColor: Colors.teal[100],
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentAnswerScripts(
                                                    textAs[i].assId,
                                                    textAs[i].assTitle)));
                                  },
                                ),
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
