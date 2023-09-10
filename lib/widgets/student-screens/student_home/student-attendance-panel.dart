import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/service/student-service.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:SIL_app/widgets/student-screens/attendance-record/student-attendance-record.dart';

class StudentAttendancePanel extends StatelessWidget {
  StudentAttendancePanel({
    Key? key,
    required this.studData,
  }) : super(key: key);

  final StudentUser studData;
  final ss = StudentService();

  @override
  Widget build(BuildContext context) {
    final classList = Provider.of<List<SubjectClass>>(context);
    late List<SubjectClass> topThree;
    int? perc;
    int? present;
    int? late;
    int? absent;
    bool isActive = false;
    topThree = ss.getTopThreeAtt(classList, studData);
    perc = ss.attendancePercentage(studData);
    present = ss.presents(studData.attendance);
    late = ss.lates(studData.attendance);
    absent = ss.absents(studData.attendance);
    isActive = true;
    return !isActive
        ? LoadingScreen()
        : defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS
            ? Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: RouteSettings(
                                    name: '/student-attendance-record'),
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: studData,
                                  child: StudentAttendanceRecord(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          '($perc%)',
                          style: TextStyle(
                            color: Color(0xff5f686f),
                            fontFamily: 'Proxima Nova',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$present  ',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600],
                          ),
                        ),
                        Text(
                          '$late  ',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.yellow[900],
                          ),
                        ),
                        Text(
                          '$absent',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[800],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topThree.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              tileColor: Colors.white,
                              trailing: studData
                                          .attendance['${topThree[i].id}'] ==
                                      1
                                  ? Text(
                                      'Present',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[600],
                                      ),
                                    )
                                  : studData.attendance['${topThree[i].id}'] ==
                                          2
                                      ? Text(
                                          'Late',
                                          style: TextStyle(
                                            fontFamily: 'Proxima Nova',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow[900],
                                          ),
                                        )
                                      : studData.attendance[
                                                  '${topThree[i].id}'] ==
                                              3
                                          ? Text(
                                              'Absent',
                                              style: TextStyle(
                                                fontFamily: 'Proxima Nova',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[800],
                                              ),
                                            )
                                          : null,
                              title: topThree[i].topic == ''
                                  ? Text(
                                      '${topThree[i].subjectName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    )
                                  : Text(
                                      '${topThree[i].subjectName} ${topThree[i].topic}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                              subtitle: Text(
                                '${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].startTime!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Proxima Nova',
                                  color: Color(0xff5F686F),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            :
            //WEB
            Container(
                width: 400,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: RouteSettings(
                                    name: '/student-attendance-record'),
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: studData,
                                  child: StudentAttendanceRecord(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          '($perc%)',
                          style: TextStyle(
                            color: Color(0xff5f686f),
                            fontFamily: 'Proxima Nova',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$present  ',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[600],
                          ),
                        ),
                        Text(
                          '$late  ',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.yellow[900],
                          ),
                        ),
                        Text(
                          '$absent',
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[800],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topThree.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              tileColor: Colors.white,
                              trailing: studData
                                          .attendance['${topThree[i].id}'] ==
                                      1
                                  ? Text(
                                      'Present',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[600],
                                      ),
                                    )
                                  : studData.attendance['${topThree[i].id}'] ==
                                          2
                                      ? Text(
                                          'Late',
                                          style: TextStyle(
                                            fontFamily: 'Proxima Nova',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow[900],
                                          ),
                                        )
                                      : studData.attendance[
                                                  '${topThree[i].id}'] ==
                                              3
                                          ? Text(
                                              'Absent',
                                              style: TextStyle(
                                                fontFamily: 'Proxima Nova',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[800],
                                              ),
                                            )
                                          : null,
                              title: topThree[i].topic == ''
                                  ? Text(
                                      '${topThree[i].subjectName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  : Text(
                                      '${topThree[i].subjectName} ${topThree[i].topic}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                              subtitle: Text(
                                '${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].startTime!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Proxima Nova',
                                  color: Color(0xff5F686F),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}
