import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StudentMetrics with ChangeNotifier {
  Map<String, Map> assignmentMarks;
  String name;
  StudentMetrics({
    this.assignmentMarks,
    this.name,
  });
  factory StudentMetrics.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      Map asMarks = {};
      Map allSorted = {};
      if (doc.id == 'assignment-marks') {
        /// assignment-marks metric document contains maps of assignment marks as they stand every day
        /// the data structre is [Map<String, Map>]
        /// We need track the changes in metrics across time
        asMarks = doc.data();

        /// sorted is the map of assignment marks sorted according to the latest time
        /// the first key is the earliest milliseconds from epoch value
        SplayTreeMap<String, Map> sorted =
            SplayTreeMap.from(asMarks, (a, b) => a.compareTo(b));

        /// then we sort each of the assignment marks map <student id, mark>
        /// according to mark with the highest first
        sorted.forEach((key, value) {
          Map studMarks = {...value};
          SplayTreeMap sortedValue = SplayTreeMap<String, int>.from(
              studMarks, (a, b) => studMarks[b].compareTo(studMarks[a]));
          sorted[key] = sortedValue;
          //print(sortedValue);
        });
        allSorted = sorted;
      }
      return StudentMetrics(
        assignmentMarks: allSorted,
        name: doc.id,
      );
    } on Exception catch (e) {
      print('error in metrics constructor: $e');
      // TODO
    }
    return null;
  }
}
