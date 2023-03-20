import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/ranking-service.dart';
import 'package:SIL_app/service/student-service.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';

// This needs to be the page where the students with the top score are displayed
class TeacherRankingDisplay extends StatefulWidget {
  static const routeName = '/rankingDiplay';

  @override
  _TeacherRankingDisplayState createState() => _TeacherRankingDisplayState();
}

class _TeacherRankingDisplayState extends State<TeacherRankingDisplay> {
  final rs = RankingService();
  final ss = StudentService();
  String _filter;
  String _yearFilter;
  String _subYearFilter;
  Map<String, List<String>> yearSub = {
    '1': ['Contract', 'LSM', 'Criminal', 'Public'],
    '2': ['Tort', 'Property', 'HR', 'EU'],
    '3': ['Jurisprudence', 'Trust', 'Company', 'Conflict', 'Islamic']
  };
  String _subjectFilter;

  @override
  void didChangeDependencies() {
    final teacherData = Provider.of<TeacherUser>(context);
    _filter = 'Year';
    _yearFilter = teacherData.year;
    _subYearFilter = teacherData.year;
    _subjectFilter = teacherData.subjects.last;
    super.didChangeDependencies();
  }

  Widget _filterButtonFirst({String text, String filterText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: _filter == text
                ? MaterialStateProperty.all(Color(0xffC54134))
                : MaterialStateProperty.all(Color(0xffDEE4ED)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            )),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Proxima Nova',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _filter == text ? Colors.white : Colors.black,
          ),
        ),
        onPressed: () {
          setState(() {
            _filter = '$filterText';
          });
        },
      ),
    );
  }

  Widget _filterButtonFirstWeb({String text, String filterText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: _filter == text
                ? MaterialStateProperty.all(Color(0xffC54134))
                : MaterialStateProperty.all(Color(0xffDEE4ED)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            )),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Proxima Nova',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _filter == text ? Colors.white : Colors.black,
          ),
        ),
        onPressed: () {
          setState(() {
            _filter = '$filterText';
          });
        },
      ),
    );
  }

  ElevatedButton _filterButtonYear({String text, String filterText}) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: _yearFilter == text
              ? MaterialStateProperty.all(Color(0xffC54134))
              : MaterialStateProperty.all(Color(0xffDEE4ED)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          )),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Proxima Nova',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _yearFilter == text ? Colors.white : Colors.black,
        ),
      ),
      onPressed: () {
        setState(() {
          _yearFilter = '$filterText';
        });
      },
    );
  }

  ElevatedButton _filterButtonSubYear({
    String text,
    String filterText,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: _subYearFilter == text
              ? MaterialStateProperty.all(Color(0xffC54134))
              : MaterialStateProperty.all(Color(0xffDEE4ED)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          )),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Proxima Nova',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _subYearFilter == text ? Colors.white : Colors.black,
        ),
      ),
      onPressed: () {
        setState(() {
          _subYearFilter = '$filterText';
        });
      },
    );
  }

  Widget _filterButtonSubject({
    String text,
    String filterText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: _subjectFilter == text
                ? MaterialStateProperty.all(Color(0xffC54134))
                : MaterialStateProperty.all(Color(0xffDEE4ED)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            )),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Proxima Nova',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _subjectFilter == text ? Colors.white : Colors.black,
          ),
        ),
        onPressed: () {
          setState(() {
            _subjectFilter = '$filterText';
          });
        },
      ),
    );
  }

  Future<dynamic> showStudentDetail(StudentRank stud, TeacherUser tdata) {
    int present = rs.presents(stud.attendance);
    int late = rs.lates(stud.attendance);
    int absent = rs.absents(stud.attendance);
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 600,
                      child: Column(children: <Widget>[
                        Row(
                        children: <Widget>[
                          Text(
                            'Attendance Percentage',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '(',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
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
                          Text(
                            ')   ',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${rs.attendancePercentage(stud)}% ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Total Score (Year)',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${stud.yearScore.toInt()} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Assignment Score',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${stud.assignmentScore.toInt()} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      for (var x = 0; x < stud.subjects.length; x++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${stud.subjects[x]}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              Text(
                                stud.raSubScore['${stud.subjects[x]}'] == null
                                    ? '0'
                                    : '${stud.raSubScore['${stud.subjects[x]}']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 35,
                      ),
                      ],),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    List<StudentRank> students = [];

    final studsFromdb = Provider.of<List<StudentRank>>(context);
    final assessments = Provider.of<List<RAfromDB>>(context);
    final teacherData = Provider.of<TeacherUser>(context);

    if (studsFromdb != null && assessments != null) {
      isActive = true;
      switch (_filter) {
        case 'Year':
          students = rs.getStudentYearScore(
            _yearFilter,
            studsFromdb,
          );
          break;
        case 'Attendance':
          students = rs.getStudentAttendanceScore(studsFromdb);
          break;
        case 'Subject':
          students = rs.getStudentBySub(
            _subjectFilter,
            studsFromdb,
          );
          break;
        case 'Assignments':
          students = rs.getStudentAssignmentScore(studsFromdb);
          break;
        default:
          students = rs.getStudentYearScore(_yearFilter, studsFromdb);
      }
    }

    return !isActive
        ? LoadingScreen()
        : defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android
            ? Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Theme.of(context).canvasColor,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  _filterButtonFirst(
                                    filterText: 'Year',
                                    text: 'Year',
                                  ),
                                  _filterButtonFirst(
                                    filterText: 'Attendance',
                                    text: 'Attendance',
                                  ),
                                  _filterButtonFirst(
                                    filterText: 'Assignments',
                                    text: 'Assignments',
                                  ),
                                  _filterButtonFirst(
                                    filterText: 'Subject',
                                    text: 'Subject',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_filter == 'Subject')
                            Container(
                              color: Theme.of(context).canvasColor,
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _filterButtonSubYear(
                                        text: '1',
                                        filterText: '1',
                                      ),
                                      _filterButtonSubYear(
                                        text: '2',
                                        filterText: '2',
                                      ),
                                      _filterButtonSubYear(
                                        text: '3',
                                        filterText: '3',
                                      ),
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        for (var x = 0;
                                            x <
                                                yearSub['$_subYearFilter']
                                                    .length;
                                            x++)
                                          _filterButtonSubject(
                                              text: yearSub['$_subYearFilter']
                                                  [x],
                                              filterText:
                                                  yearSub['$_subYearFilter']
                                                      [x]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (_filter == 'Year')
                            Container(
                              color: Theme.of(context).canvasColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _filterButtonYear(
                                    text: '1',
                                    filterText: '1',
                                  ),
                                  _filterButtonYear(
                                    text: '2',
                                    filterText: '2',
                                  ),
                                  _filterButtonYear(
                                    text: '3',
                                    filterText: '3',
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                      ),
                      Container(
                        height:
                            _filter == 'Assignments' || _filter == 'Attendance'
                                ? MediaQuery.of(context).size.height * 0.70
                                : MediaQuery.of(context).size.height * 0.62,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showStudentDetail(
                                            students[i], teacherData);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      height: i == 0
                                          ? 130
                                          : i == 1 || i == 2
                                              ? 80
                                              : 60,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            '${students[i].position}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  i == 0 || i == 1 || i == 2
                                                      ? 26
                                                      : 20,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight:
                                                  i == 0 || i == 1 || i == 2
                                                      ? FontWeight.w700
                                                      : FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 22,
                                          ),
                                          if (students[i].imageUrl != '')
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                students[i].imageUrl,
                                              ),
                                              radius: i == 0 || i == 1 || i == 2
                                                  ? 25
                                                  : 15,
                                            )
                                          else
                                            Icon(
                                              Icons.person,
                                              size: i == 0 || i == 1 || i == 2
                                                  ? 50
                                                  : 30,
                                            ),
                                          SizedBox(width: 11),
                                          Text(
                                            '${students[i].name}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Spacer(),
                                          if (_filter == 'Year')
                                            Text(
                                              '${students[i].yearScore.toInt()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Proxima Nova',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xffD6200F)
                                                  //Color(0xffCC2010),
                                                  //Color(0xff96190E),
                                                  ),
                                            ),
                                          if (_filter == 'Assignments')
                                            Text(
                                              '${students[i].assignmentScore.toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          if (_filter == 'Subject')
                                            Text(
                                              '${students[i].raSubScore['$_subjectFilter'].toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          if (_filter == 'Attendance')
                                            Text(
                                              '${students[i].attendanceScore.toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          SizedBox(
                                            width: 23,
                                          ),
                                        ],
                                      ),
                                      //trailing: Text('${students[i].attendancePosition}'),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        color: Theme.of(context).canvasColor,
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Theme.of(context).canvasColor,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  _filterButtonFirstWeb(
                                    filterText: 'Year',
                                    text: 'Year',
                                  ),
                                  _filterButtonFirstWeb(
                                    filterText: 'Attendance',
                                    text: 'Attendance',
                                  ),
                                  _filterButtonFirstWeb(
                                    filterText: 'Assignments',
                                    text: 'Assignments',
                                  ),
                                  _filterButtonFirstWeb(
                                    filterText: 'Subject',
                                    text: 'Subject',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (_filter == 'Subject')
                            Container(
                              color: Theme.of(context).canvasColor,
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _filterButtonSubYear(
                                        text: '1',
                                        filterText: '1',
                                      ),
                                      _filterButtonSubYear(
                                        text: '2',
                                        filterText: '2',
                                      ),
                                      _filterButtonSubYear(
                                        text: '3',
                                        filterText: '3',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        for (var x = 0;
                                            x <
                                                yearSub['$_subYearFilter']
                                                    .length;
                                            x++)
                                          _filterButtonSubject(
                                              text: yearSub['$_subYearFilter']
                                                  [x],
                                              filterText:
                                                  yearSub['$_subYearFilter']
                                                      [x]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (_filter == 'Year')
                            Container(
                              color: Theme.of(context).canvasColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _filterButtonYear(
                                    text: '1',
                                    filterText: '1',
                                  ),
                                  _filterButtonYear(
                                    text: '2',
                                    filterText: '2',
                                  ),
                                  _filterButtonYear(
                                    text: '3',
                                    filterText: '3',
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                      ),
                      Container(
                        width: 600,
                        height:
                            _filter == 'Assignments' || _filter == 'Attendance'
                                ? MediaQuery.of(context).size.height * 0.70
                                : MediaQuery.of(context).size.height * 0.62,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showStudentDetail(
                                            students[i], teacherData);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      height: i == 0
                                          ? 130
                                          : i == 1 || i == 2
                                              ? 80
                                              : 60,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            '${students[i].position}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  i == 0 || i == 1 || i == 2
                                                      ? 26
                                                      : 20,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight:
                                                  i == 0 || i == 1 || i == 2
                                                      ? FontWeight.w700
                                                      : FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 22,
                                          ),
                                          if (students[i].imageUrl != '')
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                students[i].imageUrl,
                                              ),
                                              radius: i == 0 || i == 1 || i == 2
                                                  ? 25
                                                  : 15,
                                            )
                                          else
                                            Icon(
                                              Icons.person,
                                              size: i == 0 || i == 1 || i == 2
                                                  ? 50
                                                  : 30,
                                            ),
                                          SizedBox(width: 11),
                                          Text(
                                            '${students[i].name}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Spacer(),
                                          if (_filter == 'Year')
                                            Text(
                                              '${students[i].yearScore.toInt()}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'Proxima Nova',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xffD6200F)
                                                  //Color(0xffCC2010),
                                                  //Color(0xff96190E),
                                                  ),
                                            ),
                                          if (_filter == 'Assignments')
                                            Text(
                                              '${students[i].assignmentScore.toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          if (_filter == 'Subject')
                                            Text(
                                              '${students[i].raSubScore['$_subjectFilter'].toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          if (_filter == 'Attendance')
                                            Text(
                                              '${students[i].attendanceScore.toInt()}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Proxima Nova',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xffD6200F),
                                              ),
                                            ),
                                          SizedBox(
                                            width: 23,
                                          ),
                                        ],
                                      ),
                                      //trailing: Text('${students[i].attendancePosition}'),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        color: Theme.of(context).canvasColor,
                      )
                    ],
                  ),
                ),
              );
  }
}
