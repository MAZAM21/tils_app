import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/models/subject.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

import './class_record_detail.dart';

class ClassRecords extends StatefulWidget {
  static const routeName = '/class-records';
  @override
  _ClassRecordsState createState() => _ClassRecordsState();
}

class _ClassRecordsState extends State<ClassRecords> {
  String enToString(SubjectName name) {
    switch (name) {
      case SubjectName.Jurisprudence:
        return 'Jurisprudence';
        break;
      case SubjectName.Trust:
        return 'Trust';
        break;
      case SubjectName.Conflict:
        return 'Conflict';
        break;
      case SubjectName.Islamic:
        return 'Islamic';
        break;
      default:
        return 'Undeclared';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allClassesData = Provider.of<List<SubjectClass>>(context);
    bool isActive = false;
    if (allClassesData != null) {
      isActive = true;
    }

    return !isActive
        ? LoadingScreen()
        : Scaffold(
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
            body: GridView.builder(
              itemCount: allClassesData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                return GridTile(
                  child: GestureDetector(
                    child: Card(
                      child: Text(
                        allClassesData[i].subjectName,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      color: allClassesData[i].getColor(),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ClassRecordDetail.routeName,
                        arguments: allClassesData[i].id,
                      );
                    },
                  ),
                );
              },
            ),
          );
  }
}
