import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/service/student-service.dart';

class StudentAttendanceRecord extends StatefulWidget {
  @override
  _StudentAttendanceRecordState createState() =>
      _StudentAttendanceRecordState();
}

class _StudentAttendanceRecordState extends State<StudentAttendanceRecord> {
  final ss = StudentService();
  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentUser>(context);
    final classes = Provider.of<List<SubjectClass>>(context);
    List<SubjectClass> marked =
        ss.getMarkedClasses(classes, studData.attendance);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: marked.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return ListTile(
                    subtitle: Text(
                        '${DateFormat('EEE, MMM d').format(marked[i].startTime)}'),
                    title: marked[i].topic == ''
                        ? Text(
                            '${marked[i].subjectName}',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2b3443),
                            ),
                          )
                        : Text(
                            '${marked[i].subjectName} (${marked[i].topic})',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2b3443),
                            ),
                          ),
                    trailing: studData.attendance['${marked[i].id}'] == 1
                        ? Text(
                            'Present',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[600],
                            ),
                          )
                        : studData.attendance['${marked[i].id}'] == 2
                            ? Text(
                                'Late',
                                style: TextStyle(
                                  fontFamily: 'Proxima Nova',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow[900],
                                ),
                              )
                            : Text(
                                'Absent',
                                style: TextStyle(
                                  fontFamily: 'Proxima Nova',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800],
                                ),
                              ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
