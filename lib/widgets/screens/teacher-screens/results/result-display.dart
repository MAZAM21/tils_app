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
          if (snap.hasData) {
            List<StudentAnswers> studAns = snap.data;

            return Scaffold(
              appBar: AppBar(),
              body: ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, i) {
                    String imageURL = widget.studList
                            .firstWhere(
                                (element) => studAns[i].studentId == element.id)
                            .imageUrl;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(imageURL),
                      ),
                      title: Text("${studAns[i].name}"),
                      trailing: Text('MCQ: ${studAns[i].mcqMarks} Text Question: ${studAns[i].totalQMarks}'),
                    );
                  }),
            );
          }
          return null;
        });
  }
}
