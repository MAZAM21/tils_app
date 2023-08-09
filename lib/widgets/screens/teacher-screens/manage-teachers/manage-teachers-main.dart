import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/models/instititutemd.dart';

// import 'package:tils_app/models/remote_assessment.dart';

import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/models/teachers-all.dart';
import 'package:tils_app/service/db.dart';

import 'package:tils_app/service/student-management-service.dart';

import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/manage-teachers/edit-teacher-subs.dart';

class ManageTeachers extends StatefulWidget {
  final Map<String, dynamic> yearSubfromDb;
  ManageTeachers(this.yearSubfromDb);

  static const routeName = '/management-teachers';

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  final ms = ManagementService();

  String? _yearFilter;
  String? _filter;
  String? _subjectFilter;
  String? _subYearFilter;

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
    _subYearFilter = teacherData.year;

    super.didChangeDependencies();
  }

//main filter button

  Widget _filterButtonFirst({required String text, String? filterText}) {
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

  ElevatedButton _filterButtonYear({required String text, String? filterText}) {
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
    required String text,
    String? filterText,
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
    required String text,
    String? filterText,
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

  Future<dynamic> showOptions(
      AllTeachers teacher, db, InstituteData? instData) {
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
                      '${teacher.name}',
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
                                    builder: (ctx) =>
                                        EditTeacherSubs(teacher, instData)));
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
                  ]),
                ),
              ),
            );
          });
        });
  }

  Widget build(BuildContext context) {
    List<AllTeachers> teachers = [];
    final allTeachers = Provider.of<List<AllTeachers>>(context);
    // final assessments = Provider.of<List<RAfromDB>>(context);
    // final teacherData = Provider.of<TeacherUser>(context);
    final instData = Provider.of<InstituteData?>(context);
    final db = Provider.of<DatabaseService>(context, listen: false);
    bool isActive = false;

    switch (_filter) {
      case 'Year':
        teachers = ms.getTeachersOfYear(_yearFilter, allTeachers);
        break;
      case 'Subject':
        teachers = ms.getTeachersOfSub(_subjectFilter, allTeachers);
        break;
      default:
        teachers = ms.getTeachersOfYear(_yearFilter, allTeachers);
    }

    if (allTeachers.isNotEmpty && instData != null) {
      isActive = true;
      // print('active in manage teachers');
    }

    return isActive
        ? Scaffold(
            appBar: AppBar(
                title: Text(
              'Manage teachers',
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
                            for (var x = 0;
                                x < widget.yearSubfromDb.keys.length;
                                x++)
                              _filterButtonSubYear(
                                text: widget.yearSubfromDb.keys.toList()[x],
                                filterText:
                                    widget.yearSubfromDb.keys.toList()[x],
                              ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (var x = 0;
                                  x <
                                      widget.yearSubfromDb['$_subYearFilter']!
                                          .length;
                                  x++)
                                _filterButtonSubject(
                                    text: widget
                                        .yearSubfromDb['$_subYearFilter']![x],
                                    filterText: widget
                                        .yearSubfromDb['$_subYearFilter']![x]),
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
                        for (var x = 0;
                            x < widget.yearSubfromDb.keys.length;
                            x++)
                          _filterButtonYear(
                            text: widget.yearSubfromDb.keys.toList()[x],
                            filterText: widget.yearSubfromDb.keys.toList()[x],
                          ),
                      ],
                    ),
                  ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: teachers.length,
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
                                  showOptions(teachers[i], db, instData);
                                },
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                      ),
                                      SizedBox(width: 11),
                                      Text(
                                        teachers[i].name!,
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

///filter determines the year teachers displayed 