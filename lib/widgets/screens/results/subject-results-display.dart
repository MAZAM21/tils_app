import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/results/result-datagrid.dart';

class SubjectResultsDisplay extends StatelessWidget {
  final ts = TeacherService();
  Widget _buttonBuilder(
    String sub,
    Color col,
    BuildContext context,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ResultDataGrid(sub);
            }));
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
            backgroundColor: MaterialStateProperty.all(col),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          child: Text(sub),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tData = Provider.of<TeacherUser>(context);
    final mySubs = tData.subjects;
    return Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: <Widget>[
                  for (var x = 0; x < mySubs.length; x++)
                    _buttonBuilder(
                      mySubs[x],
                      ts.getColor(mySubs[x]),
                      context,
                    ),
                ],
              ),
            )
          ],
        ));
  }
}
