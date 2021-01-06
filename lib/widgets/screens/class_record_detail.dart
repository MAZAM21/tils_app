import 'package:flutter/material.dart';
import 'package:tils_app/models/subject.dart';

class ClassRecordDetail extends StatelessWidget {
  static const routeName = '/class-record-detail';

  @override
  Widget build(BuildContext context) {
    final classRecord =
        ModalRoute.of(context).settings.arguments as SubjectClass;
    final allPresent = classRecord.getAllPresent();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[Text('Number of students present:  $allPresent')],
            ),
          )
        ],
      ),
    );
  }
}
