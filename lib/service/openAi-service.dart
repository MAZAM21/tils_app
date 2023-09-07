import 'dart:async';
import 'dart:typed_data';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/service/student-db.dart';

import 'dart:convert';
import 'package:file_picker/file_picker.dart';

const key = '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';

class AIPower {
  Map<String, dynamic> offerAcceptanceMCQs = {
    "1": {
      "no": "1",
      "mcq": "What was the focus of the author's discussion?",
      "options": {
        "1": "The certainty of the agreement itself",
        "2": "The duration of the agreement",
        "3": "The enforceability of the agreement",
        "correct": "The certainty of the agreement itself"
      }
    },
    "2": {
      "no": "2",
      "mcq": "According to the context, what did the author conclude?",
      "options": {
        "1": "The agreement was uncertain",
        "2": "The agreement was enforceable",
        "3": "The agreement was indefinite",
        "correct": "The agreement was certain"
      }
    },
    "3": {
      "no": "3",
      "mcq":
          "What aspect of the agreement did the author specifically mention?",
      "options": {
        "1": "The payment terms",
        "2": "The negotiation process",
        "correct": "The duration"
      },
      "4": "The legal consequences"
    },
    "4": {
      "no": "4",
      "mcq": "What was the author's opinion on the certainty of the agreement?",
      "options": {
        "1": "It was irrelevant",
        "2": "It was crucial",
        "3": "It was unclear",
        "correct": "It was important"
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

  Future<String?> upload_textbook(String bookname) async {
    var ref = FirebaseStorage.instance.ref().child('');
    List<Uint8List> _fileBytesList = [];
    List<String> _fileNames = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      List<PlatformFile> selectedFiles = result.files;

      _fileBytesList.clear();
      _fileNames.clear();

      for (var file in selectedFiles) {
        if (file.extension == 'txt' || file.extension == 'pdf') {
          Uint8List fileBytes = file.bytes!;
          _fileBytesList.add(fileBytes);
          _fileNames.add(file.name);
        }
      }

      if (_fileBytesList.isEmpty) {
        print('No files selected to upload');
        return null;
      }

      try {
        var url = Uri.parse('http://127.0.0.1:5000/upload_textbooks');
        var request = http.MultipartRequest('POST', url);
        request.fields['bookname'] = bookname;

        for (var i = 0; i < _fileBytesList.length; i++) {
          Uint8List fileBytes = _fileBytesList[i];
          String fileName = _fileNames[i];

          Stream<List<int>> stream =
              Stream.fromIterable(fileBytes.map((byte) => [byte]));

          request.files.add(http.MultipartFile(
            'files',
            stream,
            fileBytes.length,
            filename: fileName,
          ));
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          print('File uploaded successfully');
          print(response);
          final respStr = await response.stream.bytesToString();
          String jsonList = jsonDecode(respStr);
          String url;
          List<String> json_List = json.decode(jsonList).cast<String>();
          for (String path in json_List) {
            print(path);
            ref = FirebaseStorage.instance.ref();
            String url = await ref
                .child("gs://tils-portal.appspot.com/" + path)
                .getDownloadURL();
            print(url);
          }
          print(json_List);
          return "hello";
        } else {
          print('Error uploading files: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error uploading files: $e');
      }
    }
  }

  Future<List<Marks>?> pickAndUploadFiles(String criteria) async {
    List<Uint8List> _fileBytesList = [];
    List<String> _fileNames = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      List<PlatformFile> selectedFiles = result.files;

      _fileBytesList.clear();
      _fileNames.clear();

      for (var file in selectedFiles) {
        if (file.extension == 'txt' || file.extension == 'pdf') {
          Uint8List fileBytes = file.bytes!;
          _fileBytesList.add(fileBytes);
          _fileNames.add(file.name);
        }
      }

      if (_fileBytesList.isEmpty) {
        print('No files selected to upload');
        return null;
      }

      try {
        var url = Uri.parse('http://127.0.0.1:5000/file_upload');
        var request = http.MultipartRequest('POST', url);
        request.fields['criteria'] = criteria;

        for (var i = 0; i < _fileBytesList.length; i++) {
          Uint8List fileBytes = _fileBytesList[i];
          String fileName = _fileNames[i];

          Stream<List<int>> stream =
              Stream.fromIterable(fileBytes.map((byte) => [byte]));

          request.files.add(http.MultipartFile(
            'files',
            stream,
            fileBytes.length,
            filename: fileName,
          ));
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          print('File uploaded successfully');
          print(response);
          final respStr = await response.stream.bytesToString();
          List<dynamic> jsonList = jsonDecode(respStr);

          // Convert each element in the jsonList to Marks objects
          List<Marks> marksList =
              jsonList.map((json) => Marks.fromJson(json)).toList();

          return marksList;
        } else {
          print('Error uploading files: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error uploading files: $e');
      }
    }
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
