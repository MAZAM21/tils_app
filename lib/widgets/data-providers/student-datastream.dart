import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/student-screens/student-tabs.dart';

class StudentDataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final uid = Provider.of<User>(context).uid;
    bool isActive = false;
    if (uid != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : StreamProvider<StudentUser?>(
            initialData: null,
            create: (context) => db.streamStudentUser(uid),
            builder: (context, _) => AllStudentTabs(),
          );
  }
}
