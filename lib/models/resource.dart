

import 'package:cloud_firestore/cloud_firestore.dart';
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

  String topic;
  String subject;
  String uploadTeacher;
  List<PlatformFile> resourceFiles;
  Map<String,String> urlMap;

  ResourceUploadObj({
    @required this.date,
    @required this.topic,
    @required this.subject,
    @required this.resourceFiles,
    @required this.urlMap,
    this.uploadTeacher,
  });
}
class ResourceDownload {
  final DateTime date;
  final String topic;
  final String subject;
  final Map urlMap;
  ResourceDownload({
    @required this.date,
    @required this.topic,
    @required this.subject,
    @required this.urlMap,
  });
  factory ResourceDownload.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
    
      final data = doc.data();
      Timestamp time = data['date'];
      DateTime date = DateTime.parse(time.toDate().toString());
    
      String topic = data['topic'];
      String subject = data['subject'];
      Map urlMap = Map<dynamic, dynamic>.from(data['downloadUrls']);
      return ResourceDownload(
        date: date,
        subject: subject,
        topic: topic,
        urlMap: urlMap,
      );
    } catch (err) {
      print('error in ResourceDownload: $err');
    }
    return null;
  }
}