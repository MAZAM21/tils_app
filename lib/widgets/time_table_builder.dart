import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/widgets/screens/time_table.dart';
import 'package:firebase_core/firebase_core.dart';

class TimeTableBuilder extends StatelessWidget {
  static const routeName = '/time-table-builder';
  @override
  Widget build(BuildContext context) {
    CollectionReference _allClasses =
        FirebaseFirestore.instance.collection('classes');
    List<Meeting> _meetings = [];
    return StreamBuilder<QuerySnapshot>(
      stream: _allClasses.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error in timetable builder');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final alldocs = snapshot.data.docs;
        alldocs.forEach((doc) {
          _meetings.add(Meeting(
            doc['subjectName'],
            DateFormat("yyyy-MM-dd hh:mm:ss a").parse(doc['startTime']),
            DateFormat("yyyy-MM-dd hh:mm:ss a").parse(doc['endTime']),
            Colors.amberAccent,
            false,
            doc.id,
          ));
          print(doc.id);
        });
        return CalendarApp(_meetings);
      },
    );
  }
}

//_meeting needed to be instantiated
//to do: add delete functionality