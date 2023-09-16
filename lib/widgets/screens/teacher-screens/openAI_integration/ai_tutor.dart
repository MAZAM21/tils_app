import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/service/openAi-service.dart';

class AITutor extends StatefulWidget {
  const AITutor({Key? key}) : super(key: key);
  static const routeName = '/ai-tutor';

  @override
  State<AITutor> createState() => _CallChatGPTState();
}

class _CallChatGPTState extends State<AITutor> {
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  String que = '';
  String selectedBookname = "";
  Future<List<String>?>? futureData = DatabaseService().fetchBooknames();
  final aiService = AIPower();

  void saveForm() {
    setState(() {
      _formKey.currentState!.validate();
      _formKey.currentState!.save();
    });
  }

  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Textbook',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                FutureBuilder<List<String>?>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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

                      for (int i = 0; i < booknames.length; i += columns) {
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
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected
                                          ? const Color.fromARGB(255, 169, 208,
                                              170) // Change color when selected
                                          : Colors.transparent, // Default color
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
                Text(
                  'Question',
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
                    onChanged: (value) {
                      que = value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    maxLines: 3,
                    minLines: 2,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 20,
                ),
                WhiteButtonMain(
                    child: 'Ask',
                    onPressed: () {
                      setState(() {
                        isTesting = true;
                      });
                    }),
                if (isTesting == true)
                  Container(
                    child: FutureBuilder<String?>(
                      future: aiService.ai_tutor(selectedBookname, que),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          print('waiting');
                          return CircularProgressIndicator();
                        }
                        if (snap.connectionState == ConnectionState.none) {
                          print('none');
                          return Container();
                        }
                        if (snap.connectionState == ConnectionState.done) {
                          print("done");
                          return Text(snap.data!);
                        }
                        print('no state');
                        return Column(
                          children: [],
                        );
                      },
                    ),
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
