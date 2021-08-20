import 'package:flutter/material.dart';

class AllStudentsAssignment extends StatefulWidget {
  @override
  _AllStudentsAssignmentState createState() => _AllStudentsAssignmentState();
}

class _AllStudentsAssignmentState extends State<AllStudentsAssignment> {
  String _section;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Section selector buttons
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('A'),
                    onPressed: () {
                      setState(() {
                        _section = 'A';
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: _section == 'A'
                          ? MaterialStateProperty.all(Colors.redAccent)
                          : MaterialStateProperty.all(Colors.greenAccent),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Text('B'),
                    onPressed: () {
                      setState(() {
                        _section = 'B';
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: _section == 'B'
                          ? MaterialStateProperty.all(Colors.redAccent)
                          : MaterialStateProperty.all(Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListView.builder(itemBuilder: (context, i) {
              return ListTile(
                leading: CircleAvatar(),
                title: Text(''),
              );
            }),
          ],
        ),
      ),
    );
  }
}
