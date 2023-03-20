import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/widgets/student-screens/edit-student-profile.dart';
import 'package:provider/provider.dart';

class StudentDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stuprov = Provider.of<StudentUser>(context);
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
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ChangeNotifierProvider.value(
                    value: stuprov,
                    child: EditStudentProfile(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
