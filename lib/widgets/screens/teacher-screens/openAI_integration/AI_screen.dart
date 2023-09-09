import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/service/openAi-service.dart';
import 'package:provider/provider.dart';

class CallChatGPT extends StatefulWidget {
  const CallChatGPT({Key? key}) : super(key: key);
  static const routeName = '/call-chatgpt';

  @override
  State<CallChatGPT> createState() => _CallChatGPTState();
}

class _CallChatGPTState extends State<CallChatGPT> {
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  String que = '';
  final _db = DatabaseService();
  String selectedBookname = "";
  Future<List<String>?>? futureData = DatabaseService().fetchBooknames();
  final aiService = AIPower();

  void saveForm() {
    setState(() {
      _formKey.currentState!.validate();
      _formKey.currentState!.save();
    });
  }

  // Future<String> getRes(String? query) async {
  //   String confirmed;

  //   if (query != null || query!.isNotEmpty) {
  //     confirmed = query;
  //     print('${aiService.getResponse(confirmed)}');
  //     return await aiService.getResponse(confirmed);
  //   } else {
  //     return 'error issue';
  //   }
  // }

  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<TeacherUser>(context);
    final db = Provider.of<DatabaseService>(context, listen: false);
    // List<String> booknames = db.fetchBooknames() as List<String>;

    bool isActive = false;
    if (teacher != null) {
      isActive = true;
    }
    List<MCQ>? mcqList;
    // aiService.testSplittint();
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Topic',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          key: ValueKey('topic'),
                          validator: (value) {
                            if (value!.isEmpty || value == '') {
                              return 'Please enter a question statement';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            que = value!;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Topic',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                          ),
                          maxLines: 3,
                          minLines: 2,
                        ),
                      ),
                      Text(
                        'Textbook',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      FutureBuilder<List<String>?>(
                        future: futureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No booknames found.'),
                            );
                          } else {
                            final booknames = snapshot.data!;
                            final int columns = 4;
                            List<Widget> rows = [];

                            for (int i = 0;
                                i < booknames.length;
                                i += columns) {
                              List<Widget> columnChildren = [];

                              for (int j = 0; j < columns; j++) {
                                if (i + j < booknames.length) {
                                  final bookname = booknames[i + j];
                                  final isSelected = selectedBookname ==
                                      bookname; // Check if it's selected

                                  // Wrap the Container with GestureDetector
                                  columnChildren.add(
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedBookname =
                                              bookname; // Update selected bookname
                                        });
                                      },
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: isSelected
                                                ? const Color.fromARGB(
                                                    255,
                                                    169,
                                                    208,
                                                    170) // Change color when selected
                                                : Colors
                                                    .transparent, // Default color
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              bookname,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }

                              rows.add(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: columnChildren,
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: rows,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 20,
                      ),
                      WhiteButtonMain(
                          child: 'Create',
                          onPressed: () {
                            setState(() {
                              // _formKey.currentState!.validate();
                              // _formKey.currentState!.save();
                              isTesting = true;
                            });
                          }),
                      if (isTesting == true)
                        Column(
                          children: [
                            Container(
                              child: FutureBuilder<List<MCQ>?>(
                                  future: aiService
                                      .mcq_generation(selectedBookname),
                                  builder: (ctx, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      print('waiting');
                                      return CircularProgressIndicator();
                                    }
                                    if (snap.connectionState ==
                                        ConnectionState.none) {
                                      print('none');
                                      return Container();
                                    }
                                    if (snap.connectionState ==
                                        ConnectionState.done) {
                                      print('done');
                                      mcqList = snap.data;
                                      print(teacher.uid);
                                      return Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            padding: EdgeInsets.all(16.0),
                                            child: ListView.builder(
                                              itemCount: mcqList!.length,
                                              itemBuilder: (context, index) {
                                                return buildMCQCard(
                                                    mcqList![index]);
                                              },
                                            ),
                                          ),
                                          RedButtonMain(
                                            child: 'Deploy to students',
                                            onPressed: () {
                                              print('snap data${snap.data}');
                                              print(teacher.uid);
                                              db.addAssessmentToCF(
                                                RemoteAssessment(
                                                    allMCQs: snap.data,
                                                    assessmentTitle:
                                                        'Offer and Acceptance',
                                                    subject: 'Trust',
                                                    teacherId: teacher.uid,
                                                    timeAdded: DateTime.now(),
                                                    deployTime: DateTime.now(),
                                                    deadline: DateTime.now()
                                                        .add(Duration(days: 1)),
                                                    allTextQs: []),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    print('no state');
                                    return Column(
                                      children: [],
                                    );
                                  }),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildMCQCard(MCQ mcq) {
    Set<String> seenIncorrectAnswers = {};
    String correctAnswer = mcq.answerChoices!['correct']!;

    Map<String, String> processedAns = {};

    mcq.answerChoices!.forEach((option, answer) {
      if (option != 'correct' &&
          answer != correctAnswer &&
          !seenIncorrectAnswers.contains(answer)) {
        seenIncorrectAnswers.add(answer);
        processedAns[option] = answer;
      }
    });
    processedAns["correct"] = correctAnswer;
    print(processedAns);

    return Card(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mcq.question!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Proxima Nova',
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: processedAns.entries.map((entry) {
                final option = entry.key;
                final answer = entry.value;
                final isCorrect = option == "correct";

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: isCorrect ? Color(0xffBAEDA9) : Colors.white,
                    title: Text(
                      answer,
                      style: TextStyle(fontFamily: 'Proxima Nova'),
                    ),
                    leading: isCorrect
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.radio_button_unchecked),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
