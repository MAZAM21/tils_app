import 'dart:io';

import 'package:flutter/foundation.dart';

/// the purpose of this class is to cross refrence with subject and class and
/// categorize the resource as video audio or note

enum ResourceType {
  Audio,
  Video,
  Document,
}

class ResourceUpload with ChangeNotifier {
  String date;
  String classId;
  String storageLink;
  String topic;
  String subject;
  String uploadTeacher;
  File resource;

  ResourceUpload(
    this.date,
    this.classId,
    this.storageLink,
    this.topic,
    this.subject,
    this.uploadTeacher,
  );
}
