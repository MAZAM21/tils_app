import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/service/student-service.dart';
import 'package:SIL_app/widgets/student-screens/student-resources-web/select-subject-resource-student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SIL_app/models/assignment-marks.dart';
import 'package:SIL_app/models/remote_assessment.dart';
import 'package:SIL_app/models/resource.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/teachers-service.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/manage-students/manage-students-main.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/remote-testing/display-all-ra.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/resources/resources-upload-web.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/resources/select-resources-subjects.dart';

class StudentResourcesPanel extends StatelessWidget {
  StudentResourcesPanel({
    Key key,
    @required this.studUser,
  }) : super(key: key);

  final ss = StudentService();

  final StudentUser studUser;

  @override
  Widget build(BuildContext context) {
     final resources = Provider.of<List<ResourceDownload>>(context);
    int totalNumRes = resources.length;
    List<ResourceDownload> topThree = [];
    bool _isActive = false;

    if (resources.isNotEmpty) {
      topThree = ss.getTopThreeRes(resources, studUser);
      print(topThree.length);
      _isActive = true;
    }

    return Container(
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
                          settings:
                              RouteSettings(name: '/select-subject-resource'),
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider.value(
                            value: studUser,
                            child: SelectSubjectResourceStudent(
                              student: studUser,
                              subs: studUser.subjects,
                            ),
                          ),
                        ),
                      );
                },
                child: Text(
                  'Resources',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              // Text(
              //   '($totalNumAM)',
              //   style: TextStyle(
              //     color: Color(0xff5f686f),
              //     fontFamily: 'Proxima Nova',
              //     fontSize: 12,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              Spacer(),

              ///TODO
              ///add navigator to add assessments
            
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
                          title: Text(
                            '${topThree[i].topic}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            '${topThree[i].subject}',
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
          
          
        ],

      ),
    );
  }
}
