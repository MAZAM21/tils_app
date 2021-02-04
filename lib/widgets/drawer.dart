import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tils_app/widgets/screens/add-students/add-student-form.dart';

import './screens/time table/edit-timetable-form.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: true, //does not display back button
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today_rounded),
            title: Text('Edit Time Table'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(EditTTForm.routeName);
            },
          ),
          Divider(),
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
