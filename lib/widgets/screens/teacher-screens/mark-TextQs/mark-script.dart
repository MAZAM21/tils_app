import 'package:flutter/material.dart';
import 'package:tils_app/models/student-textAnswers.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';

import 'package:tils_app/widgets/screens/teacher-screens/mark-TextQs/mark-individual-qa.dart';

class MarkScript extends StatefulWidget {
  final StudentTextAns ans;
  final String assid;
  final String? subject;
  final String teacherId;
  MarkScript(
    this.ans,
    this.assid,
    this.subject,
    this.teacherId,
  );
  @override
  _MarkScriptState createState() => _MarkScriptState();
}

class _MarkScriptState extends State<MarkScript> {
  double initval = 0;
  Map<String, int> aggMarks = {};
  final ts = TeacherService();
  final db = DatabaseService();
  int totalMarks = 0;
  bool savedToRAResult = false;

  @override
  void didChangeDependencies() {
    StudentTextAns sta = widget.ans;
    int l = sta.qaMap.length;
    List<int?> markList = ts.getMarksList(sta.qMarks!, l)!;
    var totalE = markList.fold(0, (dynamic p, n) => p + n);
    if(totalE>0) {
      totalMarks = totalE;
      print(totalMarks);
      print('workd');
    }
    super.didChangeDependencies();
  }

  void aggregateAllMarks(
    String q,
    int mark,
  ) {
    savedToRAResult = true;
    aggMarks.addAll({q: mark});
    totalMarks = aggMarks.values.fold(0, (t, a) => t + a);
    print(totalMarks);
  }

  Widget buildQA(
    String question,
    String answer,
    double? mark,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Q: $question',
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  'Ans: $answer',
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: SfSlider(
                interval: 10,
                stepSize: 1.0,
                showLabels: true,
                min: 0.0,
                max: 100.0,
                value: initval,
                enableTooltip: true,
                onChanged: (dynamic val) {
                  setState(() {
                    mark = val;
                  });
                  // print(mark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// questionList is derived from the qaMap, it is separated so as to make the code readable and simpler
    /// same applies to answer list
    /// for marks, the object is first imported from database so as to check if it has already been marked,
    /// the marks map has questions for keys and marks for values.
    /// marks will be a seperate list, the indexes of questionlist and marklist will be matched by ts function

    StudentTextAns sta = widget.ans;
    List<String> questionList = sta.qaMap.keys.toList();
    List<String> answerList = sta.qaMap.values.toList();

    int l = sta.qaMap.length;
    List<int?>? markList = ts.getMarksList(sta.qMarks!, l);
    print(markList);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () {
          if (totalMarks == 0 && savedToRAResult) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        'You have not properly added marks, please press the save button beneath the answer first'),
                  );
                });
          } else if (totalMarks == 0 && markList!.isNotEmpty){}
          print('adding to db: $totalMarks');
            db.addTotalMarkToStudent(totalMarks, sta.studentId, widget.assid,
                widget.subject, widget.teacherId);
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var x = 0; x < l; x++)
                    MarkIndividualQA(
                      sta.studentId,
                      widget.assid,
                      questionList[x],
                      answerList[x],
                      markList![x],
                      aggregateAllMarks,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
