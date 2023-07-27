import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// the purpose of this class is to cross refrence with subject and class and
/// categorize the resource as video audio or note

enum ResourceType {
  Audio,
  Video,
  Document,
}

class ResourceUploadObj with ChangeNotifier {
  DateTime date;

  String? topic;
  String subject;
  String? uploadTeacher;
  List<PlatformFile> resourceFiles;

  ResourceUploadObj({
    required this.date,
    required this.topic,
    required this.subject,
    required this.resourceFiles,
    this.uploadTeacher,
  });
}
