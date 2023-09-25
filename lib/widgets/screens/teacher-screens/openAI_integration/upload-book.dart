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
  final authorController = TextEditingController(); // Added author controller
  String que = '';
  String selectedSubject = ''; // Added selectedSubject variable

  final aiService = AIPower();

  void saveForm() {
    setState(() {
      _formKey.currentState!.validate();
      _formKey.currentState!.save();
    });
  }

  Map<String, Map<String, List<String>>> years = {
    "1st": {
      "A": ["bio", "phys", "chem", "urdu", "eng"],
      "B": ["math", "phys", "comp sci"],
      "C": ["chem", "math"],
    },
    "2nd": {
      "A": ["bio", "phys", "chem", "urdu", "eng"],
      "B": ["math", "phys", "comp sci"],
      "C": ["chem", "math"],
      "D": ["urdu", "pk studies"]
    }
  };
  String selectedYear = "1st";
  String selectedSection = "A";

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
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    maxLines: 3,
                    minLines: 2,
                  ),
                ),
                Container(
                  // Added Author input field
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    key: ValueKey('author'),
                    controller: authorController,
                    decoration: InputDecoration(
                      labelText: 'Author',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
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
                  Container(
                    child: FutureBuilder<String?>(
                      future: aiService.upload_textbook(
                          que, authorController.text, selectedSubject),
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
}
