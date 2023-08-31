import 'dart:async';
import 'dart:typed_data';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

import 'dart:convert';

const key = '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';

class AIPower {
  Map<String, dynamic> offerAcceptanceMCQs = {
    "1": {
      "no": "1",
      "mcq":
          "According to the context, when does a legally binding agreement arise from an offer?",
      "options": {
        "1": "When the offer is made",
        "2": "When the offer is accepted",
        "3": "When the offer is communicated",
        "correct":
            "When acceptance is communicated to the offeror in the manner contemplated by the offer"
      }
    },
    "2": {
      "no": "2",
      "mcq":
          "Can an offer be revoked without the consent of the other party after acceptance?",
      "options": {
        "1": "Yes",
        "2": "It depends on the circumstances",
        "correct": "No"
      }
    },
    "3": {
      "no": "3",
      "mcq":
          "What must be proven in order to establish that an offer has been accepted?",
      "options": {
        "1": "That the offeree knew about the offer",
        "2": "That the offeror knew about the acceptance",
        "3": "That the offeror communicated the acceptance",
        "correct":
            "That acceptance is communicated to the offeror in the manner contemplated by the offer"
      }
    }
  };
  Map<String, dynamic> generated_mcq = {
    "1": {
      "no": "1",
      "mcq": "What is a secret trust?",
      "options": {
        "1": "A trust created during the testator's lifetime",
        "2": "A trust created under a will",
        "3": "A trust where the beneficiaries are named in the will",
        "correct": "A trust where the beneficiaries are not named in the will"
      }
    },
    "2": {
      "no": "2",
      "mcq": "Who holds the property in a secret trust?",
      "options": {
        "1": "The testator",
        "2": "The legatee",
        "3": "The beneficiaries",
        "correct": "The legatee"
      }
    },
    "3": {
      "no": "3",
      "mcq": "What is the purpose of a secret trust?",
      "options": {
        "1": "To avoid probate fees",
        "2":
            "To ensure the property is distributed according to the testator's wishes",
        "3": "To keep the existence of the trust a secret",
        "correct":
            "To ensure the property is distributed according to the testator's wishes"
      }
    }
  };
  final llm = OpenAI(
    apiKey: key,
    temperature: 0.9,
  );

  final chatLlm = ChatOpenAI(
    apiKey: key,
    temperature: 0,
  );
  final filePath = 'lib/assets/contract_law.txt';

  void textGenCloudFunction() async {
    var _bytes = await XFile(filePath).readAsBytes();
    // Map<String, String> headers = {
    //   'Content-Type':
    //       'application/json', // Adjust the content type based on your server
    // };
    String base64File = base64Encode(_bytes);
    // Map<String, dynamic> body = {
    //   'file': base64File,
    // };
    final data = await FirebaseFunctions.instance
        .httpsCallable('mcq_generation')
        .call({'file': base64File});
    print(data);
  }

  Future<List<MCQ>?> textGenSample() async {
    List<MCQ> mcqList =
        offerAcceptanceMCQs.values.map((json) => MCQ.fromJson(json)).toList();

    return mcqList;
  }

  void uploadAnswers(
      List<Uint8List> _fileBytesList, List<String> _fileNames) async {
    if (_fileBytesList.isEmpty) {
      print('No files selected to upload');
      return;
    }

    try {
      var url = Uri.parse('http://127.0.0.1:5000/file_upload');
      var request = http.MultipartRequest('POST', url);

      for (var i = 0; i < _fileBytesList.length; i++) {
        Uint8List fileBytes = _fileBytesList[i];
        String fileName = _fileNames[i];

        Stream<List<int>> stream =
            Stream.fromIterable(fileBytes.map((byte) => [byte]));

        request.files.add(http.MultipartFile(
          'files', // Adjust the field name to match your server's expectations
          stream,
          fileBytes.length,
          filename: fileName,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Files uploaded successfully');
      } else {
        print('Error uploading files: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading files: $e');
    }
  }

  Future<List<MCQ>?> mcq_generation(String topic) async {
    final url = 'http://127.0.0.1:5000/auto_quiz';

    var _bytes = await XFile(filePath).readAsBytes();
    String base64File = base64Encode(_bytes);

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Adjust the content type based on your server
    };

    Map<String, dynamic> body = {
      'file': base64File,
      'topic': topic,
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
      print(jsonData);
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
    // final embeddings = OpenAIEmbeddings(
    //   apiKey: key,
    //   model: 'text-embedding-ada-002',
    // );
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
