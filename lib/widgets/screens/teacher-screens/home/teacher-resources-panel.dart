import 'package:flutter/material.dart';
import 'package:SIL_app/models/resource.dart';
import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/teachers-service.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/resources/resources-upload-web.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/resources/select-resources-subjects.dart';

class TeacherResourcesPanel extends StatelessWidget {
  TeacherResourcesPanel({
    Key? key,
    required this.teacherData,
  }) : super(key: key);

  final ts = TeacherService();

  final TeacherUser? teacherData;

  @override
  Widget build(BuildContext context) {
    final resources = Provider.of<List<ResourceDownload>>(context);
    int totalNumRes = resources.length;
    List<ResourceDownload> topThree = [];
    bool _isActive = false;

    if (resources.isNotEmpty) {
      topThree = ts.getTopThreeRes(resources, teacherData);
      print(topThree.length);
      _isActive = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: RouteSettings(name: '/select-subject-resource'),
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: SelectSubjectResource(
                          teacher: teacherData,
                          subs: teacherData!.subjects,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Resources',
                  style: Theme.of(context).textTheme.titleMedium,
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
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider.value(
                        value: teacherData,
                        child: ResourcesUpload(),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.white,
                    title: Text(
                      '${topThree[i].topic}',
                      style: Theme.of(context).textTheme.headlineMedium,
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
