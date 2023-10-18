import 'package:SIL_app/models/books.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
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
  bool isCodeExecuted = false;
  bool isBatch = false;
  String chat_id = "";
  Map<String, List<Widget>> chat_history = {};
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  String que = '';
  String selectedBookname = "";
  Map<String, String> convo = {};
  List<String> history = [];
  Set<String> selectedBookBatch = {};

  final aiService = AIPower();

  void saveForm() {
    setState(() {
      _formKey.currentState!.validate();
      _formKey.currentState!.save();
    });
  }

  void handleBookTileTap(Books book) {
    if (isBatch == false) {
      setState(() {
        isTesting = false;
        selectedBookname = book.name;
      });
    } else {
      setState(() {
        if (!selectedBookBatch.contains(book.name)) {
          selectedBookBatch.add(book.name);
        } else {
          selectedBookBatch.remove(book.name);
        }
      });
    }
  }

  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser?>(context);
    //final db = Provider.of<DatabaseService>(context);
    final books = Provider.of<List<Books>>(context);
    Map<String?, List<Books>> categorizedBooks = {};
    List<Books> booksWithoutCategory = [];

    Map<String, FocusNode> entryFocusNodes = {};
    final organizedBooks = aiService.alphabeticalSort(books);

    for (var book in organizedBooks) {
      if (book.category!.isEmpty) {
        booksWithoutCategory.add(book);
      } else {
        categorizedBooks.putIfAbsent(book.category, () => []).add(book);
      }
    }

    return Scaffold(
      appBar:
          AppBar(backgroundColor: Color.fromARGB(255, 230, 235, 235), actions: [
        Spacer(),
        Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: '/upload-textbook'),
                builder: (BuildContext context) => ChangeNotifierProvider.value(
                  value: teacherData,
                  child: UploadTextbook(),
                ),
              ),
            );
          },
          child: Text(
            'Upload Book',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Drawer(
                  width: 200,
                  backgroundColor: Color.fromARGB(255, 230, 235, 235),
                  child: ListView(children: [
                    if (booksWithoutCategory.isNotEmpty)
                      ExpansionTile(
                        textColor: Color.fromRGBO(22, 22, 22, 1),
                        title: Text('Books without Category'),
                        children: booksWithoutCategory
                            .map(
                              (book) => ListTile(
                                title: Text(
                                  book.name,
                                  style: TextStyle(
                                    color: selectedBookname == book.name ||
                                            selectedBookBatch
                                                .contains(book.name)
                                        ? Colors.red
                                        : Color(0xff161616),
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  handleBookTileTap(book);
                                },
                                selectedColor: Colors.red,
                                selected: selectedBookname == book.name ||
                                    selectedBookBatch.contains(book.name),
                                subtitle: Text(
                                  'Author: ${book.author}',
                                  style: TextStyle(
                                      color: selectedBookname == book.name ||
                                              selectedBookBatch
                                                  .contains(book.name)
                                          ? Colors.red
                                          : Color(0xff161616),
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    for (var entry in categorizedBooks.entries)
                      ExpansionTile(
                        textColor: Color(0xff161616),
                        title: Text(entry.key ??
                            'Unknown Category'), // Category title or 'Unknown Category' if null
                        children: entry.value
                            .map(
                              (book) => ListTile(
                                title: Text(
                                  book.name,
                                  style: TextStyle(
                                    color: selectedBookname == book.name ||
                                            selectedBookBatch
                                                .contains(book.name)
                                        ? Colors.red
                                        : Color(0xff161616),
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Author: ${book.author}',
                                  style: TextStyle(
                                      color: selectedBookname == book.name ||
                                              selectedBookBatch
                                                  .contains(book.name)
                                          ? Colors.red
                                          : Color(0xff161616),
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                onTap: () {
                                  handleBookTileTap(book);
                                },
                                selected: selectedBookname == book.name ||
                                    selectedBookBatch.contains(book.name),
                                selectedColor: Colors.red,
                              ),
                            )
                            .toList(),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Batch Query',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Switch(
                        value: isBatch,
                        onChanged: (value) {
                          setState(() {
                            isBatch = value;
                            if (isBatch == false) {
                              selectedBookBatch.clear();
                            } else {
                              selectedBookname = '';
                            }
                          });
                        })
                  ]),
                ),
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    if (isTesting == true)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,

                        ///Single book answer

                        child: FutureBuilder<Map<dynamic, dynamic>?>(
                          future: isBatch
                              ? aiService.compare(
                                  selectedBookBatch,
                                  que,
                                )
                              : aiService.ai_tutor_persistent(
                                  selectedBookname,
                                  que,
                                ),
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              print('waiting');
                              return SingleChildScrollView(
                                reverse: true,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Column(
                                          children: convo.entries
                                              .map((e) => Column(
                                                    children: [
                                                      SelectableText(
                                                        '\n${e.key}: \n\n',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .deepOrange[800],
                                                          fontFamily:
                                                              'RobotoCondensed',
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      SelectableText(
                                                          '${e.value} \n'),
                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator()),
                                  ],
                                ),
                              );
                            }
                            if (snap.connectionState == ConnectionState.none) {
                              print('none');
                              return Container();
                            }

                            if (snap.connectionState == ConnectionState.done) {
                              print("done");

                              history.add(snap.data!['answer']);

                              convo.addAll({'$que': snap.data!['answer']});

                              chat_history.addAll({
                                selectedBookname: convo.entries
                                    .map((e) => Column(
                                          children: [
                                            SelectableText(
                                              '\n${e.key}: \n\n',
                                              style: TextStyle(
                                                color: Colors.deepOrange[800],
                                                fontFamily: 'RobotoCondensed',
                                                fontSize: 24,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SelectableText('${e.value} \n'),
                                          ],
                                        ))
                                    .toList(),
                              });
                              print(chat_history[selectedBookname]);
                              if (convo.isNotEmpty) {
                                for (var entry in convo.entries) {
                                  entryFocusNodes[entry.key] = FocusNode();
                                }
                              }
                              isTesting = false;

                              // Request focus on the last FocusNode after the frame is built

                              return SingleChildScrollView(
                                // reverse: true,
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
                                          child: Column(
                                            children: convo.entries
                                                .map((e) => Column(
                                                      children: [
                                                        SelectableText(
                                                          '\n${e.key}: \n\n',
                                                          style: TextStyle(
                                                            color: Colors
                                                                    .deepOrange[
                                                                800],
                                                            fontFamily:
                                                                'RobotoCondensed',
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        SelectableText(
                                                            '${e.value} \n'),
                                                      ],
                                                    ))
                                                .toList(),
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
                                            (selectedBookname.isNotEmpty ||
                                                selectedBookBatch.isNotEmpty)) {
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
