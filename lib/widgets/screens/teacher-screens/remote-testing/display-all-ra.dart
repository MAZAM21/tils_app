
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/models/remote_assessment.dart';

import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/edit-ra.dart';

import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';

class AllRAs extends StatefulWidget {
  static const routeName = '/all-remote-assessments';
  AllRAs({required this.subject});
  final String subject;

  @override
  _AllRAsState createState() => _AllRAsState();
}

class _AllRAsState extends State<AllRAs> {
  final db = DatabaseService();
  final ts = TeacherService();

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    final allRa = Provider.of<List<RAfromDB>>(context);
    final userData = Provider.of<TeacherUser>(context);

    ///a list of all ra's of the subject passed in constructor
    List<RAfromDB> subRa = [];
    int? totalRa;
    bool isActive = false;
    if (allRa != null && userData != null) {
      // filtering allra for all of the subs registered.
      isActive = true;
      subRa = ts.getRAfromSub(allRa, widget.subject);
      totalRa = subRa.length;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Assessments Main',
                style: Theme.of(context).appBarTheme.textTheme!.caption,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          Container(
                            height: 10,
                            color: Theme.of(context).canvasColor,
                          ),
                          Container(
                            color: Theme.of(context).canvasColor,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      '$totalRa',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ChangeNotifierProvider.value(
                                          value: userData,
                                          child: RASubject(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Create Assessment',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffc54134),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: subRa.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              '${subRa[i].assessmentTitle}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            subtitle: Text(
                              '${subRa[i].subject}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 14,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            trailing: subRa[i].isDeployed!
                                ? Text(
                                    'In Progress',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 16,
                                      color: Colors.green[400],
                                    ),
                                  )
                                : Text(
                                    'Not Deployed',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 16,
                                      color: Colors.orange[400],
                                    ),
                                  ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChangeNotifierProvider.value(
                                          value: userData,
                                          child: EditRA(subRa[i])),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
