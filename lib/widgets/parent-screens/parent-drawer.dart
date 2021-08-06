import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello!',
              style: Theme.of(context).textTheme.headline6,
            ),
            automaticallyImplyLeading: true, //does not display back button
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
        ],
      ),
    );
  }
}
