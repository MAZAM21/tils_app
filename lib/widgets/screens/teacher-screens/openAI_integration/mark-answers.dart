import 'dart:typed_data';

import 'package:SIL_app/service/openAi-service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MarkAnswersAI extends StatefulWidget {
  const MarkAnswersAI({Key? key}) : super(key: key);

  @override
  State<MarkAnswersAI> createState() => _MarkAnswersAIState();
}

class _MarkAnswersAIState extends State<MarkAnswersAI> {
  List<Uint8List> _fileBytesList = [];
  List<String> _fileNames = [];
  final ai = AIPower();

  void _pickAndUploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf'],
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null && result.files.isNotEmpty) {
      List<PlatformFile> selectedFiles = result.files;

      // Clear previous files before adding new ones
      setState(() {
        _fileBytesList.clear();
        _fileNames.clear();
      });

      for (var file in selectedFiles) {
        if (file.extension == 'txt' || file.extension == 'pdf') {
          Uint8List fileBytes = file.bytes!;
          setState(() {
            _fileBytesList.add(fileBytes);
            _fileNames.add(file.name!);
          });
        }
      }

      ai.uploadAnswers(_fileBytesList, _fileNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickAndUploadFiles,
              child: Text('Pick and Upload Files'),
            ),
          ],
        ),
      ),
    );
  }
}
