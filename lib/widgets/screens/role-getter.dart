import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/service/db.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/all_tabs.dart';
import 'package:tils_app/widgets/screens/auth_page.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/student-screens/student_home.dart';

class RoleGetter extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    bool provIsActive = false;
    final authState = Provider.of<User>(context);

    if (authState != null) {
      isLoggedIn = true;
    }
    return isLoggedIn
        ? FutureProvider<Role>(
            create: (ctx) => db.getRole(authState.uid),
            builder: (context, _) {
              final roleProv = Provider.of<Role>(context);

              if (roleProv != null) {
                provIsActive = true;
              }
              return provIsActive && roleProv.getRole == 'teacher'
                  ? AllTabs()
                  : provIsActive && roleProv.getRole == 'student'
                      ? StudentHome()
                      : LoadingScreen();
            },
          )
        : AuthScreen();
  }
}
