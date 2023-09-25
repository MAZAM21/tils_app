import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/AI-tutor.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/MCQ-generation.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/mark-answers.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/upload-book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AIMenu extends StatelessWidget {
  final TeacherUser teacherData;
  const AIMenu(this.teacherData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RedButtonMain(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/call-chatgpt'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: CallChatGPT(),
                      ),
                    ),
                  );
                },
                child: 'MCQ-Generation',
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RedButtonMain(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/mark-answers'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: MarkAnswers(),
                      ),
                    ),
                  );
                },
                child: 'Answer Marking',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RedButtonMain(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/ai-tutor'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: AITutor(),
                      ),
                    ),
                  );
                },
                child: 'AI Tutor',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RedButtonMain(
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
                child: 'Upload Book',
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
