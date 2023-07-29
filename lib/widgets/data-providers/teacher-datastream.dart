import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/institute-id.dart';
import 'package:tils_app/models/role.dart';

import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/db.dart';
import 'package:tils_app/service/genDb.dart';
import 'package:tils_app/widgets/screens/all_tabs.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';

class TeacherDataStream extends StatefulWidget {
  @override
  State<TeacherDataStream> createState() => _TeacherDataStreamState();
}

class _TeacherDataStreamState extends State<TeacherDataStream> {
  final genDb = GeneralDatabase();
  //bool dbActive = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final roleProv = Provider.of<Role?>(context, listen: false);
        //if (!dbActive) {
        Provider.of<InstProvider>(context, listen: false)
            .setID(roleProv!.instID);
        //dbActive = true;
        //}
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User?>(context)?.uid;
    final role = Provider.of<Role?>(context, listen: false);
    //Provider.of<InstProvider>(context, listen: false).setID(role!.instID);
    final db = Provider.of<DatabaseService>(context, listen: false);
    final inst = role?.instID;
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
