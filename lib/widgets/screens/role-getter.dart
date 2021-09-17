import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/service/db.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/data-providers/parent-datastream.dart';
import 'package:tils_app/widgets/data-providers/student-datastream.dart';
import 'package:tils_app/widgets/data-providers/teacher-datastream.dart';

import 'package:tils_app/widgets/screens/auth_page.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class RoleGetter extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    bool provIsActive = false;
    final authState = Provider.of<User>(context);
    //FirebaseAuth.instance.signOut();
    if (authState != null) {
      isLoggedIn = true;
    }
    return isLoggedIn
        ? FutureProvider<Role>(
          initialData: null,
            create: (ctx) => db.getRole(authState.uid),
            //catchError: (context,_){return Role('teacher');},
            builder: (context, _) {
              final roleProv = Provider.of<Role>(context);
              if (roleProv != null) {
                provIsActive = true;
              }
              return provIsActive && roleProv.getRole == 'teacher'
                  ? TeacherDataStream()
                  : provIsActive && roleProv.getRole == 'student'
                      ? StudentDataStream()
                      : provIsActive && roleProv.getRole == 'parent'
                          ? ParentDataStream()
                          : LoadingScreen();
            },
          )
        : AuthScreen();
  }
}
