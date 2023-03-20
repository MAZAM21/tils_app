import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/service/db.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:SIL_app/widgets/student-screens/student-tabs.dart';

class StudentDataStream extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User>(context).uid;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<StudentUser>(
          initialData: null,
            create: (context) => db.streamStudentUser(uid),
            builder: (context, _) => AllStudentTabs(),
          );
  }
}
