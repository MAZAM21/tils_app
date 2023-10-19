import 'package:SIL_app/widgets/button-styles.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/service/openAi-service.dart';

class UploadTextbook extends StatefulWidget {
  const UploadTextbook({Key? key}) : super(key: key);
  static const routeName = '/upload-textbook';

  @override
  State<UploadTextbook> createState() => _CallChatGPTState();
}

class _CallChatGPTState extends State<UploadTextbook> {
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  final authorController = TextEditingController();
  final categoryController = TextEditingController(); // Added author controller
  String bookName = '';
  String selectedSubject = '';
  String category = ''; // Added selectedSubject variable

  bool isBatch = false;
  String selectedBookname = "";
  Set<String> selectedBookBatch = {};

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
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Batch Upload',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Switch(
                        value: isBatch,
                        onChanged: (value) {
                          setState(() {
                            isBatch = value;
                            // if (isBatch == false) {
                            //   selectedBookBatch.clear();
                            // } else {
                            //   selectedBookname = '';
                            // }
                          });
                        }),
                    if (!isBatch)
                      TextFormField(
                        key: ValueKey('topic'),
                        validator: (value) {
                          if (value!.isEmpty || value == '') {
                            return 'Please enter a book name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          bookName = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                        ),
                        maxLines: 3,
                        minLines: 2,
                      ),
                    if (!isBatch)
                      SizedBox(
                        height: 30,
                      ),
                    if (!isBatch)
                      TextFormField(
                        key: ValueKey('author'),
                        controller: authorController,
                        decoration: InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                        ),
                      ),
                    if (!isBatch)
                      SizedBox(
                        height: 30,
                      ),
                    TextFormField(
                      key: ValueKey('Category'),
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 20,
                    ),
                    WhiteButtonMain(
                      child: 'Upload',
                      onPressed: () {
                        setState(() {
                          isTesting = true;
                        });
                      },
                    ),
                    if (isTesting == true)
                      if (!isBatch)
                        Container(
                          child: FutureBuilder<String?>(
                            future: aiService.upload_textbook(
                                bookName,
                                authorController.text,
                                selectedSubject,
                                categoryController.text),
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
                    if (isTesting == true)
                      if (isBatch)
                        Container(
                          child: FutureBuilder<String?>(
                            future: aiService
                                .batch_upload_textbook(categoryController.text),
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
            ],
          ),
        ),
      ),
    );
  }
}
