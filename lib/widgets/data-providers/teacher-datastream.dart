import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/institute-id.dart';
import 'package:tils_app/models/role.dart';

import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/all_tabs.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class TeacherDataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User?>(context)!.uid;
    final db = Provider.of<DatabaseService>(context, listen: false);
    final role = Provider.of<RoleProvider>(context, listen: false);
    final inst = role.role!.instID;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<TeacherUser?>(
            initialData: null,
            create: (context) => db.streamTeacherUser(uid, inst),
            builder: (context, _) => AllTabs(),
          );
  }
}
