import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/ranking-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

// This needs to be the page where the students with the top score are displayed
class TeacherRankingDisplay extends StatefulWidget {
  static const routeName = '/rankingDiplay';

  @override
  _TeacherRankingDisplayState createState() => _TeacherRankingDisplayState();
}

class _TeacherRankingDisplayState extends State<TeacherRankingDisplay> {
  final rs = RankingService();
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

  ElevatedButton _filterButtonFirst({String text, String filterText}) {
    return ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    List<StudentRank> students = [];

    final studsFromdb = Provider.of<List<StudentRank>>(context);
    final assessments = Provider.of<List<RAfromDB>>(context);

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

    return isActive == true
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        x < yearSub['$_subYearFilter'].length;
                                        x++)
                                      _filterButtonSubject(
                                          text: yearSub['$_subYearFilter'][x],
                                          filterText: yearSub['$_subYearFilter']
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    height: _filter == 'Assignments' || _filter == 'Attendance'
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
                              child: Container(
                                color: Colors.white,
                                height: 60,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '${students[i].position}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 22,
                                    ),
                                    if (students[i].imageUrl != '')
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(students[i].imageUrl),
                                        radius: 25,
                                      )
                                    else
                                      Icon(
                                        Icons.person,
                                        size: 50,
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
                                  ],
                                ),
                                //trailing: Text('${students[i].attendancePosition}'),
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
        : LoadingScreen();
  }
}
