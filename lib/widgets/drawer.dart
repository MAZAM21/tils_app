import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:SIL_app/widgets/screens/teacher-screens/add-students/add-student-form.dart';
import 'package:SIL_app/widgets/screens/teacher-screens/time%20table/edit-timetable-form.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: <Widget>[
          // AppBar(
          //   title: Text('Hello!'),
          //   automaticallyImplyLeading: true, //does not display back button
          // ),

          // ListTile(
          //   leading: Icon(Icons.calendar_today_rounded),
          //   title: Text('Edit Time Table'),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(EditTTForm.routeName);
          //   },
          // ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Add Students'),
            onTap: () {
              Navigator.of(context).pushNamed(AddStudent.routeName);
            },
          ),
        ],
      ),
    );
  }
}
