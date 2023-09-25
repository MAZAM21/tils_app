import 'package:SIL_app/models/books.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/upload-book.dart';
import 'package:provider/provider.dart';
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
    List<Widget> columnChildren = [];
    final teacherData = Provider.of<TeacherUser>(context);
    final db = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Color.fromARGB(255, 230, 235, 235), actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: RouteSettings(name: '/upload-textbook'),
                  builder: (BuildContext context) =>
                      ChangeNotifierProvider.value(
                    value: teacherData,
                    child: UploadTextbook(),
                  ),
                ),
              );
            },
            child: Text(
              'Upload Book',
              style: Theme.of(context).textTheme.titleLarge,
            ))
      ]),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                StreamBuilder<List<Books?>>(
                  stream: db.streamBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(child: CircularProgressIndicator()),
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
                      final List<Books?> booknames = snapshot.data!;
                      //final int columns = 4;

                      for (int j = 0; j < booknames.length; j++) {
                        if (j < booknames.length) {
                          final bookname = booknames[j]!.name;
                          final isSelected = selectedBookname ==
                              bookname; // Check if it's selected

                          // Wrap the Container with GestureDetector
                          columnChildren.add(
                            ListTile(
                              title: Text('$bookname'),
                              enabled: true,
                              selected: bookname == selectedBookname,
                              selectedColor: Colors.red,
                              onFocusChange: (value) => isSelected,
                              onTap: () {
                                setState(() {
                                  isTesting = false;
                                  selectedBookname =
                                      bookname; // Update selected bookname
                                });
                              },
                            ),
                          );
                        }
                      }

                      return Drawer(
                        backgroundColor: Color.fromARGB(255, 230, 235, 235),
                        child: ListView(children: columnChildren),
                      );
                    }
                  },
                ),
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    if (isTesting == true)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: FutureBuilder<String?>(
                          future: aiService.ai_tutor(selectedBookname, que),
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              print('waiting');
                              return Container(
                                  child: CircularProgressIndicator());
                            }
                            if (snap.connectionState == ConnectionState.none) {
                              print('none');
                              return Container();
                            }
                            if (snap.connectionState == ConnectionState.done) {
                              print("done");
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: SelectableText(
                                            snap.data!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            }
                            print('no state');
                            return Column(
                              children: [],
                            );
                          },
                        ),
                      ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //Spacer(),
                              Container(
                                color: Theme.of(context).canvasColor,
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextFormField(
                                        key: ValueKey('que'),
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
                                            borderSide: BorderSide(
                                                color: Colors.indigo),
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
                                        if (que.isNotEmpty &&
                                            selectedBookname.isNotEmpty) {
                                          setState(() {
                                            isTesting = true;
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text(
                                                  'Inputs not present: Select a book and ask a question'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
