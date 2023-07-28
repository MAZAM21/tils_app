import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/institute-id.dart';

import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/all_tabs.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class TeacherDataStream extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User?>(context)!.uid;
    final inst = Provider.of<InstituteID?>(context);
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<TeacherUser?>(
            initialData: null,
            create: (context) => db.streamTeacherUser(uid, inst!.instID),
            builder: (context, _) => AllTabs(),
          );
  }
}
