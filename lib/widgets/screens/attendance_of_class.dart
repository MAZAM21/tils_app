// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:tils_app/providers/all_students.dart';
// import 'package:tils_app/models/subject.dart';
// import 'package:tils_app/models/student.dart';

// class AttendanceOfClass extends StatefulWidget {
//   static const routeName = '/attendance-of-class';
  

//   @override
//   _AttendanceOfClassState createState() => _AttendanceOfClassState();
// }

// class _AttendanceOfClassState extends State<AttendanceOfClass> {
  
//   Widget buildAttButton(
//     Student stud,
//     SubjectClass classData,
//     String buttonText,
//     AttendanceStatus status,
//     MaterialColor color,
//   ) {
//     return Flexible(
//       fit: FlexFit.loose,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton(
//           onPressed: () {
//             //we want to update each individuals present status as well ass all of the registered students status
//             setState(() {
//               stud.addRec(classData.id, status);
//               classData.addStatus(stud, status);
//             });
//           },
//           child: Text(
//             buttonText,
//             style: TextStyle(color: Colors.black),
//           ),
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(color),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAttTile(Student stud, SubjectClass classData, BuildContext ctx) {
//     return ListTile(
//       leading: Container(
//         width: 150,
//         child: Flex(
//           direction: Axis.horizontal,
//           children: <Widget>[
//             Expanded(
//               child: Text(
//                 stud.name,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//       trailing: Container(
//         width: 180,
//         child: Row(children: <Widget>[
//           buildAttButton(
//               stud, classData, 'P', AttendanceStatus.Present, Colors.green),
//           buildAttButton(
//               stud, classData, 'L', AttendanceStatus.Late, Colors.yellow),
//           buildAttButton(
//               stud, classData, 'A', AttendanceStatus.Absent, Colors.red),
//         ]),
//       ),
//       tileColor: statusColor(classData, stud, ctx),
//     );
//   }

//   Color statusColor(SubjectClass classData, Student stud, BuildContext ctx) {
//     switch (classData.attendanceStatus[stud]) {
//       case AttendanceStatus.Present:
//         return Colors.green;
//         break;
//       case AttendanceStatus.Absent:
//         return Colors.red;
//         break;
//       case AttendanceStatus.Late:
//         return Colors.yellow;
//         break;
//       default:
//         return Theme.of(ctx).backgroundColor;
//     }
//   }

//   String enToString(SubjectName name) {
//     switch (name) {
//       case SubjectName.Jurisprudence:
//         return 'Jurisprudence';
//         break;
//       case SubjectName.Trust:
//         return 'Trust';
//         break;
//       case SubjectName.Conflict:
//         return 'Conflict';
//         break;
//       case SubjectName.Islamic:
//         return 'Islamic';
//         break;
//       default:
//         return 'Undeclared';
//     }
//   }

//   @override
//    Widget build(BuildContext context) {

//     CollectionReference _attendanceCollection = FirebaseFirestore.instance.collection('attendance');
//     CollectionReference _studentCollection =
//       FirebaseFirestore.instance.collection('students');
//     Future<List<Student>> getStudents() async {
//       var studentQuery = _studentCollection.where

//     }

//     final _classData = Provider.of<AllStudents>(context);

//     final _allStudentsaAtSource =
//         _classData.allInClass; //all students declared at source

//     final theCurrentClass = ModalRoute.of(context).settings.arguments
//         as SubjectClass; //the current class which contains list of all reg students

//     final _allStudents =
//         allRegStuds(_allStudentsaAtSource, theCurrentClass, _classData);



//     return Scaffold(
//       appBar: AppBar(
//         title: Text(enToString(theCurrentClass.subjectName),
//             style: Theme.of(context).textTheme.headline6),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           //mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           //mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             ListView.builder(
//               physics: const NeverScrollableScrollPhysics(), //allows scrolling
//               itemCount: _allStudents.length,
//               shrinkWrap: true,
//               itemBuilder: (ctx, i) =>
//                   buildAttTile(_allStudents[i], theCurrentClass, context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
