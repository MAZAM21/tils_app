import 'dart:async';

import 'package:SIL_app/widgets/button-styles.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/service/openAi-service.dart';

class CallChatGPT extends StatefulWidget {
  const CallChatGPT({Key? key}) : super(key: key);
  static const routeName = '/call-chatgpt';

  @override
  State<CallChatGPT> createState() => _CallChatGPTState();
}

class _CallChatGPTState extends State<CallChatGPT> {
  final _formKey = GlobalKey<FormState>();
  final queController = TextEditingController();
  String? que;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Ask ChatGPT'),
            TextFormField(
              key: ValueKey('question'),
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Please enter a question statement';
                }
                return null;
              },
              onSaved: (value) {
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
            RedButtonMain(
                child: 'Submit',
                onPressed: () {
                  setState(() {
                    saveForm();
                  });
                }),
            SizedBox(height: 20),
            SizedBox(
              height: 20,
            ),
            if (que != null)
              Container(
                child: FutureBuilder<String?>(
                    future: aiService.getResponse(que),
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
                        print('done');
                        return Column(
                          children: [
                            Text('${snap.data}'),
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
      ),
    );
  }
}
