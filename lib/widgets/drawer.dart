import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/edit-timetable-form.dart';

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
        ],
      ),
    );
  }
}
