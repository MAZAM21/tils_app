import 'dart:io';

import 'package:SIL_app/models/institute-id.dart';
import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/teachers-all.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:SIL_app/models/admin-user-data.dart';
import 'package:SIL_app/models/allTextQAs.dart';
import 'package:SIL_app/models/assignment-marks.dart';
import 'package:SIL_app/models/metrics.dart';
import 'package:SIL_app/models/parent-user-data.dart';
import 'package:SIL_app/models/resource.dart';
import 'package:SIL_app/models/student-answers.dart';
import 'package:SIL_app/models/student-textAnswers.dart';
import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/service/upload-service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/announcement.dart';
import '../models/attendance.dart';
import '../models/class-data.dart';
import '../models/remote_assessment.dart';
import '../models/role.dart';
import '../models/student-user-data.dart';
import '../models/student.dart';
import '../models/teacher-user-data.dart';
import '../models/meeting.dart';
import '../models/subject-class.dart';
import '../models/assessment-result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? instID;

  DatabaseService([this.instID]);

  //gets classes collection data and converts to Meeting list for TT
  Stream<List<Meeting>>? streamMeetings() {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('classes');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => Meeting.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in streamMeetings:err');
      return null;
    }
  }

  //gets classes collection data and converts to subjectclass for attendance
  Stream<List<SubjectClass>> streamClasses() {
    print('stream classes called, instID:$instID');
    try {
      CollectionReference ref =
          _db.collection('institutes').doc(instID).collection('classes');
      return ref.snapshots().map((list) => list.docs
          .map((doc) => SubjectClass.fromFirestore(doc))
          .where(
              (subject) => !subject.isInvalid()) // Filter out invalid objects
          .toList());
    } on Exception catch (e) {
      print('error in streamclasses: $e');
    }
    throw Exception();
  }

  //gets attendance collection and converts to attendance for attendance status
  Stream<List<Attendance>> streamAttendance() {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('attendance');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Attendance.fromFirestore(doc)).toList());
  }

  Stream<List<StudentRank>>? streamStudents() {
    try {
      CollectionReference ref =
          _db.collection('institutes').doc(instID).collection('students');
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentRank.fromFirestore(doc)).toList());
    } catch (e) {
      print('error in student list stream db: $e');
    }
    return null;
  }

  Stream<List<AllTeachers>>? streamTeachers() {
    try {
      CollectionReference ref =
          _db.collection('institutes').doc(instID).collection('teachers');
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => AllTeachers.fromFirestore(doc)).toList());
    } catch (e) {
      print('error in  streamTeachers db: $e');
    }
    return null;
  }

//stream resource
  Stream<List<ResourceDownload>> streamResource() {
    CollectionReference ref = _db.collection('resources');
    return ref.snapshots().map((list) => list.docs
        .map((doc) => ResourceDownload.fromFirestore(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>))
        .toList());
  }

  //gets data from student collection and checks uid and then makes data into studentuser
  Stream<StudentUser>? streamStudentUser(String uid) {
    try {
      CollectionReference ref =
          _db.collection('institutes').doc(instID).collection('students');
      return ref.snapshots().map((list) => StudentUser.fromFirestore(
          list.docs.firstWhere((doc) => doc['uid'] == uid)
              as QueryDocumentSnapshot<Map<String, dynamic>>));
    } catch (e) {
      print('bloody error: $e');
    }
    return null;
  }

  //gets data from student collection and checks uid and then makes data into teacheruser
  Stream<TeacherUser> streamTeacherUser(String? uid, String? instID) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('teachers');
    return ref.snapshots().map((list) => TeacherUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Stream<ParentUser> streamParentUser(String puid) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('students');
    return ref.snapshots().map((list) => ParentUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['parent-uid'] == puid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Stream<AdminUser> streamAdminUser(String uid) {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('admins');
    return ref.snapshots().map((list) => AdminUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)
            as QueryDocumentSnapshot<Map<String, dynamic>>));
  }

  Stream<List<Announcement>>? streamAnnouncement() {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('announcements');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => Announcement.fromFirestore(doc)).toList());
    } catch (err) {
      print('err in stream announcement: $err');
    }
    return null;
  }

  /// stream Assignment Marks
  Stream<List<AMfromDB>>? streamAM() {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('assignment-marks');
    try {
      return ref.snapshots().map((list) => list.docs
          .map((doc) => AMfromDB.fromFirestore(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList());
    } catch (err) {
      print('error in streamAM: $err');
    }
    return null;
  }

  Stream<List<RAfromDB>>? streamRA() {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment');
    try {
      return ref.snapshots().map((list) => list.docs
          .map((doc) => RAfromDB.fromFirestore(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList());
    } catch (err) {
      print('err in stream RA: $err');
    }
    return null;
  }

  ///stream all submitted text answers scripts for all assessments
  Stream<List<TextQAs>>? streamTextQAs() {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result');

    try {
      return ref.snapshots().map((list) => list.docs
          .map((doc) => TextQAs.fromFirestore(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList());
    } catch (err) {
      print('error in stream textqas: $err');
    }
    return null;
  }

  Stream<List<StudentAnswers>>? streamResFromID(String? assid) {
    try {
      CollectionReference ref = _db
          .collection('institutes')
          .doc(instID)
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      return ref.snapshots().map((list) => list.docs
          .map((doc) => StudentAnswers.fromFirestore(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList());
    } catch (err) {
      print('error in stream ans from id db: $err');
    }
    return null;
  }

  ///stream list of scripts for chosen assessment
  Stream<List<StudentTextAns>>? streamAnsFromID(String assid) {
    try {
      CollectionReference ref = _db
          .collection('institutes')
          .doc(instID)
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      return ref.snapshots().map((list) => list.docs
          .map((doc) => StudentTextAns.fromFirestore(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList());
    } catch (err) {
      print('error in stream ans from id db: $err');
    }
    return null;
  }

  ///get metrics stream as a collection
  Stream<List<StudentMetrics>>? streamMetrics() {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('metrics');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentMetrics.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in metrics strea: $err');
    }
    return null;
  }

  ///gets auth state stream
  Stream<User?> authStateStream() {
    return auth.authStateChanges();
  }

  Future<InstituteID?> getInstituteID(String uid) async {
    CollectionReference ref = _db.collection('users');
    try {
      final userDoc = await ref.doc(uid).get();

      return InstituteID.fromFirebase(userDoc);
    } catch (e) {
      print('error in getInstituteID: $e');
    }
    throw Exception;
  }

  ///gets students collection data as per the registeration status of student
  Future<List<Student>?> getStudentsBySub(String? subName) async {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('students');
    try {
      QuerySnapshot<Map<String, dynamic>> query = await (ref
          .where('registeredSubs.$subName', isEqualTo: true)
          .get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      return query.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('error in getstudbysub $err');
    }
    return null;
  }

  Future<InstituteData?> getInstituteData() async {
    if (instID != null) {
      DocumentReference ref = _db.collection('institutes').doc(instID);
      try {
        final instDataDoc = await ref.get();
        return InstituteData.fromFirestore(instDataDoc);
      } catch (e) {
        print('error in getInstituteData: ${e}');
      }
      throw Exception();
    } else {
      throw Exception('in getinstitutedata genDB');
    }
  }

  Future<InstituteData?> getInstituteDataforAllTabs() async {
    if (instID != null) {
      DocumentReference ref = _db.collection('institutes').doc(instID);
      try {
        print('in getinsititutedataforalltabs: ${ref.id}');
        final instDataDoc = await ref.get();
        return InstituteData.fromFirestore(instDataDoc);
      } catch (e) {
        print('error in getInstituteData: ${e}');
      }
      throw Exception('try catch error in streaminstdataforalltabs');
    } else {
      throw Exception('in getinstitutedata alltabs error');
    }
  }

  ///get all student docs from student collection
  Future<List<Student>?> getAllStudents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> ref = await _db
          .collection('institutes')
          .doc(instID)
          .collection('students')
          .get();
      return ref.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('err in getallstudents $err');
    }
    return null;
  }

  Future<List<String>?> getAllAssessmentIds() async {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment');
    List<String> allIds = [];
    try {
      QuerySnapshot<Map<String, dynamic>> allDocs =
          await (ref.get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      allDocs.docs.forEach((doc) {
        allIds.add(doc.id);
      });
      return allIds;
    } catch (err) {
      print('err in getallassessments: $err');
    }
    return null;
  }

  Future<String> downloadFileWeb(String downloadUrl, String fileName) async {
    final httpsReference = FirebaseStorage.instance.refFromURL(downloadUrl);
    final webUrl = await httpsReference.getDownloadURL();
    return webUrl;
  }

  Future<void> downloadFile(String url, String fileName) async {
    final Reference storage = FirebaseStorage.instance.ref();

    final httpsReference = FirebaseStorage.instance.refFromURL(url);

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.path}/${httpsReference.name}";
    print(appDocDir.path);
    final file = File(filePath);

    final downloadTask = httpsReference.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          print('download running');
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          print('download complete');
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          print('download err');
          break;
      }
    });
  }

  Future<List<String?>?> getAllARTitles(String subject) async {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result');
    List<String?> titles = [];
    try {
      QuerySnapshot<Map<String, dynamic>> qtitles = await (ref
          .where('subject', isEqualTo: '$subject')
          .get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      //all titles and doc ids of the assessments of that subject
      qtitles.docs.forEach((doc) {
        titles.add(doc['title']);
      });
      //print(titles);
      return titles;
    } catch (e) {
      print('error in getAllartitles: $e');
    }
    return null;
  }

  Future<List<ARStudent>?> getARData(
    String subject,
  ) async {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result');
    CollectionReference assref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment');
    CollectionReference stu =
        _db.collection('institutes').doc(instID).collection('students');

    ///map containing {ids, titles}
    Map<String, String?> idTitles = {};

    //map of number of questions and assid
    Map<String, int> idL = {};

    try {
      //all assessments results of subject
      QuerySnapshot<Map<String, dynamic>> qtitles = await (ref
          .where('subject', isEqualTo: '$subject')
          .get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      //all titles and doc ids of the assessments of that subject
      qtitles.docs.forEach((doc) {
        idTitles.addAll({doc.id: doc['title']});
      });
      // print(idTitles);
      //query for all assessment docs
      QuerySnapshot ql = await assref.get();

      //checks all docs in ra against those fetched from ar, adds id and length if present
      ql.docs.forEach((doc) {
        if (idTitles.containsKey(doc.id)) {
          idL.addAll({doc.id: doc['TextQs'].length ?? 0});
        }
      });
      // print(idL);

      //checks student collection for all registered students fro this sub
      QuerySnapshot<Map<String, dynamic>> qs = await (stu
          .where('registeredSubs.$subject', isEqualTo: true)
          .get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      return qs.docs.map((doc) {
        // print(doc['name']);
        return ARStudent.fromFirebase(doc, idTitles, idL);
      }).toList();
    } catch (e) {
      print('err in getARDATA db: $e');
    }
    return null;
  }

  Future<Map<String?, int>?> getAllStudentMarks(String assid) async {
    try {
      CollectionReference ref = _db
          .collection('institutes')
          .doc(instID)
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      Map<String?, int> allStMarks = {};
      QuerySnapshot<Map<String, dynamic>> q =
          await (ref.get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      q.docs.forEach((doc) {
        final Map tqmarks = {...doc['TQMarks']};
        final name = doc['name'];
        int l = tqmarks.length;
        //print(l);
        if (l != 0) {
          int allTotal = tqmarks.values.fold(0, (p, e) => p + e as int);
          double aggregate = ((allTotal / (l * 100)) * 100);
          //print(aggregate);
          allStMarks.addAll({name: aggregate.toInt()});
        }
      });
      return allStMarks;
    } catch (e) {
      print('error in getAllStudentMarks db: $e');
    }
    return null;
  }

  Stream<double> uploadResource(ResourceUploadObj resourceUploadObj) async* {
    print(
        'resourceuploadobj: ${resourceUploadObj.date} ,  ${resourceUploadObj.resourceFiles.length}, ${resourceUploadObj.topic}');

    // Get a reference to the Firebase Storage bucket
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref();
    print('resourceFiles length: ${resourceUploadObj.resourceFiles.length}');
    print('storageRef: $storageRef');
    // Upload each file in the resourceFiles list to Firebase Storage
    final List<Future<Map<String, String>>> downloadUrlFutures = [];
    final List<UploadTask> uploadTasks = [];
    for (final file in resourceUploadObj.resourceFiles) {
      // Get a reference to the file in Firebase Storage
      final Reference fileRef = storageRef.child(
          'resources/${resourceUploadObj.subject}/${resourceUploadObj.date}/${file.name}');

      print('refrecence added storage');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = fileRef.putData(file.bytes!);
      uploadTasks.add(uploadTask);

      print('Upload the file to Firebase Storage');

      // Get a future for the download URL for the uploaded file
      final Future<TaskSnapshot> uploadTaskSnapshot =
          uploadTask.whenComplete(() {});
      final Future<String> downloadUrlFuture =
          uploadTaskSnapshot.then((snapshot) => snapshot.ref.getDownloadURL());
      downloadUrlFutures.add(downloadUrlFuture.then((downloadUrl) {
        return {file.name: downloadUrl};
      }));
      // final Future<String> downloadUrlFuture = fileRef.getDownloadURL();
      // downloadUrlFutures.add(downloadUrlFuture.then((downloadUrl) {
      //   return {file.name: downloadUrl};
      // }));
      print('fileRef: $fileRef');
      print('uploadTask: $uploadTask');
      print('uploadTaskSnapshot: $uploadTaskSnapshot');
      print('downloadUrlFuture: $downloadUrlFuture');
      print('downloadUrlFutures length: ${downloadUrlFutures.length}');

      print('Get a future for the download URL for the uploaded file');
    }
    final List<Map<String, String>> downloadUrls =
        await Future.wait(downloadUrlFutures);

    // Create a document in Cloud Firestore with the relevant information

    final DocumentReference docRef =
        _db.collection('institutes').doc(instID).collection('resources').doc();
    print('doc created');
    docRef.set({
      'date': resourceUploadObj.date,
      'topic': resourceUploadObj.topic,
      'subject': resourceUploadObj.subject,
      'uploadTeacher': resourceUploadObj.uploadTeacher,
      'downloadUrls': Map<String?, String?>.fromIterable(
        downloadUrls.expand((map) => map.entries),
        key: (entry) => entry.key,
        value: (entry) => entry.value,
      ),
    });

    // Return a stream that emits the upload progress as a percentage
    double totalBytes = 0;
    double bytesUploaded = 0;
    for (final uploadTask in uploadTasks) {
      totalBytes += uploadTask.snapshot.totalBytes;
      print('total bytes: $totalBytes');
    }

    for (final uploadTask in uploadTasks) {
      await for (final event in uploadTask.snapshotEvents) {
        bytesUploaded += event.bytesTransferred;
        print('bytesUploaded: $bytesUploaded');

        final double progress = bytesUploaded / totalBytes;
        print('progress = ${bytesUploaded / totalBytes * 100}');
        yield progress;
      }
    }
  }

  Future<void> addPersistentClassToCF(
      {required String classSubject,
      required Map<DateTime, DateTime> times,
      required String? section,
      required String? year,
      String? topic,
      bool? exam,
      bool? isPersistent}) async {
    if (instID != null) {
      final _classCollection =
          _db.collection('institutes').doc(instID).collection('classes');

      times.forEach((start, end) async {
        String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
        String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);
        String notification = DateFormat("EEE, dd-MM hh:mm a").format(start);

        try {
          await _classCollection.add({
            'subjectName': '$classSubject',
            'startTime': startString,
            'endTime': endString,
            'topic': topic ?? 'none',
            'section': section,
            'notification': notification,
          });
        } catch (e) {}
      });
    }
  }

  Future<String> addTextbook(
      String bookname, String author, String subject, List url_list) async {
    print(instID);
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      DocumentReference<Map> res = await _db
          .collection('institutes')
          .doc("RIBR3Pwr3We2D5IQPF5O")
          .collection('textbook_vectors')
          .add({
        'bookname': bookname,
        'author': author,
        'subject': subject,
        'urls': url_list,
      });
      print(res);
      return "success";
    } catch (e) {
      return "error: $e";
    }
  }

  Future<void> storeMessage(String message, String chat_id, String book) async {
    String customDocName = chat_id;

    // Data you want to add to the document
    Map<String, dynamic> chatData = {
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot docSnapshot = await _db
          .collection('users')
          .doc('CKBtLUDwGSSNjHqsLaZrQtLbzNP2')
          .collection('chats')
          .doc(customDocName)
          .get();

      if (!docSnapshot.exists) {
        // Document already exists; add more data to it
        await _db
            .collection('users')
            .doc('CKBtLUDwGSSNjHqsLaZrQtLbzNP2')
            .collection('chats')
            .doc(customDocName)
            .set({"created": FieldValue.serverTimestamp(), "bookname": book});

        print(
            'Additional chat data added to existing document: $customDocName');
      }
      await _db
          .collection('users')
          .doc('CKBtLUDwGSSNjHqsLaZrQtLbzNP2')
          .collection('chats')
          .doc(customDocName)
          .collection("messages")
          .add(chatData);
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }
  }

  Future<List<String>?> getChatNames() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      // Specify the user's collection and create a query to get the "chats" documents
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc('CKBtLUDwGSSNjHqsLaZrQtLbzNP2')
          .collection('chats')
          .get();

      // Extract the custom document names (document IDs) from the query results
      List<String> customDocNames = [];
      querySnapshot.docs.forEach((doc) {
        customDocNames.add(doc.id);
      });

      print('Custom document names in "chats" collection: $customDocNames');
      return customDocNames;
    } catch (e) {
      print('Error querying Firestore: $e');
    }
  }

  Future<List<String>> getChatMessages(String chat_id) async {
    String userId = 'CKBtLUDwGSSNjHqsLaZrQtLbzNP2';

    try {
      // Create a reference to the "messages" collection within the custom document
      CollectionReference messagesCollection = _db
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chat_id)
          .collection('messages');

      // Query all documents in the "messages" collection
      QuerySnapshot querySnapshot = await messagesCollection.get();

      // Extract the "message" field from each document
      List<String> messages = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('message')) {
          messages.add(data['message']);
        }
      });

      print('Messages in document: $messages');
      return messages;
    } catch (e) {
      print('Error querying Firestore: $e');
      return [];
    }
  }

  Future<String> getChatBook(String chat_id) async {
    String userId = 'CKBtLUDwGSSNjHqsLaZrQtLbzNP2';

    String customDocName = chat_id;
    String chatDocumentPath = 'users/$userId/chats/$customDocName';

    try {
      // Use the document reference to get the chat document
      DocumentSnapshot chatDocument = await _db.doc(chatDocumentPath).get();

      // Check if the document exists
      if (chatDocument.exists) {
        // Access the "bookname" field from the document data
        String bookName = chatDocument.get('bookname');

        print('Book Name: $bookName');
        return bookName;
      } else {
        print('Chat document does not exist.');
        return "";
      }
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
      return "";
    }
  }

  Future<void> addClassToCF(
    String? name,
    DateTime start,
    DateTime end,
    String? section,
    String? year, [
    String? topic,
    bool? exam,
  ]) async {
    print('add class to cf: $name');
    if (instID != null) {
      final _classCollection =
          _db.collection('institutes').doc(instID).collection('classes');
      String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
      String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);
      String notification = DateFormat("EEE, dd-MM hh:mm a").format(start);

      try {
        if (exam!) {
          await _classCollection.add({
            'subjectName': 'Exam: $name',
            'startTime': startString,
            'endTime': endString,
            'topic': topic ?? 'none',
            'section': section,
            'notification': notification,
          });
        } else {
          await _classCollection.add({
            'subjectName': name,
            'startTime': startString,
            'endTime': endString,
            'topic': topic ?? 'none',
            'section': section,
            'notification': notification,
            'year': year,
          });
        }
      } catch (err) {
        print('error in adding to database: $err');
      }
    } else {
      print('instID not found in db');
    }
  }

  /// add resource to db
  Future<void> addResource(ResourceUploadObj resource) async {}

  ///new attendance addition
  Future<void> addAttendanceRecord(
    AttendanceInput attInput,
    List<StudentRank> students,
  ) async {
    ///In this new approach, attendance stutas will be stored as a map in classes document
    ///attendance collection has been killed
    ///attendance status is now part of SubjectClass

    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('classes');

    return await ref.doc(attInput.classID).set({
      'attStat': attInput.attendanceStatus,
      'timeUpdated': DateTime.now(),
    }, SetOptions(merge: true)).then(
      (value) => Future.forEach(
        students,
        (StudentRank stud) => addAttToStudent(
            stud,
            attInput.classID,
            attInput.attendanceStatus!['${stud.id}'],
            attInput.subject,
            attInput.date),
      ),
    );
  }

  Future<void> addAttToStudent(StudentRank student, String? clsId, int? stat,
      String? subName, String? notifdate) async {
    CollectionReference studentRef =
        _db.collection('institutes').doc(instID).collection('students');
    if (stat == 3) {
      studentAbsentNotification(student, subName, notifdate);
    }
    return await studentRef.doc(student.id).set(
      {
        'attendance': {'$clsId': stat}
      },
      SetOptions(merge: true),
    );
  }

  Future<void> studentAbsentNotification(
      StudentRank stud, String? clsName, String? date) async {
    FirebaseFunctions.instance.httpsCallable('studentAbsentNotif').call({
      'className': clsName,
      'studentName': stud.name,
      'parentToken': stud.parentToken,
      'date': date,
    });
  }

  //adds attendance status to database in attendance and individual student document
  Future<void> addAttToCF(String name, int status, String id) async {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('attendance');
    CollectionReference studentRef =
        _db.collection('institutes').doc(instID).collection('students');
    try {
      //gets doc of student
      QuerySnapshot<Map<String, dynamic>> q = await (studentRef
          .where('name', isEqualTo: '$name')
          .get() as Future<QuerySnapshot<Map<String, dynamic>>>);
      DocumentSnapshot stDoc = q.docs.firstWhere((doc) {
        return doc['name'] == '$name';
      });

      studentRef.doc(stDoc.id).set({
        'attendance': {'$id': status}
      }, SetOptions(merge: true));

      return ref.doc(id).set({'$name': status}, SetOptions(merge: true));
    } catch (err) {
      print('error in addAtttoCF $err');
    }
  }

  //adds class name and date to att page
  Future<void> addClassDetailToAttColl(
    String? className,
    String id,
    DateTime date,
  ) async {
    String dateString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(date);
    try {
      CollectionReference ref =
          _db.collection('institutes').doc(instID).collection('attendance');
      return await ref.doc(id).set(
          {'subName': className, 'classDate': dateString},
          SetOptions(merge: true));
    } catch (err) {
      print('err in addclassdetail $err');
    }
  }

  //gets user role as string
  Future<Role> getRole(String uid) async {
    print('getting role in db: $uid');
    CollectionReference ref = _db.collection('users');
    DocumentSnapshot query = await ref.doc(uid).get();
    Role role = Role.fromFirestore(query);
    return role;
  }

  ///Add token to teacher doc
  Future<void> addTokenToTeacher(String? token, String tID) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('teachers')
        .doc('$tID');
    try {
      return await ref.set({
        'token-FCM': token,
        'token-time-added': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('error in addTokenToTeacher: $e');
    }
  }

  Future<void> addTokenToStudent(String? token, String studID) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc('$studID');
    try {
      return await ref.set({
        'student-token': token,
        'token-time-added': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('error in addTokenToStudent: $e');
    }
  }

  Future<void> addParentTokenToStudent(String? token, String studID) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc('$studID');
    try {
      return await ref.set({
        'parent-token': token,
        'parent-token-time-added': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('error in addTokenToStudent: $e');
    }
  }

  Future<void> addAnnouncementToCF(
    String? title,
    String? body,
    String uid,
    DateTime now,
    String? category,
  ) async {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('announcements');
    try {
      await ref.add({
        'category': category,
        'addedBy': uid,
        'title': title,
        'body': body,
        'dateTime': now,
      });
    } catch (err) {
      print('error in add annoncement:$err');
    }
  }

  Future<void> addAssignmentToCF(
      [AssignmentMarks? am, AMfromDB? editAm]) async {
    ///New approach is being tested here
    try {
      /// if editAm is not passed then adding new assignment code executes
      if (editAm == null) {
        CollectionReference ref = _db
            .collection('institutes')
            .doc(instID)
            .collection('assignment-marks');
        return await ref.add(
          {
            'title': am!.title,
            'subject': am.subject,
            'student-marks': am.marks,
            'totalMarks': am.totalMarks,
            'uploader': am.teacherName,
            'uploader-id': am.teacherId,
            'time-created': DateTime.now(),
            'uid-marks': am.uidMarks,
          },

          ///after which each student doc is individually updated
        ).then(
          (value) => Future.forEach(
            am.uidMarks!.entries,
            (MapEntry element) => addAssignmentMarksToStudent(
              element.value,
              element.key,
              value.id,
              am.subject,
            ),
          ),
        );

        ///if editAm is there, then only student marks and uid marks are updated and indivual student
        ///docs as well
      } else {
        DocumentReference eref = _db
            .collection('institutes')
            .doc(instID)
            .collection('assignment-marks')
            .doc(editAm.docId);
        return await eref.set(
          {
            'student-marks': editAm.nameMarks,
            'uid-marks': editAm.uidMarks,
          },
          SetOptions(merge: true),
        ).then(
          (value) => Future.forEach(
            editAm.uidMarks!.entries,
            (MapEntry element) => addAssignmentMarksToStudent(
              element.value,
              element.key,
              editAm.docId,
              editAm.subject,
            ),
          ),
        );
      }
    } catch (err) {
      print('error in addAssignmentToCF: $err');
    }
  }

  Future<void> addAssignmentMarksToStudent(
      int m, String id, String? docId, String? subject) async {
    try {
      DocumentReference ref = _db
          .collection('institutes')
          .doc(instID)
          .collection('students')
          .doc(id);

      ref.set({
        '$subject-asgMarks': {'$docId': m},
        'assignment-marks': {'$docId': m}
      }, SetOptions(merge: true));
    } catch (err) {
      print('error in addAssignmentMarkstoStudent: $err');
    }
  }

  //adds remote assessment to cf. only for input
  Future<void> addAssessmentToCF(RemoteAssessment assessment) async {
    CollectionReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment');
    DateTime? start;
    DateTime? end;
    if (assessment.deployTime != null && assessment.deadline != null) {
      start = assessment.deployTime;
      end = assessment.deadline;
    } else {
      start = null;
      end = null;
    }
    try {
      await ref.add({
        'title': assessment.assessmentTitle,
        'subject': assessment.subject,
        'timeCreated': assessment.timeAdded,
        'MCQs': assessment.returnMcqs(),
        'TextQs': assessment.allTextQs,
        'teacherId': assessment.teacherId,
        'startTime': start,
        'endTime': end,
        'isText': assessment.allTextQs!.isNotEmpty ? true : false,
      });
    } catch (err) {
      print('error in add assessment: $err');
    }
    //print('function triggered');
  }

  Future<void> addAssessmentDeployment(
      DateTime start, DateTime end, String? assid) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment')
        .doc('$assid');
    return await ref.set({
      'startTime': start,
      'endTime': end,
    }, SetOptions(merge: true));
  }

  ///Used in student portal to add stundent's answers to db
  Future<void> addMCQAnswer(
    String? question,
    String? stat,
    String? ans,
    String? assid,
    String? uid,
    String? title,
    String? subject,
    String? name,
  ) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result')
        .doc('$assid');
    DocumentReference stud = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc(uid);

    ///for student collection, the assessment-mcqmarks map has been modified
    ///the key is now the assid and the value will a number indicating correct answers
    ///marks are added to an Assessment map which is all assessments in one place
    ///and one subject map which is only for the individual subject
    try {
      stud.set({
        'completed-assessments': FieldValue.arrayUnion([assid]),
        'Assessment-MCQMarks': {
          assid: stat == 'correct'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        },
        '$subject-MCQMarks': {
          assid: stat == 'correct'
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        },
      }, SetOptions(merge: true));
      ref.set({
        'title': title,
        'subject': subject,
      }, SetOptions(merge: true));
      return await ref.collection('student-IDs').doc(uid).set(
          {
            'name': name,
            'MCQAns': {'$question': stat},
            'MCQmarks': stat == 'correct'
                ? FieldValue.increment(1)
                : FieldValue.increment(0),
          },
          SetOptions(
            merge: true,
          ));
    } catch (err) {
      print('err in addMCQans: $err');
    }
  }

  ///adds marks to student and teacher
  Future<void> addTotalMarkToStudent(int mark, String uid, String assid,
      String? subject, String teacherId) async {
    DocumentReference stuRef = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc('$uid');
    DocumentReference teachRef = _db
        .collection('institutes')
        .doc(instID)
        .collection('teachers')
        .doc('$teacherId');
    await stuRef.set({
      'Assessment-textqMarks': {'$assid': mark},
      '$subject-textqMarks': {'$assid': mark}
    }, SetOptions(merge: true));
    return await teachRef.set(
        {
          'marked-textQs': {
            '$assid': FieldValue.arrayUnion(['$uid']),
          }
        },
        SetOptions(
          merge: true,
        ));
  }

  ///add the marks awarded by teacher to student's answer to assessment-result under
  ///student-id collection
  Future<void> addMarksToTextAns(
      String q, int mark, String assid, String uid) async {
    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result')
        .doc('$assid')
        .collection('student-IDs')
        .doc('$uid');

    return await ref.set({
      'TQMarks': {'$q': mark},
    }, SetOptions(merge: true));
  }

  //add answer of text q to db
  Future<void> addTextQAnswer(
    String? q,
    String a,
    String? assid,
    String? uid,
    String? title,
    String? name,
    String? subject,
  ) async {
    DocumentReference stud = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc(uid);

    DocumentReference ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('assessment-result')
        .doc('$assid');
    try {
      //first, adds assid to student doc to indicate that assessment has been attempted
      stud.set({
        'completed-assessments': FieldValue.arrayUnion([assid]),
      }, SetOptions(merge: true));
      ref.set({
        'title': title,
        'isText': true,
        'subject': subject,
      }, SetOptions(merge: true));
      //then saves to assessment-result
      return await ref.collection('student-IDs').doc(uid).set(
          {
            'name': name,
            'TQAs': {'$q': a},
            'TQMarks': {},
          },
          SetOptions(
            merge: true,
          ));
    } catch (err) {
      print('err in addMCQans: $err');
    }
  }

  //adds class data from edit tt to cf

  Future<void> saveStudent(
    List<UploadStudent> uploadStudents,
  ) async {
    if (instID != null) {
      CollectionReference studRef =
          _db.collection('institutes').doc(instID).collection('students');
      CollectionReference userRef = _db.collection('users');

      Future.forEach(
        uploadStudents,
        (UploadStudent stud) => auth
            .createUserWithEmailAndPassword(
              email: stud.email!,
              password: stud.password!,
            )
            .then((UserCredential cred) => stud.uid = cred.user!.uid),
      )
          .then(
            (value) => Future.forEach(
              uploadStudents,
              (UploadStudent student) => studRef.add(
                {
                  'name': student.name,
                  'email': student.email,
                  'password': student.password,
                  'registeredSubs': student.subMap,
                  'uid': student.uid,
                  'attendance': {},
                  'year': student.year,
                  'completed-assessments': [],
                  'batch': student.batch,
                  'section': student.section,
                  'parent-uid': '',
                  'profile-pic-url': '',
                },
              ),
            ),
          )
          .then(
            (value) => Future.forEach(
              uploadStudents,
              (UploadStudent student) => userRef.doc(student.uid).set(
                {
                  'role': 'student',
                  'email': student.email,
                  'password': student.password,
                  'name': student.name,
                },
                SetOptions(merge: true),
              ),
            ),
            //TODO: Add parent portal user creation
          )
          .then((value) =>
              Future.forEach(uploadStudents, (UploadStudent student) => null));
    } else {
      throw Exception('error in save student');
    }
  }

  Future<void> saveParent(
      String email, String password, StudentRank stud) async {
    /// 1. create new user for parent by calling auth
    /// 2. first then(): create doc in user collection for parent with the role parent
    /// 3. second then(): add the parent uid to students doc.

    CollectionReference userRef = _db.collection('users');
    DocumentReference studRef = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc(stud.id);
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential credential) {
        userRef.doc(credential.user!.uid).set({
          'instID': instID,
          'role': 'parent',
          'email': email,
          'password': password,
          'child_name': stud.name,
        }, SetOptions(merge: true)).then(
          (value) => studRef.set(
            {'parent-uid': credential.user!.uid},
            SetOptions(merge: true),
          ),
        );
      });
    } catch (e) {}
  }

  Future<void> saveTeacher(
    List<UploadTeacher> uploadTeachers,
  ) async {
    if (instID != null) {
      CollectionReference tRef =
          _db.collection('institutes').doc(instID).collection('teachers');
      CollectionReference userRef = _db.collection('users');

      Future.forEach(
        uploadTeachers,
        (UploadTeacher teach) => auth
            .createUserWithEmailAndPassword(
              email: teach.email!,
              password: teach.password!,
            )
            .then((UserCredential cred) => teach.uid = cred.user!.uid),
      )
          .then(
            (value) => Future.forEach(
              uploadTeachers,
              (UploadTeacher teacher) => tRef.add(
                {
                  'name': teacher.name,
                  'email': teacher.email,
                  'password': teacher.password,
                  'registeredSubs': teacher.subMap,
                  'uid': teacher.uid,
                  'isAdmin': false,
                  'Assessment-textqMarks': null,
                  'marked-textQs': {},
                  'profile-pic-url': '',
                },
              ),
            ),
          )
          .then(
            (value) => Future.forEach(
              uploadTeachers,
              (UploadTeacher teacher) => userRef.doc(teacher.uid).set(
                {
                  'role': 'teacher',
                  'email': teacher.email,
                  'password': teacher.password,
                  'name': teacher.name,
                },
                SetOptions(merge: true),
              ),
            ),
          );
    } else {
      throw Exception();
    }
  }

  void printInstID() {
    print('instID: $instID');
  }

  Future<void> editStudentYear(String? newYear, StudentRank stud) async {
    print(instID);
    if (instID != null) {
      try {
        DocumentReference studRef = _db
            .collection('institutes')
            .doc(instID)
            .collection('students')
            .doc(stud.id);
        try {
          await studRef.set(
            {'year': newYear},
            SetOptions(merge: true),
          );
        } catch (e) {
          print('error in editStudentYear db function: $e');
        }
      } on Exception catch (e) {
        print('error in editStudentYear: $e');
      }
    } else {
      throw Exception('instID null in editStudentYear');
    }
  }

  Future<void> editStudentSubs(
    List newSubs,
    StudentRank stud,
    String? year,
    String? section,
    List instSubs,
  ) async {
    // subs.forEach((sub, value) {
    //   if (newSubs.contains(sub)) {
    //     subs['$sub'] = true;
    //   } else {
    //     subs['$sub'] = false;
    //   }
    // });
    if (instID != null) {
      Map<String, bool> subs = {};
      instSubs.forEach((instSub) {
        if (newSubs.contains(instSub)) {
          subs[instSub] = true;
        } else {
          subs[instSub] = false;
        }
      });
      print('new subs being added, db editStudentSubs: $subs');

      DocumentReference studRef = _db
          .collection('institutes')
          .doc(instID)
          .collection('students')
          .doc(stud.id);
      try {
        await studRef.set(
          {
            'registeredSubs': subs,
            'section': section,
            'year': year,
          },
          SetOptions(merge: true),
        );
      } on Exception catch (e) {
        print('error in editStudentsSubs db function: $e');
      }
    } else {
      throw Exception('instID null');
    }
  }

  Future<void> editTeacherSubs(
    List newSubs,
    AllTeachers teach,
    String? year,
    String? section,
    List instSubs,
  ) async {
    // subs.forEach((sub, value) {
    //   if (newSubs.contains(sub)) {
    //     subs['$sub'] = true;
    //   } else {
    //     subs['$sub'] = false;
    //   }
    // });
    if (instID != null) {
      Map<String, bool> subs = {};
      instSubs.forEach((instSub) {
        if (newSubs.contains(instSub)) {
          subs[instSub] = true;
        } else {
          subs[instSub] = false;
        }
      });
      print('new subs being added, db editStudentSubs: $subs');

      DocumentReference studRef = _db
          .collection('institutes')
          .doc(instID)
          .collection('teachers')
          .doc(teach.id);
      try {
        await studRef.set(
          {
            'registeredSubs': subs,
            'section': section,
            'year': year,
          },
          SetOptions(merge: true),
        );
      } on Exception catch (e) {
        print('error in editStudentsSubs db function: $e');
      }
    } else {
      throw Exception('instID null');
    }
  }

  //adds edited class to cf
  Future<void> editClassInCF(
    String? id,
    String name,
    DateTime start,
    DateTime end,
    String? section,
    String? year, [
    String? topic,
  ]) async {
    final _classCollection =
        _db.collection('institutes').doc(instID).collection('classes');
    String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
    String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);
    try {
      return await _classCollection.doc(id).set({
        'subjectName': name,
        'startTime': startString,
        'endTime': endString,
        'topic': topic ?? '',
        'section': section,
      }, SetOptions(merge: true));
    } catch (err) {
      print('error in adding edited class: $err');
    }
  }

  Future<void> addProfileURL(String url, String uid) async {
    print(uid);
    DocumentReference userRef = _db.collection('users').doc(uid);
    QuerySnapshot stuQuery = await _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    try {
      await userRef.set({'profile-pic-url': url}, SetOptions(merge: true));
      await stuQuery.docs.first.reference.set(
        {'profile-pic-url': url},
        SetOptions(merge: true),
      );
    } catch (err) {
      print('error in addProfileURL: $err');
    }
  }

  Future<void> editAnnouncement(String? id, String? title, String? body,
      String uid, String? category) async {
    CollectionReference ref =
        _db.collection('institutes').doc(instID).collection('announcements');
    try {
      return await ref.doc(id).set({
        'title': title,
        'body': body,
        'addedBy': uid,
        'category': category,
      }, SetOptions(merge: true));
    } catch (err) {
      print('error in edit announcement: $err');
    }
  }

  //get attendance and class docs for Class Records data object(ClassData)
  Future<ClassData> getClassRecord(String? id) async {
    DocumentSnapshot attDoc = await _db
        .collection('institutes')
        .doc(instID)
        .collection('attendance')
        .doc(id)
        .get();
    DocumentSnapshot classDoc = await _db
        .collection('institutes')
        .doc(instID)
        .collection('classes')
        .doc(id)
        .get();
    ClassData cd = ClassData.fromFirestore(attDoc, classDoc);
    return cd;
  }

  Future<void> deleteClass(String id, List<StudentRank> students) async {
    final classRef =
        _db.collection('institutes').doc(instID).collection('classes');
    final attRef =
        _db.collection('institutes').doc(instID).collection('attendance');
    try {
      attRef.doc(id).delete();
      return await classRef.doc(id).delete().then(
            (value) => Future.forEach(
              students,
              (StudentRank stud) => deleteAttendanceRecordFromStud(stud.id, id),
            ),
          );
    } catch (err) {
      print('error in deleteClass: $err');
    }
  }

  Future<void> deleteMultiClasses(
      String id, List<StudentRank> students, Meeting cls) async {
    final classRef =
        _db.collection('institutes').doc(instID).collection('classes');
    final attRef =
        _db.collection('institutes').doc(instID).collection('attendance');

    try {
      attRef.doc(id).delete();
      final QuerySnapshot snapshot = await classRef
          .where(
            'subjectName',
            isEqualTo: '${cls.eventName}',
          )
          .get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;

      for (var doc in documents) {
        await doc.reference.delete();
      }
      return await classRef.doc(id).delete().then(
            (value) => Future.forEach(
              students,
              (StudentRank stud) => deleteAttendanceRecordFromStud(stud.id, id),
            ),
          );
    } catch (err) {
      print('error in deleteClass: $err');
    }
  }

  Future<void> deleteStudent(String studID) async {
    final studRef =
        _db.collection('institutes').doc(instID).collection('students');
    final CollectionReference<Map<String, dynamic>?> binRef =
        _db.collection('bin');
    try {
      // Get a reference to the assessment-result collection
      final CollectionReference assessmentResultCollection = _db
          .collection('institutes')
          .doc(instID)
          .collection('assessment-result');

      // Get all documents inside the assessment-result collection
      final QuerySnapshot querySnapshot =
          await assessmentResultCollection.get();

      // Loop through each document
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Get references to the stud id sub-collections
        final CollectionReference studIDColl =
            documentSnapshot.reference.collection('student-IDs');

        // Delete the student document from the studid sub-collection
        await studIDColl.doc(studID).delete();
      }

      //copy student data into bin, sets the same doc ID as in students collection
      studRef
          .doc(studID)
          .get()
          .then((value) => binRef.doc(value.id).set(value.data()));

      return await studRef.doc(studID).delete();
    } catch (err) {
      print('error in deleteStudent db: $err');
    }
  }

  Future<void> deleteAttendanceRecordFromStud(
      String studID, String attendanceid) async {
    final DocumentReference studRef = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc(studID);
    try {
      return await studRef.set({
        'attendance': {'$attendanceid': FieldValue.delete()}
      }, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<void> deleteAssessment(String? id) async {
    final ref = _db
        .collection('institutes')
        .doc(instID)
        .collection('remote-assessment');

    try {
      return await ref.doc(id).delete();
    } catch (err) {
      print('err in delete Assessment: $err');
    }
  }

  Future<void> deleteAnnouncement(String? id) async {
    final ref =
        _db.collection('institutes').doc(instID).collection('announcements');
    try {
      return await ref.doc(id).delete();
    } catch (err) {
      print('err in delete Announcement: $err');
    }
  }

  Future<void> deleteEntireAssignment(String? asgId) async {
    final asgRef =
        _db.collection('institutes').doc(instID).collection('assignment-marks');
    try {
      await asgRef.doc(asgId).delete();
    } catch (err) {
      print('err in delete assignment whole: $err');
    }
  }

  Future<void> deleteAssignment(
    String studId,
    String? asgId,
    String studName,
    String? subName,
  ) async {
    final ref =
        _db.collection('institutes').doc(instID).collection('assignment-marks');
    final studRef = _db
        .collection('institutes')
        .doc(instID)
        .collection('students')
        .doc(studId);
    try {
      await studRef.set({
        'assignment-marks': {'$asgId': FieldValue.delete()},
        '$subName-asgMarks': {'$asgId': FieldValue.delete()},
      }, SetOptions(merge: true));
      return await ref.doc(asgId).set({
        'student-marks': {'$studName': FieldValue.delete()},
        'uid-marks': {
          '$studId': FieldValue.delete(),
        }
      }, SetOptions(merge: true));
    } catch (err) {
      print('err in delete Announcement: $err');
    }
  }

  Future<List<String>?> fetchBooknames() async {
    try {
      List<String> booknames = [];

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('institutes')
          .doc("RIBR3Pwr3We2D5IQPF5O")
          .collection('textbook_vectors')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("not empty");
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          print(doc.id);
          final bookname = doc.get('bookname');
          if (bookname != null) {
            booknames.add(bookname);
          }
        }
        print(booknames);
        return booknames;
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<List<String>?> fetchUrls(String bookname) async {
    try {
      List<String> urls = [];

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('institutes')
          .doc("RIBR3Pwr3We2D5IQPF5O")
          .collection('textbook_vectors')
          .where('bookname', isEqualTo: bookname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("not empty");
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          print(doc.id);
          final urlList = doc.get('urls');
          if (urlList != null) {
            for (var item in urlList) {
              urls.add(item.toString());
            }
          }
        }
        print(urls);
        if (urls.isNotEmpty) {
          return urls;
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }
}
