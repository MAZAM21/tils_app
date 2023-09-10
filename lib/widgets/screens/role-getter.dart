import 'package:SIL_app/service/genDb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/models/role.dart';
import 'package:SIL_app/service/db.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/data-providers/admin_datastream.dart';
import 'package:SIL_app/widgets/data-providers/parent-datastream.dart';
import 'package:SIL_app/widgets/data-providers/student-datastream.dart';
import 'package:SIL_app/widgets/data-providers/teacher-datastream.dart';

import 'package:SIL_app/widgets/screens/auth_page.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:SIL_app/widgets/landing-page.dart';

class RoleGetter extends StatefulWidget {
  @override
  State<RoleGetter> createState() => _RoleGetterState();

  static const routeName = '/role-getter';
}

class _RoleGetterState extends State<RoleGetter> {
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     final roleProv = Provider.of<Role?>(context, listen: false);
    //     print(
    //         'teacherdatastream instprovider called instID:${roleProv!.instID}');
    //     //if (!dbActive) {
    //     Provider.of<InstProvider>(context, listen: false)
    //         .setID();
    //     //dbActive = true;
    //     //}
    //   }
    // });
    super.initState();
  }

  final genDB = GeneralDatabase();

  @override
  Widget build(BuildContext context) {
    print('rolegetter called');
    bool isLoggedIn = false;
    final authState = Provider.of<User?>(context);
    ;
    // FirebaseAuth.instance.signOut();
    // print("authstate ${authState!.email} ${authState.uid}");

    if (authState != null) {
      isLoggedIn = true;
    }

    return isLoggedIn
        ? FutureProvider<Role?>(
            initialData: null,
            create: (ctx) => genDB.getRole(authState!.uid),
            builder: (context, _) {
              bool isActive = false;
              final roleProv = Provider.of<Role?>(context);
              if (roleProv != null) {
                // Provider.of<InstProvider>(context, listen: false)
                //     .setID(roleProv!.instID);

                print('roleprov not null: ${roleProv.role}');
                isActive = true;
              }
              return roleProv != null && isActive
                  ? roleProv.getRole == 'teacher'
                      ? TeacherDataStream()
                      : roleProv.getRole == 'student'
                          ? StudentDataStream()
                          : roleProv.getRole == 'parent'
                              ? ParentDataStream()
                              : roleProv.getRole == 'admin'
                                  ? AdminDataStream()
                                  : LoadingScreen()
                  : LoadingScreen(); // Return a loading screen or any widget while role is being fetched.
            },
          )
        : AuthScreen(); // Show a loading screen while authentication state is being checked.
  }
}
