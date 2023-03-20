import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/service/ranking-service.dart';
import 'package:SIL_app/service/student-management-service.dart';
import 'package:SIL_app/service/student-service.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/manage-students/activate-parent-portal.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/manage-students/edit-student-subs.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({Key key}) : super(key: key);

  static const routeName = '/managementMain';

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  final ms = ManagementService();
  final db = DatabaseService();

  String _yearFilter;
  String _filter;
  String _subjectFilter;
  String _subYearFilter;

  Map<String, List<String>> yearSub = {
    '1': ['Contract', 'LSM', 'Criminal', 'Public'],
    '2': ['Tort', 'Property', 'HR', 'EU'],
    '3': ['Jurisprudence', 'Trust', 'Company', 'Conflict', 'Islamic']
  };

  @override
  void didChangeDependencies() {
    final teacherData = Provider.of<TeacherUser>(context);

    _filter = 'Year';
    _yearFilter = teacherData.year;
    _subYearFilter = '1';

    super.didChangeDependencies();
  }

//main filter button

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

  //sub filters

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

  Future<dynamic> showOptions(StudentRank stud) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setStateModal) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Text(
                      '${stud.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.people_outline_outlined,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ActivateParentPortal(stud)),
                            );
                          },
                          child: Text(
                            'Activate Parent Portal',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[800],
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.note_add_rounded,
                          size: 30,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => EditStudSubs(stud)));
                          },
                          child: Text(
                            'Change subjects or year',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[800],
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: ctx,
                                barrierDismissible: true,
                                builder: (BuildContext dialogCtx) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Are you sure you want to permanently delete this student?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Proxima Nova',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xffC54134)),
                                              ),
                                              onPressed: () {
                                                db.deleteStudent(stud.id);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Yes, Delete',
                                                style: TextStyle(
                                                  fontFamily: 'Proxima Nova',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xffffffff)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                  fontFamily: 'Proxima Nova',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'Delete Student',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[800],
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            );
          });
        });
  }

  Widget build(BuildContext context) {
    List<StudentRank> students = [];
    final studsFromdb = Provider.of<List<StudentRank>>(context);
    final assessments = Provider.of<List<RAfromDB>>(context);
    final teacherData = Provider.of<TeacherUser>(context);
    bool isActive = false;

    switch (_filter) {
      case 'Year':
        students = ms.getStudentsOfYear(_yearFilter, studsFromdb);
        break;
      case 'Subject':
        students = ms.getStudentsOfSub(_subjectFilter, studsFromdb);
        break;
      default:
        students = ms.getStudentsOfYear(_yearFilter, studsFromdb);
    }

    if (studsFromdb.isNotEmpty) {
      isActive = true;
      // print('active in manage students');
    }

    return isActive
        ? Scaffold(
            appBar: AppBar(
                title: Text(
              'Manage Students',
              style: TextStyle(
                color: Color(0xff4c4c4c),
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )),
            body: SingleChildScrollView(
                child: Column(
              children: [
                // SizedBox(
                //   height: 45,
                // ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    filterText: yearSub['$_subYearFilter'][x]),
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
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
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
                                  return showOptions(students[i]);
                                },
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (students[i].imageUrl != '')
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            students[i].imageUrl,
                                          ),
                                          radius: 20,
                                        )
                                      else
                                        Icon(
                                          Icons.person,
                                          size: 30,
                                        ),
                                      SizedBox(width: 11),
                                      Text(
                                        students[i].name,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  height: 40,
                  color: Theme.of(context).canvasColor,
                )
              ],
            )),
          )
        : LoadingScreen();
  }
}

///filter determines the year students displayed 