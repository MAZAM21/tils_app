import 'package:flutter/material.dart';
import './student_records.dart';

import './class_records.dart';

class RecordsPage extends StatelessWidget {
  static const routeName = '/choose-records';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          // appBar: AppBar(
          //   title: Text('Which records would you like?'),
          //   actions: <Widget>[
          //     FlatButton(
          //       child: Text('Back'),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     )
          //   ],
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, StudentRecords.routeName);
                        },
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Text(
                              'Student Records',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ClassRecords.routeName);
                        },
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Text(
                              'Class Records',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
