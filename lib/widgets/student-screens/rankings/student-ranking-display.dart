import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/ranking-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

// This needs to be the page where the students with the top score are displayed
class StudentRankingDisplay extends StatefulWidget {
  static const routeName = '/rankingDiplay';

  @override
  _StudentRankingDisplayState createState() => _StudentRankingDisplayState();
}

class _StudentRankingDisplayState extends State<StudentRankingDisplay> {
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
    final studData = Provider.of<StudentUser>(context);
    _filter = 'Year';
    _yearFilter = studData.year;
    _subYearFilter = studData.year;
    _subjectFilter = studData.subjects.last;
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

  // ElevatedButton _filterButtonYear({String text, String filterText}) {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //         backgroundColor: _yearFilter == text
  //             ? MaterialStateProperty.all(Color(0xffC54134))
  //             : MaterialStateProperty.all(Color(0xffDEE4ED)),
  //         shape: MaterialStateProperty.all(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
  //         )),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         fontFamily: 'Proxima Nova',
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: _yearFilter == text ? Colors.white : Colors.black,
  //       ),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _yearFilter = '$filterText';
  //       });
  //     },
  //   );
  // }

  // ElevatedButton _filterButtonSubYear({
  //   String text,
  //   String filterText,
  // }) {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //         backgroundColor: _subYearFilter == text
  //             ? MaterialStateProperty.all(Color(0xffC54134))
  //             : MaterialStateProperty.all(Color(0xffDEE4ED)),
  //         shape: MaterialStateProperty.all(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
  //         )),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         fontFamily: 'Proxima Nova',
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: _subYearFilter == text ? Colors.white : Colors.black,
  //       ),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _subYearFilter = '$filterText';
  //       });
  //     },
  //   );
  // }

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
    final studentUser = Provider.of<StudentUser>(context);
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
                          child: Column(
                            children: <Widget>[
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
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                  Container(
                    height: _filter == 'Subject'
                        ? MediaQuery.of(context).size.height * 0.64
                        : MediaQuery.of(context).size.height * 0.7,
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
                                onTap: () {},
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
                                          color: Theme.of(context).primaryColor,
                                          fontSize: i == 0 || i == 1 || i == 2
                                              ? 26
                                              : 20,
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: i == 0 || i == 1 || i == 2
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
                                                  students[i].imageUrl),
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
                                          fontSize: 18,
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Spacer(),
                                      if (students[i].id == studentUser.uid &&
                                          _filter == 'Year')
                                        Text(
                                          '${students[i].yearScore.toInt()}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffD6200F)),
                                        ),
                                      if (students[i].id == studentUser.uid &&
                                          _filter == 'Attendance')
                                        Text(
                                          '${students[i].attendanceScore.toInt()}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffD6200F)),
                                        ),
                                       if (students[i].id == studentUser.uid &&
                                          _filter == 'Assignments')
                                        Text(
                                          '${students[i].assignmentScore.toInt()}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffD6200F)),
                                        ),
                                      if (students[i].id == studentUser.uid &&
                                          _filter == 'Subject')
                                        Text(
                                          '${students[i].raSubScore['$_subjectFilter'].toInt()}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Proxima Nova',
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffD6200F)),
                                        ),
                                      SizedBox(
                                        width: 23,
                                      ),
                                    ],
                                  ),
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
        : LoadingScreen();
  }
}
