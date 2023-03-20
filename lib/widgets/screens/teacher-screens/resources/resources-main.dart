import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/teacher-screens/remote-testing/subject-option.dart';
import 'package:tils_app/widgets/screens/teacher-screens/resources/display-resource.dart';

import 'package:tils_app/widgets/screens/teacher-screens/resources/resources-upload-web.dart';

class ResourcesMain extends StatefulWidget {
  static const routeName = '/resource-main';
  const ResourcesMain({
    Key key,
    @required this.sub,
  }) : super(key: key);
  final String sub;

  @override
  State<ResourcesMain> createState() => _ResourcesMainState();
}

class _ResourcesMainState extends State<ResourcesMain> {
  final ts = TeacherService();
  @override
  Widget build(BuildContext context) {
    final resources = Provider.of<List<ResourceDownload>>(context);
    final userData = Provider.of<TeacherUser>(context);

    List<ResourceDownload> subRes = [];
    int totalRes;

    bool isActive = false;
    if (resources.isNotEmpty && userData != null) {
      isActive = true;
      subRes = ts.getSubResources(widget.sub, resources);
      totalRes = subRes.length;
    }
    return isActive
        ? Scaffold(
            appBar: AppBar( title: Text(
                'Resources',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),),
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
                                      '$totalRes',
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
                                          child: ResourcesUpload(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Upload Resource',
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
                      itemCount: totalRes,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              '${subRes[i].topic}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            subtitle: Text(
                              '${subRes[i].subject}',
                              style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                fontSize: 14,
                                color: Color(0xff2b3443),
                              ),
                            ),
                            // trailing:  Text(
                            //         'In Progress',
                            //         style: TextStyle(
                            //           fontFamily: 'Proxima Nova',
                            //           fontSize: 16,
                            //           color: Colors.green[400],
                            //         ),
                            //       ),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DisplayResource(resourceDownload: subRes[i])
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
          )
        : LoadingScreen();
  }
}