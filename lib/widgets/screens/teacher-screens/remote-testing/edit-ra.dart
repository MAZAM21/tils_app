import 'package:flutter/material.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';

import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/deploy-assessment.dart';

class EditRA extends StatefulWidget {
  final RAfromDB ra;
  EditRA(this.ra);

  @override
  _EditRAState createState() => _EditRAState();
}

class _EditRAState extends State<EditRA> {
  final db = DatabaseService();

  final ts = TeacherService();

  Widget buildMCQListTile(List<MCQ> mcqList) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromARGB(50, 172, 216, 211),
        height: 350,
        child: mcqList.isEmpty
            ? Text('No MCQs')
            : ListView.builder(
                itemCount: mcqList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Q: \n${mcqList[i].question}',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Card(
                                  color: Color.fromARGB(255, 255, 202, 177),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Answer Choices:\n ${ts.mapToStrings(mcqList[i].answerChoices)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildTextQListTile(List<String> textQList) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromARGB(50, 172, 216, 211),
        height: 350,
        child: textQList.isEmpty
            ? Text('No questions')
            : ListView.builder(
                itemCount: textQList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Q: \n${textQList[i]}',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void showDeploySheet(String assid) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return DeployAssessment(assid);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              db.deleteAssessment(widget.ra.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${widget.ra.assessmentTitle}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text('Choose Deployment Time'),
                    onPressed: () {
                      showDeploySheet(widget.ra.id);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'MCQs:',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                  buildMCQListTile(widget.ra.allMCQs),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Text Questions:',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                  buildTextQListTile(widget.ra.allTextQs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
