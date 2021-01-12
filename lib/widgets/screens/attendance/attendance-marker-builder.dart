
import 'package:flutter/material.dart';
import 'package:tils_app/models/attendance.dart';

import 'package:provider/provider.dart';

import 'package:tils_app/providers/all_classes.dart';
import 'package:tils_app/models/student.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/db.dart';

class AttendanceMarkerBuilder extends StatefulWidget {
  static const routeName = '/marker-builder';
  // final List<Student> allStuds;
  final String classId;
  AttendanceMarkerBuilder(this.classId);
  @override
  _AttendanceMarkerBuilderState createState() =>
      _AttendanceMarkerBuilderState();
}

class _AttendanceMarkerBuilderState extends State<AttendanceMarkerBuilder> {
  final db = DatabaseService();

  Widget buildAttButton(
    String stud,
    String buttonText,
    String id,
    int status,
    MaterialColor color,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            db.addAttToCF(stud, status, id);
          },
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
        ),
      ),
    );
  }

  Widget buildAttTile(String stud, String classId, BuildContext ctx,
      [int status]) {
    return ListTile(
      leading: Container(
        width: 150,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Text(
                stud,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        width: 180,
        child: Row(children: <Widget>[
          buildAttButton(
            stud,
            'P',
            classId,
            1,
            Colors.green,
          ),
          buildAttButton(
            stud,
            'L',
            classId,
            2,
            Colors.yellow,
          ),
          buildAttButton(
            stud,
            'A',
            classId,
            3,
            Colors.red,
          ),
        ]),
      ),
      tileColor: statusColor(status, ctx),
    );
  }

  Widget buildTestTile(Student stud) {
    return ListTile(
      title: Text(stud.name),
    );
  }

  Color statusColor(int status, BuildContext ctx) {
    switch (status) {
      case 1:
        return Colors.green;
        break;
      case 3:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Theme.of(ctx).backgroundColor;
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
      default:
        return 'Undeclared';
    }
  }

  @override
  Widget build(BuildContext context) {
    Map att = {};
    bool streamActive = false;
    final studentProvider = Provider.of<List<Student>>(context);
    final attendanceProvider = Provider.of<List<Attendance>>(context);
    if (attendanceProvider != null) {
      attendanceProvider.forEach((sheet) {
        if (widget.classId == sheet.id) {
          att = sheet.attStat;
        }
      });
    } else {
      att = {};
    }
    if (studentProvider != null) {
      streamActive = true;
    }

    return Scaffold(
      body: !streamActive
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: studentProvider.length,
              itemBuilder: (ctx, i) {
                int stat = 0;
                att.forEach((k, v) {
                  if (k == studentProvider[i].name) {
                    stat = v;
                  }
                });
                return buildAttTile(
                    studentProvider[i].name, widget.classId, context, stat);
              },
            ),
    );
  }
}
