import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/role.dart';

import 'package:provider/provider.dart';
import 'package:tils_app/widgets/data-providers/admin_datastream.dart';
import 'package:tils_app/widgets/data-providers/parent-datastream.dart';
import 'package:tils_app/widgets/data-providers/student-datastream.dart';

import 'package:tils_app/widgets/data-providers/teacher-datastream.dart';
import 'package:tils_app/service/genDb.dart';
import 'package:tils_app/widgets/screens/auth_page.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

// // class RoleGetter extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     bool isLoggedIn = false;
// //     final authState = Provider.of<User?>(context);
// //     final db = Provider.of<DatabaseService>(context,
// //         listen: false); // Obtain the DatabaseService

// //     if (authState != null) {
// //       isLoggedIn = true;
// //     }

// //     return isLoggedIn
// //         ? FutureProvider<Role?>(
// //             initialData: null,
// //             create: (ctx) => db.getRole(authState!.uid),
// //             builder: (context, _) {
// //               final roleProv = Provider.of<Role?>(context);
// //               if (roleProv != null) {
// //                 Provider.of<RoleProvider>(context, listen: false)
// //                     .setRole(roleProv);
// //               }
// //               return roleProv != null
// //                   ? roleProv.getRole == 'teacher'
// //                       ? TeacherDataStream()
// //                       : roleProv.getRole == 'student'
// //                           ? StudentDataStream()
// //                           : roleProv.getRole == 'parent'
// //                               ? ParentDataStream()
// //                               : roleProv.getRole == 'admin'
// //                                   ? AdminDataStream()
// //                                   : LoadingScreen()
// //                   : LoadingScreen(); // Return a loading screen or any widget while role is being fetched.
// //             },
// //           )
// //         : AuthScreen();
// //   }
// // }
class RoleGetter extends StatelessWidget {
  final genDB = GeneralDatabase();
  @override
  Widget build(BuildContext context) {
    print('rolegetter called');
    bool isLoggedIn = false;
    final authState = FirebaseAuth.instance.currentUser;
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
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   Provider.of<InstProvider>(context, listen: false)
                //       .setID(roleProv!.instID);
                // });
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

// class RoleGetter extends StatelessWidget {
//   final genDB = GeneralDatabase();
//   @override
//   Widget build(BuildContext context) {
//     print('rolegetter called');
//     bool isLoggedIn = false;
//     final authState = FirebaseAuth.instance.currentUser;
//     print("authstate ${authState!.email} ${authState.uid}");

//     if (authState != null) {
//       isLoggedIn = true;
//     }

//     return isLoggedIn
//         ? FutureProvider<Role>(
//             initialData: Role('none', 'none'),
//             create: (ctx) => genDB.getRole(authState.uid),
//             child: RoleAndInstProviderBuilder(),
//           )
//         : AuthScreen();
//   }
// }

// class RoleAndInstProviderBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final roleProv = Provider.of<Role>(context);

//     // Use FutureBuilder to handle the asynchronous setting of InstProvider's ID
//     return FutureBuilder<Role>(
//       future: Future.value(
//           roleProv), // You can also use FutureProvider and replace Future.value with the appropriate future.
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // Role fetched, set the InstProvider ID
//           final role = snapshot.data;
//           if (role != null) {
//             Provider.of<InstProvider>(context, listen: false)
//                 .setID(role.instID);
//           }

//           return Consumer<Role>(
//             builder: (context, roleProv, child) {
//               return roleProv.getRole == 'teacher'
//                   ? TeacherDataStream()
//                   : roleProv.getRole == 'student'
//                       ? StudentDataStream()
//                       : roleProv.getRole == 'parent'
//                           ? ParentDataStream()
//                           : roleProv.getRole == 'admin'
//                               ? AdminDataStream()
//                               : LoadingScreen();
//             },
//           );
//         } else {
//           // Role is still being fetched, show a loading screen or placeholder widget.
//           return LoadingScreen(); // Replace this with your loading widget if needed.
//         }
//       },
//     );
//   }
// }
