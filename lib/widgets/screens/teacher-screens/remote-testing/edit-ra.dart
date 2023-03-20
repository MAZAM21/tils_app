import 'package:flutter/material.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/service/teachers-service.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/deploy-assessment.dart';

///this is the overview and deployment page

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
        width: double.infinity,
        color: Color.fromARGB(50, 172, 216, 211),
        height: 350,
        child: mcqList.isEmpty
            ? Text(
                'No MCQs',
                style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              )
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
                                  color: Color(0xff27415f),
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
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Answer Choices:\n${ts.mapToStrings(mcqList[i].answerChoices)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 16,
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
        width: double.infinity,
        color: Color.fromARGB(50, 172, 216, 211),
        height: 350,
        child: textQList.isEmpty
            ? Text(
                'No questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
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
                                  color: Color(0xff27415f),
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
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              db.deleteAssessment(widget.ra.id);
                              Navigator.pop(context);
                            },
                            child: Text('Yes, Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Exit'),
                          )
                        ],
                        title: Text(
                            'Are you sure you want to delete this assessment?'),
                      );
                    });
              });

              //Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.915,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${widget.ra.assessmentTitle}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xffc54134)),
                    ),
                    child: Text(
                      'Deploy',
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.bold,
                        ),
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
