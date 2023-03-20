import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tils_app/models/admin-user-data.dart';
import 'package:tils_app/models/allTextQAs.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/metrics.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/models/student-answers.dart';
import 'package:tils_app/models/student-textAnswers.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/upload-service.dart';
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


class DatabaseService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //gets classes collection data and converts to Meeting list for TT
  Stream<List<Meeting>> streamMeetings() {
    CollectionReference ref = _db.collection('classes');
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
    CollectionReference ref = _db.collection('classes');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => SubjectClass.fromFirestore(doc)).toList());
  }

  //gets attendance collection and converts to attendance for attendance status
  Stream<List<Attendance>> streamAttendance() {
    CollectionReference ref = _db.collection('attendance');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Attendance.fromFirestore(doc)).toList());
  }

  Stream<List<StudentRank>> streamStudents() {
    try {
      CollectionReference ref = _db.collection('students');
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentRank.fromFirestore(doc)).toList());
    } catch (e) {
      print('error in student list stream db:' + e);
    }
    return null;
  }

  //gets data from student collection and checks uid and then makes data into studentuser
  Stream<StudentUser> streamStudentUser(String uid) {
    try {
      CollectionReference ref = _db.collection('students');
      return ref.snapshots().map((list) => StudentUser.fromFirestore(
          list.docs.firstWhere((doc) => doc['uid'] == uid)));
    } catch (e) {
      print('bloody error: $e');
    }
    return null;
  }

  //gets data from student collection and checks uid and then makes data into teacheruser
  Stream<TeacherUser> streamTeacherUser(String uid) {
    CollectionReference ref = _db.collection('teachers');
    return ref.snapshots().map((list) => TeacherUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)));
  }

  Stream<ParentUser> streamParentUser(String puid) {
    CollectionReference ref = _db.collection('students');
    return ref.snapshots().map((list) => ParentUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['parent-uid'] == puid)));
  }

  Stream<List<ResourceDownload>> streamResource() {
    CollectionReference ref = _db.collection('resources');
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => ResourceDownload.fromFirestore(doc)).toList());
  }

  Stream<AdminUser> streamAdminUser(String uid) {
    CollectionReference ref = _db.collection('admins');
    return ref.snapshots().map((list) => AdminUser.fromFirestore(
        list.docs.firstWhere((doc) => doc['uid'] == uid)));
  }

  Stream<List<Announcement>> streamAnnouncement() {
    CollectionReference ref = _db.collection('announcements');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => Announcement.fromFirestore(doc)).toList());
    } catch (err) {
      print('err in stream announcement: $err');
    }
    return null;
  }

  /// stream Assignment Marks
  Stream<List<AMfromDB>> streamAM() {
    CollectionReference ref = _db.collection('assignment-marks');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => AMfromDB.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in streamAM: $err');
    }
    return null;
  }

  Stream<List<RAfromDB>> streamRA() {
    CollectionReference ref = _db.collection('remote-assessment');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => RAfromDB.fromFirestore(doc)).toList());
    } catch (err) {
      print('err in stream RA: $err');
    }
    return null;
  }

  ///stream all submitted text answers scripts for all assessments
  Stream<List<TextQAs>> streamTextQAs() {
    CollectionReference ref = _db.collection('assessment-result');

    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => TextQAs.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in stream textqas: $err');
    }
    return null;
  }

  Stream<List<StudentAnswers>> streamResFromID(String assid) {
    try {
      CollectionReference ref = _db
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentAnswers.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in stream ans from id db: $err');
    }
    return null;
  }

  ///stream list of scripts for chosen assessment
  Stream<List<StudentTextAns>> streamAnsFromID(String assid) {
    try {
      CollectionReference ref = _db
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentTextAns.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in stream ans from id db: $err');
    }
    return null;
  }

  ///get metrics stream as a collection
  Stream<List<StudentMetrics>> streamMetrics() {
    CollectionReference ref = _db.collection('metrics');
    try {
      return ref.snapshots().map((list) =>
          list.docs.map((doc) => StudentMetrics.fromFirestore(doc)).toList());
    } catch (err) {
      print('error in metrics strea: $err');
    }
    return null;
  }

  ///gets auth state stream
  Stream<User> authStateStream() {
    return auth.authStateChanges();
  }

  ///gets students collection data as per the registeration status of student
  Future<List<Student>> getStudentsBySub(String subName) async {
    CollectionReference ref = _db.collection('students');
    try {
      QuerySnapshot<Map<String, dynamic>> query =
          await ref.where('registeredSubs.$subName', isEqualTo: true).get();
      return query.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('error in getstudbysub $err');
    }
    return null;
  }

  Future<String> downloadWithUrl (String url)async  {
    
    final httpsReference = FirebaseStorage.instance.refFromURL(url);
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

  ///get all student docs from student collection
  Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> ref =
          await _db.collection('students').get();
      return ref.docs.map((doc) => Student.fromFirestore(doc)).toList();
    } catch (err) {
      print('err in getallstudents $err');
    }
    return null;
  }

  Future<List<String>> getAllAssessmentIds() async {
    CollectionReference ref = _db.collection('remote-assessment');
    List<String> allIds = [];
    try {
      QuerySnapshot<Map<String, dynamic>> allDocs = await ref.get();
      allDocs.docs.forEach((doc) {
        allIds.add(doc.id);
      });
      return allIds;
    } catch (err) {
      print('err in getallassessments: $err');
    }
    return null;
  }

  Future<List<String>> getAllARTitles(String subject) async {
    CollectionReference ref = _db.collection('assessment-result');
    List<String> titles = [];
    try {
      QuerySnapshot<Map<String, dynamic>> qtitles =
          await ref.where('subject', isEqualTo: '$subject').get();
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

  Future<List<ARStudent>> getARData(
    String subject,
  ) async {
    CollectionReference ref = _db.collection('assessment-result');
    CollectionReference assref = _db.collection('remote-assessment');
    CollectionReference stu = _db.collection('students');

    ///map containing {ids, titles}
    Map<String, String> idTitles = {};

    //map of number of questions and assid
    Map<String, int> idL = {};

    try {
      //all assessments results of subject
      QuerySnapshot<Map<String, dynamic>> qtitles =
          await ref.where('subject', isEqualTo: '$subject').get();
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
      QuerySnapshot<Map<String, dynamic>> qs =
          await stu.where('registeredSubs.$subject', isEqualTo: true).get();
      return qs.docs.map((doc) {
        // print(doc['name']);
        return ARStudent.fromFirebase(doc, idTitles, idL);
      }).toList();
    } catch (e) {
      print('err in getARDATA db: $e');
    }
    return null;
  }

  Future<Map<String, int>> getAllStudentMarks(String assid) async {
    try {
      CollectionReference ref = _db
          .collection('assessment-result')
          .doc('$assid')
          .collection('student-IDs');
      Map<String, int> allStMarks = {};
      QuerySnapshot<Map<String, dynamic>> q = await ref.get();
      q.docs.forEach((doc) {
        final Map tqmarks = {...doc['TQMarks']};
        final name = doc['name'];
        int l = tqmarks.length;
        //print(l);
        if (l != 0) {
          int allTotal = tqmarks.values.fold(0, (p, e) => p + e);
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

  Future<void> addClassToCF(
    SubjectName name,
    DateTime start,
    DateTime end,
    String section, [
    String topic,
  ]) async {
    final _classCollection = _db.collection('classes');
    String startString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(start);
    String endString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(end);
    String notification = DateFormat("EEE, dd-MM hh:mm a").format(start);

    try {
      return await _classCollection.add({
        'subjectName': enToString(name),
        'startTime': startString,
        'endTime': endString,
        'topic': topic ?? '',
        'section': section,
        'notification': notification,
      });
    } catch (err) {
      print('error in adding to database: $err');
    }
  }

  ///new attendance addition
  Future<void> addAttendanceRecord(
    AttendanceInput attInput,
    List<StudentRank> students,
  ) async {
    ///In this new approach, attendance stutas will be stored as a map in classes document
    ///attendance collection has been killed
    ///attendance status is now part of SubjectClass

    CollectionReference ref = _db.collection('classes');

    return await ref.doc(attInput.classID).set({
      'attStat': attInput.attendanceStatus,
      'timeUpdated': DateTime.now(),
    }, SetOptions(merge: true)).then(
      (value) => Future.forEach(
        students,
        (StudentRank stud) => addAttToStudent(
            stud,
            attInput.classID,
            attInput.attendanceStatus['${stud.id}'],
            attInput.subject,
            attInput.date),
      ),
    );
  }

  Future<void> addAttToStudent(StudentRank student, String clsId, int stat,
      String subName, String notifdate) async {
    CollectionReference studentRef = _db.collection('students');
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
      StudentRank stud, String clsName, String date) async {
    FirebaseFunctions.instance.httpsCallable('studentAbsentNotif').call({
      'className': clsName,
      'studentName': stud.name,
      'parentToken': stud.parentToken,
      'date': date,
    });
  }

  Future<void> uploadTest(ResourceUploadObj file) {
    final Reference storage = FirebaseStorage.instance.ref();
    final Reference fileRef = storage.child('resources/');
    fileRef.putFile(File(file.resourceFiles.first.path));
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
    final List<Map<String, String>> downloadUrls = [];
    final List<UploadTask> uploadTasks = [];

    for (final file in resourceUploadObj.resourceFiles) {
      // Get a reference to the file in Firebase Storage
      final Reference fileRef = storageRef.child(
          'resources/${resourceUploadObj.subject}/${resourceUploadObj.date}/${file.name}');

      print('refrecence added storage');

      // Upload the file to Firebase Storage
      Future<String> downloadUrlFuture;

      await fileRef.putFile(File(file.path)).then((p0) {
        downloadUrlFuture = p0.ref.getDownloadURL();
      });

      final Map<String, String> downloadUrlMap =
          await downloadUrlFuture.then((downloadUrl) {
        return {file.name: downloadUrl};
      });

      downloadUrls.add(downloadUrlMap);

      print('fileRef: $fileRef');
      print('downloadUrlFuture: $downloadUrlFuture');
      print('downloadUrlMap: $downloadUrlMap');
      print('downloadUrls length: ${downloadUrls.length}');
      print('uploadTasks length: ${uploadTasks.length}');
      print('Get a future for the download URL for the uploaded file');
    }

    // Create a document in Cloud Firestore with the relevant information
    final DocumentReference docRef = _db.collection('resources').doc();
    print('doc created');

    await docRef.set({
      'date': resourceUploadObj.date,
      'topic': resourceUploadObj.topic,
      'subject': resourceUploadObj.subject,
      'uploadTeacher': resourceUploadObj.uploadTeacher,
      'downloadUrls': Map<String, String>.fromIterable(
        downloadUrls.expand((map) => map.entries),
        key: (entry) => entry.key,
        value: (entry) => entry.value,
      ),
    });

    yield 1;

    // Return a stream that emits the upload progress as a percentage
    // double totalBytes = 0;
    // double bytesUploaded = 0;

    // for (final uploadTask in uploadTasks) {
    //   totalBytes += uploadTask.snapshot.totalBytes;
    //   print('total bytes: $totalBytes');
    // }

    // for (final uploadTask in uploadTasks) {
    //   await for (final event in uploadTask.snapshotEvents) {
    //     bytesUploaded += event.bytesTransferred;
    //     print('bytesUploaded: $bytesUploaded');

    //     final double progress = bytesUploaded / totalBytes;
    //     print('progress = ${bytesUploaded / totalBytes * 100}');
    //     yield progress;
    //   }
    // }
  }

  Stream<double> uploadTasks(List<UploadTask> tasks) async* {
    final progressStream = StreamController<double>();

    int totalBytes = 0;
    int uploadedBytes = 0;

    for (final task in tasks) {
      totalBytes += task.snapshot.totalBytes;

      final streamSubscription = task.snapshotEvents.listen((snapshot) {
        uploadedBytes += snapshot.bytesTransferred;

        final progress = uploadedBytes / totalBytes;
        progressStream.add(progress);
      });

      await task.whenComplete(() {
        streamSubscription.cancel();
      });
    }

    progressStream.close();
    yield 1;
  }

  //adds attendance status to database in attendance and individual student document
  Future<void> addAttToCF(String name, int status, String id) async {
    CollectionReference ref = _db.collection('attendance');
    CollectionReference studentRef = _db.collection('students');
    try {
      //gets doc of student
      QuerySnapshot<Map<String, dynamic>> q =
          await studentRef.where('name', isEqualTo: '$name').get();
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
    String className,
    String id,
    DateTime date,
  ) async {
    String dateString = DateFormat("yyyy-MM-dd hh:mm:ss a").format(date);
    try {
      CollectionReference ref = _db.collection('attendance');
      return await ref.doc(id).set(
          {'subName': className, 'classDate': dateString},
          SetOptions(merge: true));
    } catch (err) {
      print('err in addclassdetail $err');
    }
  }

  //gets user role as string
  Future<Role> getRole(String uid) async {
    CollectionReference ref = _db.collection('users');
    DocumentSnapshot query = await ref.doc(uid).get();
    Role role = Role.fromFirestore(query);
    return role;
  }

  ///Add token to teacher doc
  Future<void> addTokenToTeacher(String token, String tID) async {
    DocumentReference ref = _db.collection('teachers').doc('$tID');
    try {
      return await ref.set({
        'token-FCM': token,
        'token-time-added': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('error in addTokenToTeacher: $e');
    }
  }

  Future<void> addTokenToStudent(String token, String studID) async {
    DocumentReference ref = _db.collection('students').doc('$studID');
    try {
      return await ref.set({
        'student-token': token,
        'token-time-added': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('error in addTokenToStudent: $e');
    }
  }

  Future<void> addParentTokenToStudent(String token, String studID) async {
    DocumentReference ref = _db.collection('students').doc('$studID');
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
    String title,
    String body,
    String uid,
    DateTime now,
    String category,
  ) async {
    CollectionReference ref = _db.collection('announcements');
    try {
      return await ref.add({
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

  Future<void> addAssignmentToCF([AssignmentMarks am, AMfromDB editAm]) async {
    ///New approach is being tested here
    try {
      /// if editAm is not passed then adding new assignment code executes
      if (editAm == null) {
        CollectionReference ref = _db.collection('assignment-marks');
        return await ref.add(
          {
            'title': am.title,
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
            am.uidMarks.entries,
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
      } else if (editAm != null) {
        DocumentReference eref =
            _db.collection('assignment-marks').doc(editAm.docId);
        return await eref.set(
          {
            'student-marks': editAm.nameMarks,
            'uid-marks': editAm.uidMarks,
          },
          SetOptions(merge: true),
        ).then(
          (value) => Future.forEach(
            editAm.uidMarks.entries,
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
      int m, String id, String docId, String subject) async {
    try {
      DocumentReference ref = _db.collection('students').doc(id);

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
    CollectionReference ref = _db.collection('remote-assessment');
    DateTime start;
    DateTime end;
    if (assessment.deployTime != null && assessment.deadline != null) {
      start = assessment.deployTime;
      end = assessment.deadline;
    } else {
      start = null;
      end = null;
    }
    try {
      return await ref.add({
        'title': assessment.assessmentTitle,
        'subject': assessment.subject,
        'timeCreated': assessment.timeAdded,
        'MCQs': assessment.returnMcqs(),
        'TextQs': assessment.allTextQs,
        'teacherId': assessment.teacherId,
        'startTime': start,
        'endTime': end,
        'isText': assessment.allTextQs.isNotEmpty ? true : false,
      });
    } catch (err) {
      print('error in add assessment: $err');
    }
    //print('function triggered');
  }

  Future<void> addAssessmentDeployment(
      DateTime start, DateTime end, String assid) async {
    DocumentReference ref = _db.collection('remote-assessment').doc('$assid');
    return await ref.set({
      'startTime': start,
      'endTime': end,
    }, SetOptions(merge: true));
  }

  ///Used in student portal to add stundent's answers to db
  Future<void> addMCQAnswer(
    String question,
    String stat,
    String ans,
    String assid,
    String uid,
    String title,
    String subject,
    String name,
  ) async {
    DocumentReference ref = _db.collection('assessment-result').doc('$assid');
    DocumentReference stud = _db.collection('students').doc(uid);

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
      String subject, String teacherId) async {
    DocumentReference stuRef = _db.collection('students').doc('$uid');
    DocumentReference teachRef = _db.collection('teachers').doc('$teacherId');
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
    String q,
    String a,
    String assid,
    String uid,
    String title,
    String name,
    String subject,
  ) async {
    DocumentReference stud = _db.collection('students').doc(uid);

    DocumentReference ref = _db.collection('assessment-result').doc('$assid');
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
    CollectionReference studRef = _db.collection('students');
    CollectionReference userRef = _db.collection('users');

    Future.forEach(
      uploadStudents,
      (UploadStudent stud) => auth
          .createUserWithEmailAndPassword(
            email: stud.email,
            password: stud.password,
          )
          .then((UserCredential cred) => stud.uid = cred.user.uid),
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
  }

  Future<void> saveTeacher(
    List<UploadTeacher> uploadTeachers,
  ) async {
    CollectionReference tRef = _db.collection('teachers');
    CollectionReference userRef = _db.collection('users');

    Future.forEach(
      uploadTeachers,
      (UploadTeacher teach) => auth
          .createUserWithEmailAndPassword(
            email: teach.email,
            password: teach.password,
          )
          .then((UserCredential cred) => teach.uid = cred.user.uid),
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
  }

  //adds edited class to cf
  Future<void> editClassInCF(
    String id,
    String name,
    DateTime start,
    DateTime end,
    String section, [
    String topic,
  ]) async {
    final _classCollection = _db.collection('classes');
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

  Future<void> editAnnouncement(
      String id, String title, String body, String uid, String category) async {
    CollectionReference ref = _db.collection('announcements');
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
  Future<ClassData> getClassRecord(String id) async {
    DocumentSnapshot attDoc = await _db.collection('attendance').doc(id).get();
    DocumentSnapshot classDoc = await _db.collection('classes').doc(id).get();
    ClassData cd = ClassData.fromFirestore(attDoc, classDoc);
    return cd;
  }

  Future<void> deleteClass(String id, List<StudentRank> students) async {
    final classRef = _db.collection('classes');
    final attRef = _db.collection('attendance');
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

  Future<void> deleteStudent(String studID) async {
    final studRef = _db.collection('students');
    final binRef = _db.collection('bin');
    try {
      // Get a reference to the assessment-result collection
      final CollectionReference assessmentResultCollection =
          _db.collection('assessment-result');

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
    final DocumentReference studRef = _db.collection('students').doc(studID);
    try {
      return await studRef.set({
        'attendance': {'$attendanceid': FieldValue.delete()}
      }, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<void> deleteAssessment(String id) async {
    final ref = _db.collection('remote-assessment');

    try {
      return await ref.doc(id).delete();
    } catch (err) {
      print('err in delete Assessment: $err');
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final ref = _db.collection('announcements');
    try {
      return await ref.doc(id).delete();
    } catch (err) {
      print('err in delete Announcement: $err');
    }
  }

  Future<void> deleteAssignment(
    String studId,
    String asgId,
    String studName,
    String subName,
  ) async {
    final ref = _db.collection('assignment-marks');
    final studRef = _db.collection('students').doc(studId);
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
}

SubjectName setSubject(String sub) {
  switch (sub) {
    case 'Jurisprudence':
      return SubjectName.Jurisprudence;
      break;
    case 'Trust':
      return SubjectName.Trust;
      break;
    case 'Conflict':
      return SubjectName.Conflict;
      break;
    case 'Islamic':
      return SubjectName.Islamic;
      break;
    case 'Company':
      return SubjectName.Company;
      break;
    case 'Tort':
      return SubjectName.Tort;
      break;
    case 'Property':
      return SubjectName.Property;
      break;
    case 'EU':
      return SubjectName.EU;
      break;
    case 'HR':
      return SubjectName.HR;
      break;
    case 'Contract':
      return SubjectName.Contract;
      break;
    case 'Criminal':
      return SubjectName.Criminal;
      break;
    case 'LSM':
      return SubjectName.LSM;
      break;
    case 'Public':
      return SubjectName.Public;
      break;
    default:
      return SubjectName.Undeclared;
  }
}

String enToString(SubjectName name) {
  switch (name) {
    case SubjectName.Jurisprudence:
      return 'Jurisprudence';
      break;
    case SubjectName.Trust:
      return 'Trust';
      break;
    case SubjectName.Conflict:
      return 'Conflict';
      break;
    case SubjectName.Islamic:
      return 'Islamic';
      break;
    case SubjectName.Company:
      return 'Company';
      break;
    case SubjectName.Tort:
      return 'Tort';
      break;
    case SubjectName.Property:
      return 'Property';
      break;
    case SubjectName.EU:
      return 'EU';
      break;
    case SubjectName.HR:
      return 'HR';
      break;
    case SubjectName.Contract:
      return 'Contract';
      break;
    case SubjectName.Criminal:
      return 'Criminal';
      break;
    case SubjectName.LSM:
      return 'LSM';
      break;
    case SubjectName.Public:
      return 'Public';
      break;
    default:
      return 'Undeclared';
  }
}
