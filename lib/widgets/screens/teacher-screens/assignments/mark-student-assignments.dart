import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:provider/provider.dart';

class MarkStudentAssignments extends StatefulWidget {
  MarkStudentAssignments({
    @required this.students,
    @required this.subject,
    @required this.title,
    this.editAM,
  });

  final List<StudentRank> students;
  final String subject;
  final String title;
  final AMfromDB editAM;

  @override
  _MarkStudentAssignmentsState createState() => _MarkStudentAssignmentsState();
}

class _MarkStudentAssignmentsState extends State<MarkStudentAssignments> {
  ///This is where the sliders are generated
  final ts = TeacherService();
  final db = DatabaseService();
  Map<String, int> stMark = {};
  Map<String, int> idMark = {};

  @override
  void didChangeDependencies() {
    if (widget.editAM != null) {
      if (widget.editAM.nameMarks.isNotEmpty &&
          widget.editAM.uidMarks.isNotEmpty) {
        stMark = widget.editAM.nameMarks;
        idMark = widget.editAM.uidMarks;
      }
    }
    super.didChangeDependencies();
  }

  void marksFromSliders(String name, double mark, String uid) {
    stMark.addAll({name: mark.toInt()});
    idMark.addAll({uid: mark.toInt()});
    //print('$name: ${stMark[name]}');
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = false;
    if (widget.editAM != null) {
      isEditing = true;
    }
    var assignmentMarks;
    double totalMark;
    String title;

    ///if dbID is null then a new assignment is being created
    if (!isEditing) {
      assignmentMarks = Provider.of<AssignmentMarks>(context);
      title = assignmentMarks.title;
      if (assignmentMarks.totalMarks != null) {
        totalMark = assignmentMarks.totalMarks.toDouble() ?? 100;
      }
    } else {
      title = widget.editAM.title;
      totalMark = widget.editAM.totalMarks.toDouble() ?? 100;
    }

    final td = Provider.of<TeacherUser>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                /// if is not editing new assignment marks doc is created
                if (!isEditing) {
                  assignmentMarks.marks = stMark;
                  assignmentMarks.uidMarks = idMark;
                  assignmentMarks.subject = widget.subject;
                  assignmentMarks.teacherId = td.uid;
                  assignmentMarks.teacherName = td.name;
                  db.addAssignmentToCF(assignmentMarks, null);

                  ///if is editing then previously added are updated
                  /// a cheeky corner cut here by passing a totally new AMfromDB object since
                  /// the widget one is final and cannot be updated.
                  /// works like a charm
                  /// I'm happy.
                } else if (isEditing) {
                  db.addAssignmentToCF(
                      null,
                      AMfromDB(
                          docId: widget.editAM.docId,
                          nameMarks: stMark,
                          uidMarks: idMark,
                          subject: widget.editAM.subject));
                }
                Navigator.popUntil(
                    context, (ModalRoute.withName('/assignment-main')));
              },
              icon: Icon(
                Icons.save,
                color: Colors.red,
              ))
        ],
        title: Text(
          'Mark Students',
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(110),
              child: Container(
                // color: Color.fromARGB(20, 76, 76, 76),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    '$title',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Proxima Nova',
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            for (int i = 0; i < widget.students.length; i++)
              AssignmentSlider(
                studName: widget.students[i].name,
                getMarks: marksFromSliders,
                uid: widget.students[i].id,
                url: widget.students[i].imageUrl,
                totalMark: totalMark,
                isEditing: isEditing,
                subName: isEditing ? widget.editAM.subject : '',
                asgId: isEditing ? widget.editAM.docId : '',
                initVal: isEditing &&
                        widget.editAM.uidMarks['${widget.students[i].id}'] !=
                            null
                    ? widget.editAM.uidMarks['${widget.students[i].id}']
                        .toDouble()
                    : 0.0,
              ),
          ],
        ),
      ),
    );
  }
}

class AssignmentSlider extends StatefulWidget {
  const AssignmentSlider({
    @required this.isEditing,
    @required this.studName,
    @required this.getMarks,
    @required this.uid,
    this.url,
    this.totalMark,
    this.initVal,
    this.asgId,
    this.subName,
  });
  final String studName;
  final String url;
  final double totalMark;
  final String uid;
  final double initVal;
  final bool isEditing;
  final void Function(String name, double mark, String uid) getMarks;
  final String asgId;
  final String subName;

  @override
  _AssignmentSliderState createState() => _AssignmentSliderState();
}

class _AssignmentSliderState extends State<AssignmentSlider> {
  final db = DatabaseService();

  /// individual slider element
  double _sliderVal;
  @override
  void initState() {
    if (widget.initVal != 0) {
      _sliderVal = widget.initVal;
    } else {
      _sliderVal = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.url);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                if (widget.url.isNotEmpty)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('${widget.url}'),
                  ),
                Spacer(),
                Text(
                  '${widget.studName}',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Proxima Nova',
                      color: Color.fromARGB(255, 76, 76, 76),
                      fontWeight: FontWeight.w600),
                ),
                if (widget.url.isNotEmpty)
                  SizedBox(
                    width: 60,
                  ),
                Spacer(),
              ],
            ),
            Container(
              child: SfSlider(
                interval: 10,
                stepSize: 1.0,
                showLabels: true,
                min: 0.0,
                max: widget.totalMark,
                value: _sliderVal,
                enableTooltip: true,
                onChanged: (dynamic val) {
                  setState(() {
                    _sliderVal = val;
                    widget.getMarks(widget.studName, val, widget.uid);
                  });
                  // print(mark);
                },
              ),
            ),
            if (widget.isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        db.deleteAssignment(widget.uid, widget.asgId,
                            widget.studName, widget.subName);
                        setState(() {
                          _sliderVal = 0;
                        });
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red[900],
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// For editing I will need:
/// db id
/// plus all the data
