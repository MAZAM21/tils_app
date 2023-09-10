import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/widgets/button-styles.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/MCQ-generation.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/openAI_integration/mark-answers.dart';
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
          ]),
        ],
      ),
    );
  }
}
