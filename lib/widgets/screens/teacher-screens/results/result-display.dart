import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/student-answers.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

/// The main result page navigated to from the home
/// displays list of all assessments
/// gets a stream of assessments
class ResultsDisplay extends StatefulWidget {
  final String assid;
  final String title;
  final String subject;
  final List<StudentRank> studList;
  const ResultsDisplay({
    this.assid,
    this.title,
    this.studList,
    this.subject,
  });

  @override
  State<ResultsDisplay> createState() => _ResultsDisplayState();
}

class _ResultsDisplayState extends State<ResultsDisplay> {
  final db = DatabaseService();
  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudentAnswers>>(
        stream: db.streamResFromID(widget.assid),
        builder: (context, snap) {
          if (snap.hasError) {
            print('error in Result display streambuilder: ${snap.error}');
            return Text('error in stream text QA streambuilder: ${snap.error}');
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (widget.studList.isEmpty) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No Students')],
              ),
            );
          }
          if (snap.hasData && widget.studList != null) {
            List<StudentAnswers> studAns = snap.data;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${widget.title}',
                  style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 22,
                      color: Color(0xff2b3443)),
                ),
              ),
              body: ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, i) {
                    String imageURL = '';
                    StudentRank stud = widget.studList.firstWhere(
                        (element) =>
                            studAns[i].studentId == element.id &&
                            element.imageUrl.isNotEmpty, orElse: () {
                      return null;
                    });
                    if (stud != null) {
                      imageURL = stud.imageUrl;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        onTap: () {
                          resultDetail(context, studAns[i]);
                        },
                        tileColor: Colors.white,
                        leading: imageURL != ''
                            ? CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(imageURL),
                              )
                            : Icon(
                                Icons.person,
                                size: 36,
                              ),
                        title: Text(
                          "${studAns[i].name}",
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2b3443),
                          ),
                        ),
                        trailing: Text(
                          'MCQ: ${studAns[i].mcqMarks} Text Question: ${studAns[i].totalQMarks}',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 18,
                            color: Color(0xff2b3443),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          return null;
        });
  }

  Future<dynamic> resultDetail(BuildContext context, StudentAnswers ans) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34),
            topLeft: Radius.circular(34),
          ),
        ),
        builder: (BuildContext ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  if (ans.mcqAnsMap.isNotEmpty)
                    for (var i = 0; i < ans.mcqAnsMap.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                '${ans.mcqAnsMap.keys.toList()[i]}',
                                style: TextStyle(
                                  fontFamily: 'Proxima Nova',
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${mcqStatus(ans.mcqAnsMap.values.toList()[i])}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                color: ans.mcqAnsMap.values.toList()[i] ==
                                        'correct'
                                    ? Colors.green[800]
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                ],
              ),
            ),
          );
        });
  }

  String mcqStatus(String stat) {
    switch (stat) {
      case 'correct':
        return 'Correct';
      default:
        return 'Incorrect';
    }
  }
}
