import 'dart:async';

import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

const key = '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';

class AIPower {
  final llm = OpenAI(
    apiKey: key,
    temperature: 0.9,
  );
  final filePath = 'C:\Users\mazam\Fluency\tils_app\lib\assets\data.txt';
  final textLoader =
      TextLoader('C:\Users\mazam\Fluency\tils_app\lib\assets\data.txt');

  void loadDocs() async {
    final docs = await textLoader.lazyLoad().toList();
  }

  final chat = ChatOpenAI(apiKey: key, temperature: 0);

  Future<String?> getResponse(String? usrMsg) async {
    String mes = '';
    if (usrMsg != null) {
      mes = usrMsg;
    }
    final sendMsg = ChatMessage.human(mes);
    final aiMsg = await chat.generate([sendMsg]);
    print('${aiMsg.generations.first.output.content}');
    return aiMsg.generations.first.output.content;
  }
}
