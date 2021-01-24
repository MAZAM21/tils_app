import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/service/teachers-service.dart';

class AnswerChoiceInput extends StatefulWidget {
  static const routeName = '/answer-choice-input';

  @override
  _AnswerChoiceInputState createState() => _AnswerChoiceInputState();
}

class _AnswerChoiceInputState extends State<AnswerChoiceInput> {
  Map<String, String> answerChoices = {};
  final correctController = TextEditingController();
  final wrongController = TextEditingController();
  bool _correctEnabled = true;
  final ts = TeacherService();
  int x = 0;
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    correctController.dispose();
    wrongController.dispose();
    super.dispose();
  }

  void addWrongChoice(String choice) {
    answerChoices.addAll({'$x': choice});

    print('${answerChoices['$x']}');
    x++;
  }

  void saveToAssessment(String que) {
    final isValid = _formKey.currentState.validate();
    _formKey.currentState.save();
    if (answerChoices.isNotEmpty && isValid) {
      Provider.of<RemoteAssessment>(context, listen: false)
          .addMCQ(MCQ(question: que, answerChoices: answerChoices));

      _formKey.currentState.reset();
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Enter values to save'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final que = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveToAssessment(que);
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$que',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ),
                      Text('Enter Correct Answer Choice'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        enabled: _correctEnabled,
                        controller: correctController,
                        minLines: 2,
                        maxLines: 5,
                        key: ValueKey('correct ans'),
                        validator: (value) {
                          if (value.isEmpty || value == ' ') {
                            return 'Please enter correct answer choice';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Correct Choice',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Add Correct Choice'),
                        onPressed: () {
                          setState(() {
                            answerChoices['correct'] = correctController.text;
                            _correctEnabled = false;
                          });
                          print('${answerChoices['correct']}');
                        },
                      ),
                      Text('Enter Incorrect Answer Choice(s)'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        enabled: !_correctEnabled,
                        controller: wrongController,
                        minLines: 2,
                        maxLines: 5,
                        key: ValueKey('wrong ans'),
                        validator: (value) {
                          if (value == ' ') {
                            return 'Please enter correct answer choice';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Incorrect Choice',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Add Choice'),
                        onPressed: () {
                          setState(() {
                            addWrongChoice(wrongController.text);
                          });
                          wrongController.clear();
                        },
                      ),
                      Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: answerChoices.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              tileColor:
                                  ts.keyList(answerChoices)[i] == 'correct'
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                              title: Text(ts.valueList(answerChoices)[i]),
                              subtitle: Text(ts.keyList(answerChoices)[i]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
