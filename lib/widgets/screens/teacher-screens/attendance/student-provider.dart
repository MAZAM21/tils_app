import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student.dart';
import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/service/db.dart';

import 'package:tils_app/widgets/screens/teacher-screens/attendance/attendance-marker-builder.dart';

class StudentProvider extends StatelessWidget {
  //adds a document to attendance collection
  static const routeName = '/student-provider';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final sub = ModalRoute.of(context)!.settings.arguments as SubjectClass;
    final subName = sub.subjectName;
    final subId = sub.id;
    db.addClassDetailToAttColl(subName, subId, sub.startTime!);
    try {
      return FutureProvider<List<Student>?>(
        initialData: [],
        create: (ctx) => db.getStudentsBySub(subName),
        child: AttendanceMarkerBuilder(),
      );
    } on Exception catch (e) {
      print('error in studentprovider attendance: $e');
    }
    throw Exception;
  }
}

// this is where I fetch student's from database based on subjects. I need to do this in root file because 
//I need to fetch student's all the time.