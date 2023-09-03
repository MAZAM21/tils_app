import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/service/openAi-service.dart';
import 'package:provider/provider.dart';

class MarkAnswers extends StatefulWidget {
  const MarkAnswers({Key? key}) : super(key: key);
  static const routeName = '/mark-answers';

  @override
  State<MarkAnswers> createState() => _CallChatGPTState();
}

class _CallChatGPTState extends State<MarkAnswers> {
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  String que = '';

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
    final teacher = Provider.of<TeacherUser>(context);
    // final db = Provider.of<DatabaseService>(context, listen: false);

    List<Marks>? marksList;
    // aiService.testSplittint();
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
                  'Marking Criteria',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    key: ValueKey('criteria'),
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
                      labelText: 'Criteria',
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
                    child: 'Upload Files',
                    onPressed: () {
                      setState(() {
                        if (que != "") {
                          isTesting = true;
                        }
                      });
                    }),
                if (isTesting == true)
                  Column(
                    children: [
                      Container(
                        child: FutureBuilder<List<Marks>?>(
                            future: aiService.pickAndUploadFiles(que),
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
                                marksList = snap.data;
                                print(teacher.uid);
                                return Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.67,
                                      padding: EdgeInsets.all(16.0),
                                      child: ListView.builder(
                                        itemCount: marksList!.length,
                                        itemBuilder: (context, index) {
                                          return buildMarksCard(
                                              marksList![index]);
                                        },
                                      ),
                                    ),
                                    RedButtonMain(
                                      child: 'Deploy to students',
                                      onPressed: () {
                                        print('snap data${snap.data}');
                                        print(teacher.uid);
                                        // Add your logic here to deploy marks to students
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

  Widget buildMarksCard(Marks marks) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marks Details',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Divider(), // Add a horizontal line for separation

            // Display each key-value pair
            for (var entry in marks.marksJson!.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criteria: ${entry.key}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  if (entry.key !=
                      marks.marksJson!.keys.last) // Check if it's the last key
                    Text(
                      'Marks: ${entry.value}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  if (entry.key ==
                      marks.marksJson!.keys
                          .last) // Display only the value for the last key
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  SizedBox(height: 12.0),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
