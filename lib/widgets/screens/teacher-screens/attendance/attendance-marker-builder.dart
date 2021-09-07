import 'package:flutter/material.dart';
import 'package:tils_app/models/attendance.dart';

import 'package:provider/provider.dart';

import 'package:tils_app/models/student.dart';

import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

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
  Map tileColor = {};
  Map<String, String> _attStat = {};

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
            setState(() {
              tileColor['$stud'] = status;
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

  Widget buildAttTile(String stud, String classId, BuildContext ctx,
      [int status, int tc]) {
    return ListTile(
      leading: Container(
        width: 150,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Text(
                stud,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Proxima Nova'),
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
      tileColor: statusColor(tc, ctx),
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
        return Theme.of(ctx).canvasColor;
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
          tileColor = sheet.attStat;
        }
      });
    } else {
      att = {};
      tileColor = {};
    }
    if (studentProvider != null) {
      streamActive = true;
    }

    return Scaffold(
      appBar: AppBar(),
      body: !streamActive
          ? LoadingScreen()
          : ListView.builder(
              itemCount: studentProvider.length,
              itemBuilder: (ctx, i) {
                int stat = 0;
                int tc = 0;
                //att is a map <student name, status>
                att.forEach((k, v) {
                  if (k == studentProvider[i].name) {
                    stat = v;
                  }
                });
                //tileColor is added so that color is not dependant upon a read of the db
                tileColor.forEach((k, v) {
                  if (k == studentProvider[i].name) {
                    tc = v;
                  }
                });
                return AttendanceMarkerTile(
                  classId: widget.classId,
                  name: studentProvider[i].name,
                  status: tc,
                );
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
    @required this.classId,
  }) : super(key: key);
  final String name;
  final String classId;
  final int status;

  @override
  _AttendanceMarkerTileState createState() => _AttendanceMarkerTileState();
}

class _AttendanceMarkerTileState extends State<AttendanceMarkerTile> {
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

  Color statusColor(int status, BuildContext ctx) {
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
        tileColor: statusColor(widget.status, context),
        title: Text('${widget.name}', style: TextStyle(fontSize: 18, fontFamily: 'Proxima Nova', fontWeight: FontWeight.w600),),
        trailing: Container(
          width: 180,
          child: Row(children: <Widget>[
            buildAttButton(
              widget.name,
              'P',
              widget.classId,
              1,
              Colors.green,
            ),
            buildAttButton(
              widget.name,
              'L',
              widget.classId,
              2,
              Colors.yellow,
            ),
            buildAttButton(
              widget.name,
              'A',
              widget.classId,
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