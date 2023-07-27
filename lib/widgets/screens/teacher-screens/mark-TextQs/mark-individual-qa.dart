import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tils_app/service/db.dart';

class MarkIndividualQA extends StatefulWidget {
  final stuId;
  final assid;
  final question;
  final answer;
  final int? mark;
  final void Function(String q, int m) aggMarks;
  MarkIndividualQA(
      this.stuId, this.assid, this.question, this.answer, this.mark, this.aggMarks);
  @override
  _MarkIndividualQAState createState() => _MarkIndividualQAState();
}

class _MarkIndividualQAState extends State<MarkIndividualQA> {
  final db = DatabaseService();
  double? _initval;
  bool _isInit = false;
  @override
  void initState() {
    _isInit = true;
    if (widget.mark != 0) {
      _initval = widget.mark!.toDouble();
    } else {
      _initval = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Q: ${widget.question}',
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
                  'Ans: ${widget.answer}',
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
                value: _initval,
                enableTooltip: true,
                onChanged: (dynamic val) {
                  setState(() {
                    _initval = val;
                  });
                  // print(mark);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Save Mark'),
                    onPressed: () {
                      setState(() {
                        _isInit = false;
                      });
                      widget.aggMarks(widget.question, _initval!.toInt());
                      db.addMarksToTextAns(
                        '${widget.question}',
                        _initval!.toInt(),
                        widget.assid,
                        widget.stuId,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_initval!.toInt()}',
                      style: TextStyle(
                          fontFamily: 'Proxima Nova',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _isInit ? Colors.black : Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 5,
            ),
          ],
        ),
      ),
    );
  }
}
