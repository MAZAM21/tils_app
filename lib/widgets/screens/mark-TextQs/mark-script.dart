import 'package:flutter/material.dart';
import 'package:tils_app/models/student-textAnswers.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MarkScript extends StatefulWidget {
  final StudentTextAns ans;
  final String assid;
  MarkScript(this.ans, this.assid);
  @override
  _MarkScriptState createState() => _MarkScriptState();
}

class _MarkScriptState extends State<MarkScript> {
  double mark = 0;
  Widget buildQA(
    String question,
    String answer,
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
                value: mark,
                enableTooltip: true,
                onChanged: (val) {
                  setState(() {
                    mark = val;
                  });
                  print(mark);
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
    StudentTextAns sta = widget.ans;
    List<String> questionList = sta.qaMap.keys.toList();
    List<String> answerList = sta.qaMap.values.toList();
    List<double> markList;
    int l = sta.qaMap.length;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: <Widget>[
                  for (var x = 0; x < l; x++)
                    buildQA(
                      questionList[x],
                      answerList[x],
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
