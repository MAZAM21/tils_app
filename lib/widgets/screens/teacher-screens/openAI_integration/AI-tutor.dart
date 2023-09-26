import 'package:SIL_app/models/books.dart';
import 'package:SIL_app/models/teacher-user-data.dart';

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

  void handleBookTileTap(Books book) {
    setState(() {
      isTesting = false;
      selectedBookname = book.name;
    });
  }

  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser?>(context);
    //final db = Provider.of<DatabaseService>(context);
    final books = Provider.of<List<Books>>(context);
    Map<String?, List<Books>> categorizedBooks = {};
    List<Books> booksWithoutCategory = [];

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
                Drawer(
                  backgroundColor: Color.fromARGB(255, 230, 235, 235),
                  child: ListView(children: [
                    if (booksWithoutCategory.isNotEmpty)
                      ExpansionTile(
                        textColor: Color(0xff161616),
                        title: Text('Books without Category'),
                        children: booksWithoutCategory
                            .map(
                              (book) => ListTile(
                                title: Text(book.name),
                                onTap: () {
                                  handleBookTileTap(book);
                                },
                                selectedColor: Colors.red,
                                selected: selectedBookname == book.name,
                                subtitle: Text(
                                  'Author: ${book.author}',
                                  style: TextStyle(
                                      color: selectedBookname == book.name
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
                                title: Text(book.name),
                                subtitle: Text(
                                  'Author: ${book.author}',
                                  style: TextStyle(
                                      color: selectedBookname == book.name
                                          ? Colors.red
                                          : Color(0xff161616),
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                onTap: () {
                                  handleBookTileTap(book);
                                },
                                selected: selectedBookname == book.name,
                                selectedColor: Colors.red,
                              ),
                            )
                            .toList(),
                      ),
                  ]),
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
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator()),
                                ],
                              );
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
