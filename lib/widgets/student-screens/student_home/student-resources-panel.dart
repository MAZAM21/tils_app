import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/remote_assessment.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/student-service.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/add-assignment.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/assignment-main.dart';
import 'package:tils_app/widgets/screens/teacher-screens/manage-students/manage-studs-main.dart';

import 'package:tils_app/widgets/screens/teacher-screens/resources/resources-upload-mobile.dart';
import 'package:tils_app/widgets/screens/teacher-screens/resources/select-subjects-resources.dart';
import 'package:tils_app/widgets/student-screens/resources/select-subjects-resources-student.dart';

class StudentResourcesPanel extends StatelessWidget {
  StudentResourcesPanel({
    Key key,
    @required this.studData,
  }) : super(key: key);

  final ss = StudentService();

  final StudentUser studData;

  @override
  Widget build(BuildContext context) {
    final resources = Provider.of<List<ResourceDownload>>(context);
    int totalNumRes = resources.length;
    List<ResourceDownload> topThree = [];
    bool _isActive = false;

    if (resources.isNotEmpty) {
      topThree = ss.getTopThreeRes(resources, studData);
      print(topThree.length);
      _isActive = true;
    }

    return _isActive
        ? Column(
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
                            value: studData,
                            child: SelectSubjectResourceStudent(
                              student: studData,
                              subs: studData.subjects,
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
          )
        : CircularProgressIndicator();
  }
}
