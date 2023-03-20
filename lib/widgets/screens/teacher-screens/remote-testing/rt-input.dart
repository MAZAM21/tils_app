import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/answer-choice-input.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/start-end-time.dart';

///This is the main RA creation page where you input questions
class RemoteAssessmentInput extends StatefulWidget {
  static const routeName = '/remote-assessment-input';
  @override
  _RemoteAssessmentInputState createState() => _RemoteAssessmentInputState();
}

class _RemoteAssessmentInputState extends State<RemoteAssessmentInput> {
  final db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();

  bool _isMCQ = true;
  String question;

  void initState() {
    Provider.of<RemoteAssessment>(context, listen: false).allMCQs = [];
    Provider.of<RemoteAssessment>(context, listen: false).allTextQs = [];
    super.initState();
  }

  void dispose() {
    queController.dispose();
    super.dispose();
  }

  void _saveAssessment() {
    _formKey.currentState.save();
    bool isValid = _formKey.currentState.validate();
    if (Provider.of<RemoteAssessment>(context, listen: false).validate()) {
      db.addAssessmentToCF(
          Provider.of<RemoteAssessment>(context, listen: false));
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Some fields are missing, try again'),
            );
          });
    }
  }

  void _addStartEndTime(
    DateTime _start,
    DateTime _end,
  ) {
    setState(() {
      Provider.of<RemoteAssessment>(context, listen: false).deployTime = _start;
      Provider.of<RemoteAssessment>(context, listen: false).deadline = _end;
    });
  }

  void showDeploySheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StartEndTime(_addStartEndTime);
        });
  }

  @override
  Widget build(BuildContext context) {
    final assessment = Provider.of<RemoteAssessment>(context);
    final routeArgs = ModalRoute.of(context).settings.arguments as Map;
    assessment.subject = routeArgs['sub'];
    assessment.teacherId = routeArgs['id'];
    assessment.timeAdded = routeArgs['time'];

    // for (var x = 0; x < assessment.allMCQs.length; x++) {
    //   print('${assessment.allMCQs[x].question}');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remote Assessment',
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Save', style: Theme.of(context).textTheme.headline3),
            onPressed: () {
              _saveAssessment();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text(
                      'Assessment Title',
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Title input text field
                    TextFormField(
                      key: ValueKey('assessment-title'),
                      validator: (value) {
                        if (value.isEmpty || value == '') {
                          return 'Please enter an assessment title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        assessment.assessmentTitle = value;
                      },
                      initialValue: '',
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Enter Question',
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Question input text field
                    TextFormField(
                      controller: queController,
                      key: ValueKey('question'),
                      validator: (value) {
                        if (value.isEmpty || value == '') {
                          return 'Please enter a question statement';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (!_isMCQ) {}
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Question',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _isMCQ ? Colors.indigo : Colors.teal),
                        ),
                      ),
                      maxLines: 3,
                      minLines: 2,
                    ),
                    SizedBox(height: 20,),
                    if (_isMCQ)
                      RedButtonMain(child: 'Add Answer Choices', onPressed: () {
                          _formKey.currentState.save();

                          if (queController.text.isNotEmpty) {
                            Navigator.pushNamed(
                                context, AnswerChoiceInput.routeName,
                                arguments: queController.text);
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text('Enter a question first dummy'),
                              ),
                            );
                          }
                        },),
                     
                    if (!_isMCQ)
                      ElevatedButton(
                        child: Text('Add Question'),
                        onPressed: () {
                          if (queController.text.isNotEmpty) {
                            setState(() {
                              assessment.allTextQs.add('${queController.text}');
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text('Enter a question first dummy'),
                              ),
                            );
                          }
                        },
                      ),
                    Switch(
                      value: _isMCQ,
                      onChanged: (option) {
                        setState(() {
                          _isMCQ = option;
                        });
                      },
                      inactiveThumbColor: Colors.teal,
                      inactiveTrackColor: Colors.tealAccent,
                      activeColor: Colors.indigo,
                    ),
                    Text(_isMCQ ? 'MCQ' : 'Text'),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Add Deploy Time (Optional)',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () {
                            setState(() {
                              showDeploySheet();
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            Container(
                              child: assessment.deployTime == null
                                  ? Text(
                                      'Not Deployed',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      '${DateFormat('MMM d - hh:mm a').format(assessment.deployTime)} \n to \n ${DateFormat('MMM d - hh:mm a').format(assessment.deadline)}',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    assessment.deployTime = null;
                                    assessment.deadline = null;
                                  });
                                },
                                icon: Icon(Icons.delete)),
                            Spacer(),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo)),
                      height: 200,
                      child: ListView.builder(
                        itemCount: assessment.allMCQs.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(
                              '${assessment.allMCQs[i].question}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                                '${assessment.allMCQs[i].answerChoices.length}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                assessment.deleteMCQ(assessment.allMCQs[i]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.teal)),
                      height: 200,
                      child: ListView.builder(
                        itemCount: assessment.allTextQs.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(
                              '${assessment.allTextQs[i]}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('${assessment.allTextQs[i]}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  assessment.allTextQs.removeAt(i);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* 
Basic structure: 
  choose subject -> 
  rt input page (input title and question here, displays added questions, choose between text and mcq) ->
  input answer options ->
  save
  
  then db is called

*/