import 'package:SIL_app/widgets/student-screens/student_home/student-avatar-panel.dart';
import 'package:SIL_app/widgets/student-screens/time-table-student/student-calendarapp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/widgets/student-screens/edit-student-profile.dart';
import 'package:provider/provider.dart';

class StudentDrawer extends StatelessWidget {
  final StudentUser studData;
  StudentDrawer(this.studData);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StudentAvatarPanel(studData: studData),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      'TimeTable',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    leading: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/assignment-main'),
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider.value(
                            value: studData,
                            child: StudentCalendar(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Log out',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
