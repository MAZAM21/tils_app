import 'dart:async';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

const key = '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';

class AIPower {
  final llm = OpenAI(
    apiKey: key,
    temperature: 0.9,
  );

  final chatLlm = ChatOpenAI(
    apiKey: key,
    temperature: 0,
  );
  final filePath = 'lib/assets/data.txt';

  Future<List<MCQ>?> textGenTesting() async {
    final url = 'http://127.0.0.1:5000/auto_quiz';

    var _bytes = await XFile(filePath).readAsBytes();
    String base64File = base64Encode(_bytes);

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Adjust the content type based on your server
    };

    Map<String, dynamic> body = {
      'file': base64File,
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('File uploaded successfully');
      final data = jsonDecode(response.body);
      final mcq_json = (data['response']);
      Map<String, dynamic> jsonData = jsonDecode(mcq_json);

      List<MCQ> mcqList =
          jsonData.values.map((json) => MCQ.fromJson(json)).toList();
      return mcqList;
    } else {
      print('Error uploading file: ${response.reasonPhrase}');
    }
    throw Exception;
  }

  Future<String?> serverTest(String? sourceMaterial) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/test_chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'source_material': sourceMaterial}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ans = (data['response']);
      print(ans);
      return data['response'].toString();
    } else {
      throw Exception('Failed to generate questions');
    }
  }

  void testSplittint() async {
    print('start');
    final txt = await TextLoader(filePath).load();
    print('loading docs');
    // print(txt);

    // int len (String text){

    // }
    final splitDocs = CharacterTextSplitter(
      separator: ' ',
      chunkSize: 100,
      chunkOverlap: 20,
    );

    final splits = splitDocs.splitDocuments(txt);

    print('///////////before as map *******');
    print(splits[6]);

    final textsWithSources = splits
        .asMap()
        .map(
          (i, d) => MapEntry(
            i,
            d.copyWith(
              metadata: {
                ...d.metadata,
                'source': '$i-pl',
              },
            ),
          ),
        )
        .values
        .toList(growable: false);
    final embeddings = OpenAIEmbeddings(
      apiKey: key,
      model: 'text-embedding-ada-002',
    );
    print('added sources');
    print(textsWithSources[0].toString());
  }

  Future<String?> generateQuestions() async {
    try {
      print('start');
      final txt = await TextLoader(filePath).load();
      print('loading docs');
      // print(txt);

      // int len (String text){

      // }
      final splitDocs = CharacterTextSplitter(
        chunkSize: 100,
        chunkOverlap: 20,
        separator: ' ',
      );

      final splits = splitDocs.splitDocuments([txt[0]]);

      print(splits[0]);

      final textsWithSources = splits
          .asMap()
          .map(
            (i, d) => MapEntry(
              i,
              d.copyWith(
                metadata: {
                  ...d.metadata,
                  'input': '$i-pl',
                },
              ),
            ),
          )
          .values
          .toList(growable: false);
      final embeddings = OpenAIEmbeddings(
        apiKey: key,
        model: 'text-embedding-ada-002',
      );
      print('added sources');
      // print(textsWithSources[0].toString());

      final docSearch = await MemoryVectorStore.fromDocuments(
        documents: textsWithSources,
        embeddings: embeddings,
      );

      final qaChain = OpenAIQAWithSourcesChain(
        llm: chatLlm,
      );

      final docPrompt = PromptTemplate.fromTemplate(
        'you are a tester. generate questions for the {input} provided',
      );

      final finalQAChain = StuffDocumentsChain(
        llmChain: qaChain,
        documentPrompt: docPrompt,
      );

      final retrieval = RetrievalQAChain(
          retriever: docSearch.asRetriever(),
          combineDocumentsChain: finalQAChain);
      final query = 'secret trusts';
      print(query);

      print(retrieval(query));

      final res = await retrieval(query);
      print(res['result'].answer);
      print(res);
      return res['result'].answer;
    } on Exception catch (e) {
      print(e);
    }
    throw Exception;
  }

  // Future<String?> generateQuestionsSimp() async {
  //   final txt = await TextLoader(filePath).lazyLoad().toList();

  //   final docSearch = await MemoryVectorStore.fromDocuments(
  //     documents: txt,
  //     embeddings: embeddings,
  //   );

  //   final retrieval = RetrievalQAChain(
  //     retriever: docSearch.asRetriever(),
  //     combineDocumentsChain: StuffDocumentsChain(
  //       llmChain: OpenAIQAWithSourcesChain(
  //         llm: chatLlm,
  //       ),
  //       documentPrompt: PromptTemplate.fromTemplate(
  //         'Content: {page_content}\nSource: {source}',
  //       ),
  //     ),
  //   );

  //   final query = 'what is secret trust';
  //   print(query);
  //   final res = await retrieval(query);
  //   print(res['result'].answer);
  //   print(res);
  //   return res['result'].answer;
  // }

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
