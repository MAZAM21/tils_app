import 'package:flutter/material.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:provider/provider.dart';

class ResultMain extends StatefulWidget {
  const ResultMain({Key key}) : super(key: key);

  @override
  _ResultMainState createState() => _ResultMainState();
}

class _ResultMainState extends State<ResultMain> {
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
            final resList = ts.getResults(snap.data, tData);

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Results',
                  style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 22,
                      color: Color(0xff2b3443)),
                ),
              ),
              body: ListView.builder(

                shrinkWrap: true,
                itemCount: resList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        '${resList[i].assTitle}',
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2b3443),
                        ),
                      ),
                      subtitle: Text(
                        '${resList[i].subject}',
                        style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontSize: 14,
                          color: Color(0xff2b3443),
                        ),
                      ),
                      onTap: (){},
                    ),
                  );
                },
              ),
            );
          }
          return Text('No Data, contact Dev');
        });
  }
}
