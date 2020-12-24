import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../models/dummy_data.dart';

class AllStudents with ChangeNotifier {
  // Map<Student, AttendanceStatus> attendanceStatus = {};
  List<Student> _allStudentsInClass =
      allStudentDummy; //this is where all students registered in class logic will be passed

  //_allStudentsInCLass represents all students registered for that course. it is currently assigned a dummy data
  //attendance status is a map of students as keys and their attendance status as values

  List<Student> get allInClass {
    return [..._allStudentsInClass];
  }

  int getNumofStudents() {
    return _allStudentsInClass.length;
  }

  List<String> getRegStudsID(SubjectName sub) {
    //returns a list of strings which are the ids of all of the students who are registered for the class.
    //the registration status is stored in a map
    List allKeys;
    List allVals;
    final allRegStudents = allInClass.where((i) {
      allKeys = i.regSubs.keys.toList();
      allVals = i.regSubs.values.toList();
      return allVals[allKeys.indexOf(sub)] == true;
    }).toList();

    return allRegStudents.map((i) {
      return i.getId;
    }).toList();
  }
}
