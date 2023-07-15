import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:SIL_app/models/teacher-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/screens/all_tabs.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';

class TeacherDataStream extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User>(context).uid;
    bool isActive = false;
    isActive = true;
    return !isActive
        ? LoadingScreen()
        : StreamProvider<TeacherUser?>(
            initialData: null,
            create: (context) => db.streamTeacherUser(uid),
            builder: (context, _) => AllTabs(),
          );
  }
}
