import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/teacher-user-data.dart';

import 'package:provider/provider.dart';
import 'package:SIL_app/service/teachers-service.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/mark-TextQs/all-textQs.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/edit-ra.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/select-assessment-subject.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/results/result-main.dart';

class TeacherAssessmentPanel extends StatelessWidget {
  final ts = TeacherService();
  TeacherAssessmentPanel({
    Key? key,
    required this.teacherData,
  }) : super(key: key);

  final TeacherUser? teacherData;

  @override
  Widget build(BuildContext context) {
    // final raList = Provider.of<List<RAfromDB>>(context);
    final raList = DummyAssessments().dummyData;
    int totalNumRA = raList.length;
    List<RAfromDB> topThree = [];

    if (raList.isNotEmpty) {
      topThree = ts.getTopThree(raList, teacherData);
      print(topThree.length);
    }

    return defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (teacherData!.subjects.length > 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/select-subects-ra'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: SelectAssessmentSubject(
                                  subjects: teacherData!.subjects,
                                  tc: teacherData),
                            ),
                          ),
                        );
                      } else if (teacherData!.subjects.length == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/all-Ras'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: AllRAs(
                                subject: teacherData!.subjects[0],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Assessements',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    '($totalNumRA)',
                    style: TextStyle(
                      color: Color(0xff5f686f),
                      fontFamily: 'Proxima Nova',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),

                  ///TODO
                  ///add navigator to add assessments
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider.value(
                            value: teacherData,
                            child: RASubject(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline_rounded),
                    color: Color(0xffC54134),
                    iconSize: 20,
                  ),
                ],
              ),
              Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topThree.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    String? dStat = ts.getdeadlineStatus(topThree[i]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        tileColor: Colors.white,
                        title: Text(
                          '${topThree[i].assessmentTitle}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        subtitle: Text(
                          'Deadline: ${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].endTime!)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            color: Color(0xff5F686F),
                          ),
                        ),
                        trailing: Text(
                          '$dStat',
                          style: TextStyle(
                            color: Color(0xffC54134),
                            fontFamily: 'Proxima Nova',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: EditRA(topThree[i]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xffC54134)),
                          minimumSize: MaterialStateProperty.all(Size(107, 25)),
                          fixedSize: MaterialStateProperty.all(Size(145, 27)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23)),
                          )),
                      onPressed: () {
                        ///if there are more than one subjects reg with teacher
                        ///subject selector will open
                        ///else it will go directly to the teacher's one subject assessment list
                        if (teacherData!.subjects.length > 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings:
                                  RouteSettings(name: '/select-subects-ra'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: SelectAssessmentSubject(
                                    subjects: teacherData!.subjects,
                                    tc: teacherData),
                              ),
                            ),
                          );
                        } else if (teacherData!.subjects.length == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/all-Ras'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: AllRAs(
                                  subject: teacherData!.subjects[0],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Deploy Assessments',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xffffffff)),
                          minimumSize: MaterialStateProperty.all(Size(107, 25)),
                          fixedSize: MaterialStateProperty.all(Size(130, 27)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23)),
                          )),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/all-text-qs'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: AllTextQs(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Mark Assessment',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xffffffff)),
                          minimumSize: MaterialStateProperty.all(Size(60, 25)),
                          fixedSize: MaterialStateProperty.all(Size(80, 27)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23)),
                          )),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/all-results'),
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: ResultMain(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

        //WEB

        : Container(
            width: 400,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        if (teacherData!.subjects.length > 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings:
                                  RouteSettings(name: '/select-subects-ra'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: SelectAssessmentSubject(
                                    subjects: teacherData!.subjects,
                                    tc: teacherData),
                              ),
                            ),
                          );
                        } else if (teacherData!.subjects.length == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/all-Ras'),
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: teacherData,
                                child: AllRAs(
                                  subject: teacherData!.subjects[0],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Assessements',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      '($totalNumRA)',
                      style: TextStyle(
                        color: Color(0xff5f686f),
                        fontFamily: 'Proxima Nova',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChangeNotifierProvider.value(
                              value: teacherData,
                              child: RASubject(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_circle_outline_rounded),
                      color: Color(0xffC54134),
                      iconSize: 20,
                    ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: topThree.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      String? dStat = ts.getdeadlineStatus(topThree[i]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          tileColor: Colors.white,
                          title: Text(
                            '${topThree[i].assessmentTitle}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            'Deadline: ${DateFormat('MMM dd, yyyy, hh:mm a').format(topThree[i].endTime!)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              color: Color(0xff5F686F),
                            ),
                          ),
                          trailing: Text(
                            '$dStat',
                            style: TextStyle(
                              color: Color(0xffC54134),
                              fontFamily: 'Proxima Nova',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                  value: teacherData,
                                  child: EditRA(topThree[i]),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
              ],
            ),
          );
  }
}
