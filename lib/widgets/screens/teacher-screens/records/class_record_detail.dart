import 'package:flutter/material.dart';
import 'package:SIL_app/models/class-data.dart';

import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';

class ClassRecordDetail extends StatelessWidget {
  static const routeName = '/class-record-detail';
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final classId = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: FutureBuilder<ClassData>(
          future: db.getClassRecord(classId),
          builder: (ctx, snapShot) {
            if(snapShot.connectionState == ConnectionState.waiting){
              return LoadingScreen();
            }
            if(snapShot.hasError)
            {
              return Text('error in class data builder');
            }
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                          'Number of students present:  ${snapShot.data!.getPresent()}')
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
