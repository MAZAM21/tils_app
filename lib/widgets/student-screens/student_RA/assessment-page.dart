

import 'package:flutter/material.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/student-service.dart';

class AssessmentPage extends StatefulWidget {
  final String uid;
  final RAfromDB ra;
  AssessmentPage(this.ra, this.uid);

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final _ss = StudentService();
  final _db = DatabaseService();
  final _ansController = TextEditingController();

  String _question;
  Map _answers;
  int _qIndex = 0;
  String _selectedStat;
  String _selectedAns;

  void dispose() {
    _ansController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _question = _ss.getQuestion(widget.ra, _qIndex);
    _answers = _ss.getAnswers(widget.ra, _qIndex);
    print('$_answers');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: _question != null ? Icon(Icons.save) : Icon(Icons.exit_to_app),
        onPressed: _question != null
            ? () {
                //if ans not equal to null, will execute mcq submission else will execute text q submission
                if (_answers != null) {
                  if (_selectedAns != null) {
                    _db.addMCQAnswer(
                      _question,
                      _selectedStat,
                      _selectedAns,
                      widget.ra.id,
                      widget.uid,
                      widget.ra.assessmentTitle,
                    );
                    setState(() {
                      _qIndex++;
                      _selectedStat = null;
                      _selectedAns = null;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text('Select an option'),
                      ),
                    );
                  }
                } else {
                  if (_ansController.text.isNotEmpty) {
                    _db.addTextQAnswer(_question, _ansController.text,
                        widget.ra.id, widget.uid, widget.ra.assessmentTitle);
                    setState(() {
                      _ansController.clear();
                      _qIndex++;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text('Enter an answer'),
                      ),
                    );
                  }
                }
              }
            : () {
                Navigator.pop(context);
              },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsetsDirectional.only(
                  top: 100, start: 10, end: 10, bottom: 10),
              title: SingleChildScrollView(
                child: _question != null
                    ? Text(
                        '$_question',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                        ),
                      )
                    : Text(
                        'Assessment Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
              ),
            ),
            automaticallyImplyLeading: _question != null ? false : true,
          ),
          SliverFixedExtentList(
            itemExtent: 150,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _answers != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            color:
                                _selectedAns == _answers.values.toList()[index]
                                    ? Colors.redAccent
                                    : Colors.lightBlue[100],
                            child: Text(
                              '${_answers.values.toList()[index]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Proxima Nova',
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedStat = _answers.keys.toList()[index];
                              _selectedAns = _answers.values.toList()[index];
                            });
                            print('$_selectedStat');
                          },
                        ),
                      )
                    : _question != null
                        ? Container(
                            height: 150,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _ansController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  labelText: 'Answer',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null;
              },
              childCount: _answers != null ? _answers.keys.toList().length : 1,
            ),
          ),
        ],
      ),
    );
  }
}
