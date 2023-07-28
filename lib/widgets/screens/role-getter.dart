import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/institute-id.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/service/db.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/data-providers/admin_datastream.dart';
import 'package:tils_app/widgets/data-providers/parent-datastream.dart';
import 'package:tils_app/widgets/data-providers/student-datastream.dart';
import 'package:tils_app/widgets/data-providers/teacher-datastream.dart';

import 'package:tils_app/widgets/screens/auth_page.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

// class RoleGetter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     bool isLoggedIn = false;
//     final authState = Provider.of<User?>(context);
//     final db = Provider.of<DatabaseService>(context,
//         listen: false); // Obtain the DatabaseService

//     if (authState != null) {
//       isLoggedIn = true;
//     }

//     return isLoggedIn
//         ? FutureProvider<Role?>(
//             initialData: null,
//             create: (ctx) => db.getRole(authState!.uid),
//             builder: (context, _) {
//               final roleProv = Provider.of<Role?>(context);
//               if (roleProv != null) {
//                 Provider.of<RoleProvider>(context, listen: false)
//                     .setRole(roleProv);
//               }
//               return roleProv != null
//                   ? roleProv.getRole == 'teacher'
//                       ? TeacherDataStream()
//                       : roleProv.getRole == 'student'
//                           ? StudentDataStream()
//                           : roleProv.getRole == 'parent'
//                               ? ParentDataStream()
//                               : roleProv.getRole == 'admin'
//                                   ? AdminDataStream()
//                                   : LoadingScreen()
//                   : LoadingScreen(); // Return a loading screen or any widget while role is being fetched.
//             },
//           )
//         : AuthScreen();
//   }
// }
class RoleGetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    final authState = Provider.of<User?>(context);
    final db = Provider.of<DatabaseService>(context, listen: false);

    if (authState != null) {
      isLoggedIn = true;
    }

    return isLoggedIn
        ? FutureProvider<Role?>(
            initialData: null,
            create: (ctx) => db.getRole(authState!.uid),
            builder: (context, _) {
              final roleProv = Provider.of<Role?>(context);
              if (roleProv != null) {
                Provider.of<RoleProvider>(context, listen: false)
                    .setRole(roleProv);
              }
              return roleProv != null
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
        : AuthScreen(); // Show AuthScreen when user is not authenticated.
  }
}
