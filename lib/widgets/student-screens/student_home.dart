import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student_RA/student-ra-display.dart';
class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studData = Provider.of<StudentUser>(context);
    bool isActive = false;
    if (studData != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 400,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              'Welcome ${studData.name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Proxima Nova Bold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              side: BorderSide.none),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Assessments'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider.value(
                                      value: studData,
                                      child: StudentRADisplay(),
                                    )),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
