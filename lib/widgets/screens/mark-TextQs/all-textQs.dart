import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/mark-TextQs/all-student-scripts.dart';

class AllTextQs extends StatefulWidget {
  @override
  _AllTextQsState createState() => _AllTextQsState();
}

class _AllTextQsState extends State<AllTextQs> {
  final db = DatabaseService();
  final ts = TeacherService();
  Color getColor(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return Color.fromARGB(255, 56, 85, 89);
        break;
      case 'Trust':
        return Color.fromARGB(255, 68, 137, 156);
        break;
      case 'Conflict':
        return Color.fromARGB(255, 37, 31, 87);
        break;
      case 'Islamic':
        return Color.fromARGB(255, 39, 59, 92);
        break;
      case 'Company':
        return Color.fromARGB(255, 50, 33, 58);
        break;
      case 'Tort':
        return Color.fromARGB(255, 56, 59, 83);
        break;
      case 'Property':
        return Color.fromARGB(255, 102, 113, 126);
        break;
      case 'EU':
        return Color.fromARGB(255, 206, 185, 146);
        break;
      case 'HR':
        return Color.fromARGB(255, 143, 173, 136);
        break;
      case 'Contract':
        return Color.fromARGB(255, 36, 79, 38);
        break;
      case 'Criminal':
        return Color.fromARGB(255, 37, 109, 27);
        break;
      case 'LSM':
        return Color.fromARGB(255, 189, 213, 234);
        break;
      case 'Public':
        return Color.fromARGB(255, 201, 125, 96);
        break;
      default:
        return Colors.black;
    }
  }

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
          List<TextQAs> textAs = ts.getTeacherScripts(snap.data, tData);

          return Scaffold(
            appBar: AppBar(),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.87,
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
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                child: ListTile(
                                  title: Text(
                                    '${textAs[i].assTitle}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 250, 235, 215),
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    '${textAs[i].subject}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 250, 235, 215),
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: textAs[i].marked
                                      ? Icon(
                                          Icons.check,
                                          color: Color.fromARGB(
                                              255, 250, 235, 215),
                                        )
                                      : Icon(
                                          Icons.pending_actions,
                                          color: Color.fromARGB(
                                              255, 250, 235, 215),
                                        ),
                                  tileColor: getColor(textAs[i].subject),
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
