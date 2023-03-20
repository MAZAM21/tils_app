import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SIL_app/models/attendance.dart';

import 'package:provider/provider.dart';

import 'package:SIL_app/models/student.dart';
import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/models/subject-class.dart';

import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/service/teachers-service.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';

class AttendanceMarkerBuilder extends StatefulWidget {
  static const routeName = '/marker-builder';
  // final List<Student> allStuds;

  @override
  _AttendanceMarkerBuilderState createState() =>
      _AttendanceMarkerBuilderState();
}

class _AttendanceMarkerBuilderState extends State<AttendanceMarkerBuilder> {
  final db = DatabaseService();
  final ts = TeacherService();
  var attInput = AttendanceInput();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var subClass = ModalRoute.of(context).settings.arguments as SubjectClass;

    if (subClass.attStat.isNotEmpty) {
      attInput.attendanceStatus = {...subClass.attStat};
    } else {
      attInput.attendanceStatus = {};
    }
    super.didChangeDependencies();
  }

  void addAttStat(String studId, int stat) {
    attInput.attendanceStatus.addAll({studId: stat});
  }

  Color statusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green[300];
        break;
      case 3:
        return Colors.red[300];
        break;
      case 2:
        return Colors.yellow[300];
        break;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<List<StudentRank>>(context);

    final subClass = ModalRoute.of(context).settings.arguments as SubjectClass;

    String notification =
        DateFormat("EEE, dd-MM hh:mm a").format(DateTime.now());
    attInput.classID = subClass.id;
    attInput.subject = subClass.subjectName;
    attInput.date = notification;

    ///Students registered for this subject and section
    List<StudentRank> clsStuds = [];

    bool streamActive = false;
    if (students != null) {
      clsStuds = ts.getStudentsOfSubandSection(
          students, subClass.subjectName, subClass.section);

      streamActive = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          //save button
          TextButton(
              onPressed: () {
                db.addAttendanceRecord(attInput, clsStuds);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ))
        ],
      ),
      body: !streamActive
          ? LoadingScreen()
          : ListView.builder(
              itemCount: clsStuds.length,
              itemBuilder: (ctx, i) {
                return AttendanceMarkerTile(
                    name: clsStuds[i].name,
                    status:
                        attInput.attendanceStatus['${clsStuds[i].id}'] == null
                            ? 0
                            : attInput.attendanceStatus['${clsStuds[i].id}'],
                    studId: clsStuds[i].id,
                    addStat: addAttStat,
                    col: statusColor(
                        attInput.attendanceStatus['${clsStuds[i].id}']));
              },
            ),
    );
  }
}

class AttendanceMarkerTile extends StatefulWidget {
  const AttendanceMarkerTile({
    Key key,
    @required this.name,
    @required this.status,
    @required this.studId,
    @required this.addStat,
    @required this.col,
  }) : super(key: key);
  final String name;
  final String studId;
  final int status;
  final Function addStat;
  final Color col;

  @override
  _AttendanceMarkerTileState createState() => _AttendanceMarkerTileState();
}

class _AttendanceMarkerTileState extends State<AttendanceMarkerTile> {
  int colr;
  @override
  void initState() {
    colr = widget.status;
    super.initState();
  }

  final db = DatabaseService();
  Widget buildAttButton(
    String studName,
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
            setState(() {
              widget.addStat(id, status);
              colr = status;
            });
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

  Color statusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green[300];
        break;
      case 3:
        return Colors.red[300];
        break;
      case 2:
        return Colors.yellow[300];
        break;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: statusColor(colr),
        title: Text(
          '${widget.name}',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Proxima Nova',
              fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          width: 180,
          child: Row(children: <Widget>[
            buildAttButton(
              widget.name,
              'P',
              widget.studId,
              1,
              Colors.green,
            ),
            buildAttButton(
              widget.name,
              'L',
              widget.studId,
              2,
              Colors.yellow,
            ),
            buildAttButton(
              widget.name,
              'A',
              widget.studId,
              3,
              Colors.red,
            ),
          ]),
        ),
      ),
    );
  }
}

///TODO:
///first, build the marker tile widget
///then create the global map used to track all of the marked stats
///key is id val is stat
///save button
///change db functions
