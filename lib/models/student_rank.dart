import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

enum StudentRankYear {
  First,
  Second,
  Third,
}

class StudentRank with ChangeNotifier {
  final String id;
  final String name;
  final String batch;
  final String section;
  final String year;
  final String imageUrl;
  final Map attendance;
  final Map textMarks;

  // all mcq marks.
  // map with keys as assessment id and value as score
  // 1 represents correct
  final Map mcqMarks;

  //List of subjects as strings
  final List subjects;

  //Assignment Marks
  Map assignmentMarks = {};

  //List of assessment IDs of all attempted assessments
  List completedAssessements = [];

  ///raScore is a map with subject names as keys and total ra score as value
  Map raSubScore;

  Map subPosition;

  /// attendance percentage basically
  double attendanceScore;

  int attendancePosition;

  // assignment score.
  double assignmentScore;

  int assignmentPosition;

  /// Year score. gotten from adding all subjects in the year you're in
  double yearScore;

  int yearPosition;

  StudentRank({
    @required this.id,
    @required this.name,
    @required this.year,
    @required this.batch,
    @required this.section,
    this.imageUrl,
    @required this.attendance,
    @required this.textMarks,
    @required this.mcqMarks,
    this.completedAssessements,
    this.raSubScore,
    this.assignmentMarks,
    this.subjects,
    this.attendanceScore,
    this.assignmentScore,
    this.yearScore,
    this.assignmentPosition,
    this.attendancePosition,
    this.yearPosition,
    this.subPosition,
  });

  factory StudentRank.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      Map data = doc.data();
      Map att = {...data['attendance'] ?? {}};
      Map tqm = {};
      Map mcqm = {};
      Map asgMap = {};
      final String year = data['year'] ?? '';
      final Map subs = {...data['registeredSubs'] ?? {}};
      final completed = List<String>.from(data['completed-assessments'] ?? []);
      List regSubs = [];
      Map ras = {};
      double attScore = 0;
      double asgScore = 0;
      double yearScore = 0;

      String getYearofSub(String sub) {
        if (sub == 'Jurisprudence' ||
            sub == 'Conflict' ||
            sub == 'Trust' ||
            sub == 'Company' ||
            sub == 'Islamic') {
          return '3';
        } else if (sub == 'Tort' ||
            sub == 'Property' ||
            sub == 'EU' ||
            sub == 'HR') {
          return '2';
        } else if (sub == 'Contract' ||
            sub == 'Criminal' ||
            sub == 'Public' ||
            sub == 'LSM') {
          return '1';
        } else {
          return null;
        }
      }

      //takse internal hash map and checks reg status
      subs.forEach((k, v) {
        if (v == true) {
          regSubs.add(k);
        }
      });

      /// For each subject gets total score
      /// db has subname-textqmarks and subname-mcqmarks field
      if (regSubs.isNotEmpty) {
        regSubs.forEach((sub) {
          //adds text q  marks to rasub value
          if (data.containsKey('$sub-textqMarks') &&
              data['$sub-textqMarks'].values.length > 0) {
            //folds all data into one totalvalue for that particular sub
            int total = data['$sub-textqMarks'].values.fold(0, (a, b) => a + b);

            if (ras.containsKey('$sub')) {
              ras['$sub'] += total;
            } else {
              ras.addAll({'$sub': total});
            }

            //else if added because .fold method does not work on a single value
          }

          // adds mcqmars to ra sub value
          if (data.containsKey('$sub-MCQMarks') &&
              data['$sub-MCQMarks'].values.length > 0) {
            int mcqtotal =
                data['$sub-MCQMarks'].values.fold(0, (a, b) => a + b);
            mcqtotal = 70 * mcqtotal;
            //print('mcq:$mcqtotal');
            if (ras.containsKey('$sub')) {
              ras['$sub'] += mcqtotal;
            } else {
              ras.addAll({'$sub': mcqtotal});
            }
          }

          //adds assignment subject marks
          if (data.containsKey('$sub-asgMarks') &&
              data['$sub-asgMarks'].values.length > 0) {
            //folds all data into one totalvalue for that particular sub
            int asgtotal =
                data['$sub-asgMarks'].values.fold(0, (a, b) => a + b);
            if (ras.containsKey('$sub')) {
              ras['$sub'] += asgtotal;
            } else {
              ras.addAll({'$sub': asgtotal});
            }
            //print('$sub $asgtotal');

            //else if added because .fold method does not work on a single value
          }

          //print('$sub = ${ras[sub]}');
        });

        ///iterates through ras and adds all values to yearscore,
        ras.forEach((key, value) {
          if (year == getYearofSub(key) && value != null) {
            yearScore += value;
          }
        });
        //print('${data['name']} $yearScore');
      }

      /// All assessment text question marks in one map
      if (data.containsKey('Assessment-textqMarks')) {
        tqm = {...data['Assessment-textqMarks'] ?? {}};
      } else {
        tqm = {'none': 0};
      }

      /// All mcq marks in one map
      if (data.containsKey('Assessment-MCQMarks')) {
        mcqm = {...data['Assessment-MCQMarks'] ?? {}};
      } else {
        mcqm = {'none': 0};
      }

      /// gets the map of assignment marks which has
      /// assignment ids as keys and marks as values
      /// iterating and adding all keys gives assginment score
      if (data.containsKey('assignment-marks')) {
        asgMap = {...data['assignment-marks']};
        asgMap.forEach((id, mark) {
          if (mark != null) {
            asgScore += mark;
          }
        });

        /// print('${data['name']} asgScore : $asgScore');
      } else {
        asgMap = {'none': 0};
      }

      if (data.containsKey('attendance')) {
        //attendance score
        att = {...data['attendance'] ?? {}};
        att.forEach((classId, attStat) {
          if (attStat == 1) {
            attScore++;
          } else if (attStat == 2) {
            attScore += 0.5;
          }
        });

        ///print('${data['name']} att :$attScore');
      } else {
        att = {'none': 0};
      }

      print(
          '${data['name']}, asgSore: $asgScore,  yearScore: $yearScore, attScore: $attScore , ras: $ras');
      return StudentRank(
        id: doc.id ?? '',
        name: data['name'] ?? '',
        year: year,
        batch: data['batch'] ?? '',
        section: data['section'] ?? '',
        imageUrl: data['profile-pic-url'] ?? '',
        attendance: att,
        textMarks: tqm,
        mcqMarks: mcqm,
        completedAssessements: completed,
        subjects: regSubs,
        raSubScore: ras,
        attendanceScore: attScore,
        assignmentMarks: asgMap,
        assignmentScore: asgScore,
        yearScore: yearScore,
      );
    } catch (e) {
      print('error in StudentRank model: $e');
    }

    return null;
  }
}

/// This model is to have all StudentRank data so that it can be used for score, attendance, and assessment.
/// TODO: Instead of sorting through all of the maps in Ranking service, methods can be added here that serve up the required data
/// like total and obtained marks per subject, Overall total score. Excellent Idea. Was missing this.
